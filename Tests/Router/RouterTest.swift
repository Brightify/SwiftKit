//
//  RouterTest.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 09/07/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftKit

fileprivate struct UserProfile: Mappable {
    
    var login: String?
    var id: Int?
    var type: ProfileType = .User
    
    init(_ data: DeserializableData) throws {
        try mapping(data)
    }
    
    fileprivate mutating func mapping(_ data: inout MappableData) throws {
        data["login"].map(&login)
        data["id"].map(&id)
        try data["type"].map(&type, using: EnumTransformation())
    }
    
    enum ProfileType: String {
        case User = "User"
        case Organization = "Organization"
    }
}

fileprivate struct TestEnhancer: RequestEnhancer {
    fileprivate struct TestModifier: RequestModifier { }
    
    fileprivate let priority: RequestEnhancerPriority
    
    private let onRequest: () -> Void
    private let onResponse: () -> Void
    
    fileprivate init(onRequest: @escaping () -> Void, onResponse: @escaping () -> Void, priority: RequestEnhancerPriority = .normal) {
        self.onRequest = onRequest
        self.onResponse = onResponse
        self.priority = priority
    }
    
    fileprivate func enhance(request: inout Request) {
        if request.modifiers.contains(where: { $0 is TestModifier }) {
            onRequest()
        }
    }
    
    fileprivate func deenhance(response: inout Response<SupportedType>) {
        if response.request.modifiers.contains(where: { $0 is TestModifier }) {
            onResponse()
        }
    }
}

import SwiftyJSON

class RouterTest: QuickSpec {
    
    private struct GitHubEndpoints: EndpointProvider {
        static let zen = GET<Void, String>("/zen")
        static let test = GET<Void, String>("/zen", modifiers: TestEnhancer.TestModifier())
        static let nonGithubEndpoint = GET<Void, String>("ftp://test", modifiers: BaseUrlRequestModifier.Ignore)

        static func userProfile(name: String) -> GET<Void, UserProfile> {
            return create("/users/\(name.urlPathSafe)")
        }
        
        static func userRepositories(name: String) -> GET<Void, String> {
            return create("/users/\(name.urlPathSafe)/repos")
        }
        
        static func multipleInputTarget(string: String, int: Int) -> GET<Void, String> {
            return create("/zen/\(string)/\(int)")
        }
    }
    
    private struct GitHubMockEndpoints {
        static let zen: MockEndpoint = (method: "GET", url: "https://api.github.com/zen?", response: "\"Practicality beats purity.\"", statusCode: 200)
        static let userProfile: (String) -> MockEndpoint = { (method: "GET", url: "https://api.github.com/users/\($0.urlPathSafe)?", response: "{\"login\": \"\($0)\", \"id\": 100, \"type\": \"Organization\"}", statusCode: 200) }
        static let nonGithubEndpoint: MockEndpoint = (method: "GET", url: "ftp://test?", response: "\"Works like a charmer.\"", statusCode: 200)
    }
    
    override func spec() {
        describe("Router") {
            var performer: MockRequestPerformer!
            var router: Router!
            beforeEach {
                performer = MockRequestPerformer()
                router = Router(requestPerformer: performer, callbackQueue: DispatchQueue.global(qos: .background))
                router.register(requestModifiers: BaseUrlRequestModifier(baseUrl: "https://api.github.com"))
            }
            it("supports Void to String request") {
                performer.register(endpoint: GitHubMockEndpoints.zen)
                var zensponse: String?
                router.request(GitHubEndpoints.zen) { response in
                    zensponse = response.result.value
                }
                
                expect(zensponse).toEventually(equal("Practicality beats purity."))
            }

            it("supports Void to Object request") {
                performer.register(endpoint: GitHubMockEndpoints.userProfile("brightify"))
                var profile: UserProfile?
                router.request(GitHubEndpoints.userProfile(name: "brightify")) { response in
                    profile = response.result.value
                }
                
                expect(profile).toEventuallyNot(beNil())
                expect(profile?.id).toEventually(equal(100))
                expect(profile?.login).toEventually(equal("brightify"))
                expect(profile?.type).toEventually(equal(UserProfile.ProfileType.Organization))
            }
            
            it("supports absolute url in endpoint") {
                performer.register(endpoint: GitHubMockEndpoints.nonGithubEndpoint)
                var stringData: String?
                router.request(GitHubEndpoints.nonGithubEndpoint) { response in
                    stringData = response.result.value
                }
                
                expect(stringData).toEventually(equal("Works like a charmer."))
            }
            
            it("supports multiple inputs in target") {
                //    let endpoint = GitHubEndpoints.multipleInputTarget.endpoint(string: "", int: 4)
            }
            
            it("supports custom RequestEnhancers") {
                performer.register(endpoint: GitHubMockEndpoints.zen)
                var firstEnhancerCalledTimes: (request: Int, response: Int) = (0, 0)
                var secondEnhancerCalledTimes: (request: Int, response: Int) = (0, 0)

                let firstEnhancer = TestEnhancer(onRequest:
                    {
                        expect(firstEnhancerCalledTimes.request) == 0
                        expect(firstEnhancerCalledTimes.response) == 0
                        expect(secondEnhancerCalledTimes.request) == 0
                        expect(secondEnhancerCalledTimes.response) == 0
                        firstEnhancerCalledTimes.request += 1
                    }, onResponse: {
                        expect(firstEnhancerCalledTimes.request) == 1
                        expect(firstEnhancerCalledTimes.response) == 0
                        expect(secondEnhancerCalledTimes.request) == 1
                        expect(secondEnhancerCalledTimes.response) == 0
                        firstEnhancerCalledTimes.response += 1
                    })
                let secondEnhancer = TestEnhancer(onRequest:
                    {
                        expect(firstEnhancerCalledTimes.request) == 1
                        expect(firstEnhancerCalledTimes.response) == 0
                        expect(secondEnhancerCalledTimes.request) == 0
                        expect(secondEnhancerCalledTimes.response) == 0
                        secondEnhancerCalledTimes.request += 1
                    }, onResponse: {
                        expect(firstEnhancerCalledTimes.request) == 1
                        expect(firstEnhancerCalledTimes.response) == 1
                        expect(secondEnhancerCalledTimes.request) == 1
                        expect(secondEnhancerCalledTimes.response) == 0
                        secondEnhancerCalledTimes.response += 1
                }, priority: .low)
                
                router.register(requestEnhancers: firstEnhancer)
                router.register(requestEnhancers: secondEnhancer)
                
                router.request(GitHubEndpoints.test) { _ in }
                
                expect(firstEnhancerCalledTimes.request).toEventually(equal(1), timeout: 10)
                expect(secondEnhancerCalledTimes.request).toEventually(equal(1), timeout: 10)
                
                expect(firstEnhancerCalledTimes.response).toEventually(equal(1), timeout: 10)
                expect(secondEnhancerCalledTimes.response).toEventually(equal(1), timeout: 10)
            }
        }
        
    }
    
}
