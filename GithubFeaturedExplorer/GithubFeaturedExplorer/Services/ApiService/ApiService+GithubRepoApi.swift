//
//  ApiService+GithubRepoApi.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import Foundation

protocol GithubRepoApi: Actor {
    func fetchReadme(owner: String, repo: String) async throws -> Readme
    func fetchCollaborators(owner: String, repo: String) async throws -> [Collaborator]
    func fetchLanguages(owner: String, repo: String) async throws -> [Language]
}

extension ApiService: GithubRepoApi {
    
    var baseUrl: String {
        "https://api.github.com/repos"
    }
    
    func fetchReadme(owner: String, repo: String) async throws -> Readme {
        guard let url = URL(string: "\(baseUrl)/\(owner)/\(repo)/readme") else {
            throw ApiError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let readme: Readme = try await perfomRequest(request)
        return readme
    }
    
    func fetchCollaborators(owner: String, repo: String) async throws -> [Collaborator] {
        guard let url = URL(string: "\(baseUrl)/\(owner)/\(repo)/collaborators") else {
            throw ApiError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let collaborators: [Collaborator] = try await perfomRequest(request)
        return collaborators
    }
    
    func fetchLanguages(owner: String, repo: String) async throws -> [Language] {
        guard let url = URL(string: "\(baseUrl)/\(owner)/\(repo)/languages") else {
            throw ApiError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let jsonLanguages: JsonLanguage = try await perfomRequest(request)
        let languages = jsonLanguages.map { Language(name: $0.key, value: $0.value) }
        
        return languages
    }
}
