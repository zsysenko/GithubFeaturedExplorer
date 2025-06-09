//
//  ApiService+GithubFetured.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import Foundation

protocol GithubSearchApi {
    func fetchTrending(for period: String) async throws -> [Repository]
}

extension ApiService: GithubSearchApi {
    func fetchTrending(for period: String) async throws -> [Repository] {
        guard var components = URLComponents(string: "https://api.github.com/search/repositories") else {
            throw ApiError.invalidUrl
        }
        components.queryItems = [
            URLQueryItem(name: "q", value: "created:>\(period)"),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc")
        ]
        guard let url = components.url else {
            throw ApiError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.preview", forHTTPHeaderField: "Accept")
        
        let searchResponse: SearchResponse = try await perfomRequest(request)
        return searchResponse.items
    }
    
}
