//
//  FeaturedListModel.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI
import Observation

@MainActor @Observable
final class FeaturedListModel {
    private let apiService: GithubSearchApi
    
    var isLoading = false
    var error: Error? = nil
    
    private var featuredList: [Repository] = []
    var filteredList: [Repository] {
        if selectedLanguage == nil {
            return featuredList
        } else {
            return featuredList.filter { $0.language == selectedLanguage }
        }
    }
    
    var selectedDataRange: DateRange? = .thisMonth
    var selectedLanguage: String? = nil
    
    var languages: [String] {
        let objectsSet = Set(featuredList.compactMap{ $0.language })
        return Array(objectsSet)
    }
    
    init(apiService: GithubSearchApi = ApiService()) {
        self.apiService = apiService
    }
    
    func fetchFeaturedList() async {
        isLoading = true
        defer { isLoading = false }
        
        selectedLanguage = nil
        
        do {
            let dateString = selectedDataRange?.calculatedDateRange ?? ""
            let list = try await apiService.fetchTrending(for: dateString)
            
            featuredList = list
        } catch {
            self.error = error as? ApiError
        }
    }
}
