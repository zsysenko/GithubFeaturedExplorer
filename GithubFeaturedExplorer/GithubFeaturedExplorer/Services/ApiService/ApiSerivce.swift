//
//  ApiSerive.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI
import UIKit

typealias JSONDictionary = [String: Any]

enum ApiError: Error {
    case custom(message: String)
    
    case invalidResponse
    case invalidStatusCode(code: Int)
}

actor ApiService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func perfomRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
//        guard let url = URL(string: urlString) else {
//            throw ApiError.custom(message: "Invalid URL")
//        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse, data.count > 0 else {
            throw ApiError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw ApiError.invalidStatusCode(code: response.statusCode)
        }
        
        let object = try JSONDecoder().decode(T.self, from: data)
        return object
    }
}


