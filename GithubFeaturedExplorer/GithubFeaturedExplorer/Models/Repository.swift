//
//  Repository.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import Foundation

struct SearchResponse: Codable {
    let totalCount: Int
    let items: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct Repository: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlURL: String
    let homepage: String?
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let isPrivate: Bool
    let owner: Owner
    let license: License?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case htmlURL = "html_url"
        case homepage
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case isPrivate = "private"
        case owner
        case license
    }
}

extension Repository {
    static let mock = Repository(
        id: 1,
        name: "name + longer name",
        fullName: "repo full long name",
        description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
        htmlURL: "htmlURL",
        homepage: "featured.com",
        language: "language",
        stargazersCount: 10,
        watchersCount: 10,
        forksCount: 10,
        isPrivate: false,
        owner: Owner.mock,
        license: License.mock
    )
}

struct Owner: Codable, Hashable {
    let login: String
    let id: Int
    let avatarUrlString: String
    let htmlURL: String
    
    var avatarUrl: URL? {
        URL(string: avatarUrlString)
    }

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrlString = "avatar_url"
        case htmlURL = "html_url"
    }
}

extension Owner {
    static let mock = Owner(
        login: "login",
        id: 1,
        avatarUrlString: "avatarURL",
        htmlURL: "htmlURL"
    )
}
