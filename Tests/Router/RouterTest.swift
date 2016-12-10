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
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    fileprivate mutating func mapping(_ map: Map) {
        map["login"].mapValueTo(field: &login, transformWith: StringTransformation())
        map["id"].mapValueTo(field: &id, transformWith: IntTransformation())
        map["type"].mapValueTo(field: &type, transformWith: EnumTransformation<ProfileType>())
    }
    
    enum ProfileType: String {
        case User = "User"
        case Organization = "Organization"
    }
}

fileprivate struct TestEnhancer: RequestEnhancer {
    fileprivate struct TestModifier: RequestModifier { }
    
    private let onRequest: () -> Void
    private let onResponse: () -> Void
    
    fileprivate var priority = 0
    
    fileprivate init(onRequest: @escaping () -> Void, onResponse: @escaping () -> Void) {
        self.onRequest = onRequest
        self.onResponse = onResponse
    }
    
    fileprivate func canEnhance(request: Request) -> Bool {
        return request.modifiers.filter { $0 is TestModifier }.count > 0
    }
    
    fileprivate func enhance(request: inout Request) {
        onRequest()
    }
    
    fileprivate func deenhance(response: Response<Data?>) -> Response<Data?> {
        onResponse()
        return response
    }
}

class RouterTest: QuickSpec {
    
    private struct GitHubEndpoints {
        static let zen = GET<Void, String>("/zen")
        static let userProfile = Target<GET<Void, UserProfile>, String> { "/users/\($0.urlPathSafe)" }
        static let userRepositories = Target<GET<Void, String>, String> { "/users/\($0.urlPathSafe)/repos" }
        static let test = GET<Void, String>("/zen", TestEnhancer.TestModifier())
        static let nonGithubEndpoint = GET<Void, String>("ftp://test")
        static let multipleInputTarget = Target<GET<Void, String>, (string: String, int: Int)> { "/zen/\($0)/\($1)" }
    }
    
    private struct GitHubMockEndpoints {
        static let zen: MockEndpoint = (method: "GET", url: "https://api.github.com/zen", response: "Practicality beats purity.", statusCode: 200)
        static let userProfile: (String) -> MockEndpoint = { (method: "GET", url: "https://api.github.com/users/\($0.urlPathSafe)", response: "{\"login\": \"\($0)\", \"id\": 100, \"type\": \"Organization\"}", statusCode: 200) }
        static let nonGithubEndpoint: MockEndpoint = (method: "GET", url: "ftp://test", response: "Works like a charmer.", statusCode: 200)
    }
    
    override func spec() {
        describe("Router") {
            var performer: MockRequestPerformer!
            var router: Router!
            beforeEach {
                performer = MockRequestPerformer()
                router = Router(baseURL: URL(string: "https://api.github.com")!, objectMapper: ObjectMapper(), requestPerformer: performer)
            }
            it("supports Void to String request") {
                performer.endpoints.append(GitHubMockEndpoints.zen)
                var zensponse: String?
                _ = router.request(GitHubEndpoints.zen) { response in
                    zensponse = response.output
                }
                
                expect(zensponse).toEventually(equal("Practicality beats purity."))
            }

            it("supports Void to Object request") {
                performer.endpoints.append(GitHubMockEndpoints.userProfile("brightify"))
                var profile: UserProfile?
                _ = router.request(GitHubEndpoints.userProfile.endpoint("brightify")) { response in
                    profile = response.output
                }
                
                expect(profile).toEventuallyNot(beNil())
                expect(profile?.id).toEventually(equal(100))
                expect(profile?.login).toEventually(equal("brightify"))
                expect(profile?.type).toEventually(equal(UserProfile.ProfileType.Organization))
            }
            
            it("supports absolute url in endpoint") {
                performer.endpoints.append(GitHubMockEndpoints.nonGithubEndpoint)
                var stringData: String?
                _ = router.request(GitHubEndpoints.nonGithubEndpoint) { response in
                    stringData = response.output
                }
                
                expect(stringData).toEventually(equal("Works like a charmer."))
            }
            
            it("supports multiple inputs in target") {
                //    let endpoint = GitHubEndpoints.multipleInputTarget.endpoint(string: "", int: 4)
            }
            
            it("supports custom RequestEnhancers") {
                performer.endpoints.append(GitHubMockEndpoints.zen)
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
                var secondEnhancer = TestEnhancer(onRequest:
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
                    })
                secondEnhancer.priority = 100
                
                router.registerRequestEnhancer(firstEnhancer)
                router.registerRequestEnhancer(secondEnhancer)
                
                _ = router.request(GitHubEndpoints.test) { _ in }
                
                expect(firstEnhancerCalledTimes.request) == 1
                expect(secondEnhancerCalledTimes.request) == 1
                
                expect(firstEnhancerCalledTimes.response).toEventually(equal(1), timeout: 10)
                expect(secondEnhancerCalledTimes.response).toEventually(equal(1), timeout: 10)
            }
        }
        
    }
    
}
