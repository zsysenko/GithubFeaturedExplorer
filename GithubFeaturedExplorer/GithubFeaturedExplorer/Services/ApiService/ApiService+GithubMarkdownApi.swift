//
//  ApiService+GithubMarkdownApi.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import Foundation

protocol GithubMarkdownApi: Actor {
    func convertMarkDownToHtml(markdownUrlString: String) async throws -> String
}

extension ApiService: GithubMarkdownApi {
    
    func convertMarkDownToHtml(markdownUrlString: String) async throws -> String {
        guard
            let url = URL(string: "https://api.github.com/markdown"),
            let markdownUrl = URL(string: markdownUrlString)
        else {
            throw ApiError.invalidUrl
        }
        
        let markdownUrlRequest = URLRequest(url: markdownUrl)
        let markdownData = try await perfomDataRequest(markdownUrlRequest)
        guard let markdownString = String(data: markdownData, encoding: .utf8) else {
            throw ApiError.custom(message: "Cannot convert markdownString to data.")
        }
        
        let markdown = Markdown(text: markdownString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let data = try JSONEncoder().encode(markdown)
        request.httpBody = data
        
        let htmlData: Data = try await perfomDataRequest(request)
        guard let htmlString = String(data: htmlData, encoding: .utf8) else {
            throw ApiError.custom(message: "Cannot convert htmlData to string.")
        }
        return htmlString
    }
}
