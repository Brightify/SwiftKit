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

class RouterTest: QuickSpec {
    
    private struct GitHubEndpoints {
        static let zen = GET<Void, String>("/zen")
        static let userProfile = Target<GET<Void, UserProfile>, String> { "/users/\($0.urlSafe)" }
        static let userRepositories = Target<GET<Void, String>, String> { "/users/\($0.urlSafe)/repos" }
    }
    
    override func spec() {
        describe("Router") {
            let router = Router(baseURL: NSURL(string: "https://api.github.com")!, objectMapper: ObjectMapper())

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
        }
    }
    
}

/*
import Foundation
import Moya

// MARK: - Provider setup

let GitHubProvider = MoyaProvider<GitHub>()


// MARK: - Provider support

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

public enum GitHub {
    case Zen
    case UserProfile(String)
    case UserRepositories(String)
}

extension GitHub : MoyaTarget {
    public var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    public var path: String {
        switch self {
        case .Zen:
            return "/zen"
        case .UserProfile(let name):
            return "/users/\(name.URLEscapedString)"
        case .UserRepositories(let name):
            return "/users/\(name.URLEscapedString)/repos"
        }
    }
    public var method: Moya.Method {
        return .GET
    }
    public var parameters: [String: AnyObject] {
        switch self {
        case .UserRepositories(_):
            return ["sort": "pushed"]
        default:
            return [:]
        }
    }
    
    public var sampleData: NSData {
        switch self {
        case .Zen:
            return "Half measures are as bad as nothing at all.".dataUsingEncoding(NSUTF8StringEncoding)!
        case .UserProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .UserRepositories(let name):
            return "[{\"name\": \"Repo Name\"}]".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

public func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString!
}*/