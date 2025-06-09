//
//  Collaborator.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import Foundation

struct Collaborator: Decodable, Hashable {
    
    let id: String
    let login: String
    let avatar_url: String
}
