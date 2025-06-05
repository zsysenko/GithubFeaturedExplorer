//
//  FeaturedListModel.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI

@MainActor @Observable
final class FeaturedListModel {
    private let apiService: GithubFeaturedApi
    
    var isLoading = false
    
    var featuredList: [Repository] = []
    var filteredList: [Repository] {
        if selectedLanguage == nil {
            return featuredList
        } else {
            return featuredList.filter { $0.language == selectedLanguage }
        }
    }
    
    var selectedDataRange: DateRange = .today
    var selectedLanguage: String? = nil
    
    var languages: [String] {
        featuredList
            .compactMap { $0.language }
            .reduce(into: [String]()) { partialResult, language in
                if !partialResult.contains(language) {
                    partialResult.append(language)
                }
            }
    }
    
    init(apiService: GithubFeaturedApi) {
        self.apiService = apiService
    }
    
    func fetchFeaturedList() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let dateString = getDate(for: selectedDataRange)
            let list = try await apiService.fetchTrending(for: String(dateString))
            
            selectedLanguage = nil
            featuredList = list
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func getDate(for range: DateRange) -> String {
        guard let date = Calendar.current.date(byAdding: .day, value: range.value, to: Date()) else { return "" }
        let stringDate = date.string(with: .apiDate)
        return stringDate
    }
}
