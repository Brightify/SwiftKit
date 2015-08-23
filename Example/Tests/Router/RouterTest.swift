//
//  RouterTest.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 09/07/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

private struct UserProfile: Mappable {
    
    var login: String?
    var id: Int?
    var type: ProfileType = .User
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    private mutating func mapping(map: Map) {
        login <- map["login"]
        id <- map["id"]
        type <- map["type"]
    }
    
    enum ProfileType: String {
        case User = "User"
        case Organization = "Organization"
    }
}

private struct TestEnhancer: RequestEnhancer {
    private struct TestModifier: RequestModifier { }
    
    private let onRequest: () -> ()
    private let onResponse: () -> ()
    
    private var priority = 0
    
    private init(onRequest: () -> (), onResponse: () -> ()) {
        self.onRequest = onRequest
        self.onResponse = onResponse
    }
    
    private func canEnhance(request: Request) -> Bool {
        return request.modifiers.filter { $0 is TestModifier }.count > 0
    }
    
    private func enhanceRequest(inout request: Request) {
        onRequest()
    }
    
    private func deenhanceResponse(response: Response<NSData?>) -> Response<NSData?> {
        onResponse()
        return response
    }
}

class RouterTest: QuickSpec {
    
    private struct GitHubEndpoints {
        static let zen = GET<Void, String>("/zen")
        static let userProfile = Target<GET<Void, UserProfile>, String> { "/users/\($0.urlSafe)" }
        static let userRepositories = Target<GET<Void, String>, String> { "/users/\($0.urlSafe)/repos" }
        static let test = GET<Void, String>("/zen", TestEnhancer.TestModifier())
    }
    
    private struct GitHubMockEndpoints {
        static let zen: MockEndpoint = (method: "GET", url: "https://api.github.com/zen", response: "Practicality beats purity.", statusCode: 200)
        static let userProfile: String -> MockEndpoint = { (method: "GET", url: "https://api.github.com/users/\($0.urlSafe)", response: "{\"login\": \"\($0)\", \"id\": 100, \"type\": \"Organization\"}", statusCode: 200) }
    }
    
    override func spec() {
        describe("Router") {
            var performer: MockRequestPerformer!
            var router: Router!
            beforeEach {
                performer = MockRequestPerformer()
                router = Router(baseURL: NSURL(string: "https://api.github.com")!, objectMapper: ObjectMapper(), requestPerformer: performer)
            }
            it("supports Void to String request") {
                performer.endpoints.append(GitHubMockEndpoints.zen)
                var zensponse: String?
                router.request(GitHubEndpoints.zen) { response in
                    zensponse = response.output
                }
                
                expect(zensponse).toEventually(equal("Practicality beats purity."))
            }

            it("supports Void to Object request") {
                performer.endpoints.append(GitHubMockEndpoints.userProfile("brightify"))
                var profile: UserProfile?
                router.request(GitHubEndpoints.userProfile.endpoint("brightify")) { response in
                    profile = response.output
                }
                
                expect(profile).toEventuallyNot(beNil())
                expect(profile?.id).toEventually(equal(100))
                expect(profile?.login).toEventually(equal("brightify"))
                expect(profile?.type).toEventually(equal(UserProfile.ProfileType.Organization))
            }
            
            it("supports custom RequestEnhancers") {
                performer.endpoints.append(GitHubMockEndpoints.zen)
                var firstEnhancerCalledTimes: (request: Int, response: Int) = (0, 0)
                var secondEnhancerCalledTimes: (request: Int, response: Int) = (0, 0)

                var firstEnhancer = TestEnhancer(onRequest:
                    {
                        expect(firstEnhancerCalledTimes.request) == 0
                        expect(firstEnhancerCalledTimes.response) == 0
                        expect(secondEnhancerCalledTimes.request) == 0
                        expect(secondEnhancerCalledTimes.response) == 0
                        firstEnhancerCalledTimes.request++
                    }, onResponse: {
                        expect(firstEnhancerCalledTimes.request) == 1
                        expect(firstEnhancerCalledTimes.response) == 0
                        expect(secondEnhancerCalledTimes.request) == 1
                        expect(secondEnhancerCalledTimes.response) == 0
                        firstEnhancerCalledTimes.response++
                    })
                var secondEnhancer = TestEnhancer(onRequest:
                    {
                        expect(firstEnhancerCalledTimes.request) == 1
                        expect(firstEnhancerCalledTimes.response) == 0
                        expect(secondEnhancerCalledTimes.request) == 0
                        expect(secondEnhancerCalledTimes.response) == 0
                        secondEnhancerCalledTimes.request++
                    }, onResponse: {
                        expect(firstEnhancerCalledTimes.request) == 1
                        expect(firstEnhancerCalledTimes.response) == 1
                        expect(secondEnhancerCalledTimes.request) == 1
                        expect(secondEnhancerCalledTimes.response) == 0
                        secondEnhancerCalledTimes.response++
                    })
                secondEnhancer.priority = 100
                
                router.registerRequestEnhancer(firstEnhancer)
                router.registerRequestEnhancer(secondEnhancer)
                
                router.request(GitHubEndpoints.test) { _ in }
                
                expect(firstEnhancerCalledTimes.request) == 1
                expect(secondEnhancerCalledTimes.request) == 1
                
                expect(firstEnhancerCalledTimes.response).toEventually(equal(1), timeout: 10)
                expect(secondEnhancerCalledTimes.response).toEventually(equal(1), timeout: 10)
            }
        }
        
    }
    
}