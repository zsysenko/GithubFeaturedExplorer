//
//  ApiService+GithubFetured.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import Foundation

protocol GithubFeaturedApi {
    func fetchTrending(for period: String) async throws -> [Repository]
    func fetchProject(projectId: String) async throws
}

extension ApiService: GithubFeaturedApi {
    
    func fetchTrending(for period: String) async throws -> [Repository] {
        var components = URLComponents(string: "https://api.github.com/search/repositories")!
        components.queryItems = [
            URLQueryItem(name: "q", value: "created:>\(period)"),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc")
        ]
        

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.preview", forHTTPHeaderField: "Accept")
        
        let searchResponse: SearchResponse = try await perfomRequest(request)
        
        return searchResponse.items
        
    }
    
    func fetchProject(projectId: String) async throws {
        
    }
}
