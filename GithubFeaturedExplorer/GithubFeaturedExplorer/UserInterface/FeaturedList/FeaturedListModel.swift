//
//  FeaturedListModel.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import Foundation

@MainActor @Observable
final class FeaturedListModel {
    
    var featuredList: [Repository] = []
    
    private let apiService: GithubFeaturedApi
    
    init(apiService: GithubFeaturedApi) {
        self.apiService = apiService
    }
    
    func fetchFeaturedList() async {
        do {
            let calendar = Calendar.current
            let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
            let dateString = ISO8601DateFormatter().string(from: sevenDaysAgo).prefix(10) // "YYYY-MM-DD"
            
            let list = try await apiService.fetchTrending(for: String(dateString))
            featuredList = list
            
            print(list)
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
