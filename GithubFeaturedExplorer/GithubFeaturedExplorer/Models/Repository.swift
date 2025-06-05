//
//  Repository.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import Foundation

struct SearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Repository: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlURL: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case htmlURL = "html_url"
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case owner
    }
}

extension Repository {
    static let mock = Repository(
        id: 1,
        name: "name",
        fullName: "fullName",
        description: "description",
        htmlURL: "htmlURL",
        language: "language",
        stargazersCount: 10,
        watchersCount: 10,
        forksCount: 10,
        owner: Owner.mock
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
