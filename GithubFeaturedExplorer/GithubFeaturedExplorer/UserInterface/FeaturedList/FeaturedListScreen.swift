//
//  FeaturedList.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import SwiftUI

enum ActiveFilter: Identifiable  {
    var id: UUID {
        UUID()
    }
    
    case dateRangeFilter
    case languageFilter
}

struct FeaturedListScreen: View {
    @Environment(\.navigate) private var navigate
    
    @State private var viewModel: FeaturedListModel
    
    @State private var selectedFilter: ActiveFilter? = nil
    @State private var isSettingsOpened = false
    
    init(viewModel: FeaturedListModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            headerView
            filtersControll
                .padding(.top, 10)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                
                Spacer()
            } else {
                contentView
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSettingsOpened.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $isSettingsOpened, content: {
            SettingsScreen()
        })
        .sheet(item: $selectedFilter, content: { selectedFilter in
            switch selectedFilter {
                case .dateRangeFilter:
                    dateRangeFiltersScreen
                    
                case .languageFilter:
                    languageFiltersScreen
            }
        })
        .onChange(of: viewModel.selectedDataRange, initial: true, { old, new in
            if viewModel.featuredList.isEmpty || old != new {
                Task {
                    await viewModel.fetchFeaturedList()
                }
            }
        })
    }
    
    private var headerView: some View {
        VStack(spacing: 5) {
            Text("Trending")
                .font(.title)
                .bold()
            
            Text("See what the GitHub community is most excited about.")
                .multilineTextAlignment(.center)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 10) {
            List(viewModel.filteredList, rowContent: { repository in
                RepositoryCell(repository: repository)
                    .onTapGesture {
                        navigate(.push(.repoDetail(repository: repository)))
                    }
            })
            .frame(maxWidth: 700, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(uiColor: UIColor.systemGroupedBackground)
        )
    }
    
    private var filtersControll: some View {
        HStack(spacing: 20) {
            FilterControlView(
                selectedValue: viewModel.selectedDataRange?.title ?? "All time",
                isExpanded: selectedFilter == .dateRangeFilter
            ) {
                selectedFilter = .dateRangeFilter
            }
            
            FilterControlView(
                selectedValue: viewModel.selectedLanguage ?? "All Languages",
                isExpanded: selectedFilter == .languageFilter
            ) {
                selectedFilter = .languageFilter
            }
        }
    }
    
    private var dateRangeFiltersScreen: some View {
        let dateFilterViewModel = FiltersViewModel(
            objects: DateRange.allCases,
            selectedObject: $viewModel.selectedDataRange
        )
        return FilterScreen(
            viewModel: dateFilterViewModel,
            onDismiss: {
                self.selectedFilter = nil
            }
        )
    }
    
    private var languageFiltersScreen: some View {
        let languageFilterViewModel = FiltersViewModel(
            objects: viewModel.languages,
            selectedObject: $viewModel.selectedLanguage,
            isOptionalAvailable: true
        )
        return FilterScreen(
            viewModel: languageFilterViewModel,
            onDismiss: {
                self.selectedFilter = nil
            }
        )
    }
}

struct RepositoryCell: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RepoTitleView(
                repo: repository.name,
                owner: repository.owner.login
            )
            
            Text(repository.description ?? " - ")
                .font(.caption)
            
            HStack(spacing: 10) {
                Text(repository.language ?? "")
                    .bold()
                
                StarsView(starsCount: repository.stargazersCount)
                ForksView(forkCount: repository.forksCount)

                Spacer()
                
                AvatarView(url: repository.owner.avatarUrl)
                    .frame(maxWidth: 40)
            }
            .font(.caption)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    FeaturedListScreen(viewModel: FeaturedListModel(apiService: ApiService()))
}
