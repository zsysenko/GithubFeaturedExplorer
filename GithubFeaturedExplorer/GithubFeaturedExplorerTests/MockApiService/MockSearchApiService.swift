//
//  MockApiService.swift
//  GithubFeaturedExplorerTests
//
//  Created by EVGENY SYSENKA on 23/06/2025.
//

import Foundation
@testable import GithubFeaturedExplorer

actor MockApiService: GithubSearchApi  {
    
    private var featuredResults: [Repository] = []
    private var needThrowError: ApiError?
    
    func setFeatured(results: [Repository]) async {
        featuredResults = results
    }
    
    func setError(error: ApiError) {
        needThrowError = error
    }
    
    func fetchTrending(for period: String) async throws -> [Repository] {
        if let needThrowError {
            throw needThrowError
        }
        
        return featuredResults
    }
}
