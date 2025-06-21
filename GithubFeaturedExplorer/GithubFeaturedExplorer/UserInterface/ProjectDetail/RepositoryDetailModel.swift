//
//  RepositoryDetailModel.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 06/06/2025.
//

import Foundation

typealias GitHubDetailsApi = GithubRepoApi & GithubMarkdownApi

@MainActor
@Observable

final class RepositoryDetailModel {
    private let apiService: GitHubDetailsApi
    
    let repository: Repository
    
    var readmeState: ViewState<String> = .idle
    var languagesState: ViewState<[Language]> = .idle
    
    deinit {
        print("RepositoryDetailModel deinit")
    }
    
    private var owner: String {
        return repository.owner.login
    }
    
    private var repo: String {
        return repository.name
    }
    
    init(
        repository: Repository,
        apiService: GitHubDetailsApi = ApiService()
    ) {
        self.repository = repository
        self.apiService = apiService
    }
    
    func load() async {
        Task {
            await fetchReadme()
        }
        Task {
            await fetchLanguages()
        }
    }
    
    func fetchReadme() async {
        readmeState = .loading
        
        do {
            let readme = try await apiService.fetchReadme(owner: owner , repo: repo)
            let readmeHtmlString = try await apiService.convertMarkDownToHtml(markdownUrlString: readme.download_url)
            
            readmeState = .sucsess(readmeHtmlString)
            
        } catch {
            print(error.localizedDescription)
            readmeState = .error(error)
        }
    }
    
    func fetchLanguages() async {
        languagesState = .loading
        
        do {
            let languages = try await apiService.fetchLanguages(owner: owner , repo: repo)
            let languagesSorted = languages.sorted {$0.value > $1.value}
            
            languagesState = .sucsess(languagesSorted)
            
        } catch {
            print(error.localizedDescription)
            languagesState = .error(error)
        }
    }
    
    //TODO: Need auth. Skip for now.
    
//    func fetchCollaborators() async {
//        do {
//            let collaborators = try await apiService.fetchCollaborators(owner: owner , repo: repo)
//            self.collaborators = collaborators
//        } catch {
//            self.error = error
//        }
//    }
}
