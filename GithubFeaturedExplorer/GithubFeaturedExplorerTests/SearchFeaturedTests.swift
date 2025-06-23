//
//  SearchFeaturedTests.swift
//  GithubFeaturedExplorerTests
//
//  Created by EVGENY SYSENKA on 23/06/2025.
//

import XCTest
@testable import GithubFeaturedExplorer

@MainActor
final class SearchFeaturedTests: XCTestCase {
    
    private var featuredRsults: [Repository] {
        [
            Repository.mock(id: 1, name: "Test repo 1", language: "Swift"),
            Repository.mock(id: 2, name: "Test repo 2", language: "Python"),
            Repository.mock(id: 3, name: "Test repo 3", language: "Swift")
        ]
    }
    
    func testFetchFeaturedList_Success() async {
        let mockApiService = MockApiService()
        await mockApiService.setFeatured(results: featuredRsults)
        let sut = FeaturedListModel(apiService: mockApiService)
        
        await sut.fetchFeaturedList()
        
        XCTAssertEqual(sut.filteredList.count, 3)
        XCTAssertEqual(sut.languages.count, 2)
        XCTAssertNil(sut.error)
    }
    
    func testFetchFeaturedList_WithLanguageFilter() async {
        let mockApiService = MockApiService()
        
        await mockApiService.setFeatured(results: featuredRsults)
        let sut = FeaturedListModel(apiService: mockApiService)
        
        await sut.fetchFeaturedList()
        sut.selectedLanguage = "Swift"
        
        XCTAssertEqual(sut.filteredList.count, 2)
        XCTAssertNil(sut.error)
    }
    
    func testFetchFeaturedList_Error() async {
        let mockApiService = MockApiService()
        await mockApiService.setError(error: ApiError.invalidUrl)
        let sut = FeaturedListModel(apiService: mockApiService)
        
        await sut.fetchFeaturedList()
        
        XCTAssertEqual(sut.filteredList.count, 0)
        
        let error = try? XCTUnwrap(sut.error as? ApiError)
        XCTAssertEqual(error, .invalidUrl)
    }
}
