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
    var avatarUrl: String?
    var gravatarId: String?
    var type: ProfileType = .User
    var siteAdmin: Bool = false
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var hireable: Bool = false
    var publicRepositories: Int = 0
    var publicGists: Int = 0
    var followers: Int = 0
    var following: Int = 0
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    private mutating func mapping(map: Map) {
        login <- map["login"]
        id <- map["id"]
        avatarUrl <- map["avatar_url"]
        gravatarId <- map["gravatar_id"]
        type <- map["type"]
        siteAdmin <- map["site_admin"]
        company <- map["company"]
        blog <- map["blog"]
        location <- map["location"]
        email <- map["email"]
        hireable <- map["hireable"]
        publicRepositories <- map["public_repos"]
        publicGists <- map["public_gists"]
        followers <- map["followers"]
        following <- map["following"]
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
    
    private func canEnhance(request: Request, modifier: RequestModifier) -> Bool {
        return modifier is TestModifier
    }
    
    private func enhanceRequest(inout request: Request, modifier: RequestModifier) {
        onRequest()
    }
    
    private func deenhanceResponse(response: Response<NSData?>, modifier: RequestModifier) -> Response<NSData?> {
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
    
    override func spec() {
        describe("Router") {
            var router: Router!
            beforeEach {
                router = Router(baseURL: NSURL(string: "https://api.github.com")!, objectMapper: ObjectMapper())
            }
            it("supports Void to String request") {
                var zensponse: String?
                router.request(GitHubEndpoints.zen) { response in
                    println("### Zen: \(response.output)")
                    zensponse = response.output
                }
                
                expect(zensponse).toEventuallyNot(beNil(), timeout: 10)
            }

            it("supports Void to Object request") {
                var profile: UserProfile?
                router.request(GitHubEndpoints.userProfile.endpoint("brightify")) { response in
                    println("### Profile: \(response.output)")
                    profile = response.output
                }
                
                expect(profile).toEventuallyNot(beNil(), timeout: 10)
                expect(profile?.type).toEventually(equal(UserProfile.ProfileType.Organization), timeout: 10)
            }
            
            it("supports custom RequestEnhancers") {
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