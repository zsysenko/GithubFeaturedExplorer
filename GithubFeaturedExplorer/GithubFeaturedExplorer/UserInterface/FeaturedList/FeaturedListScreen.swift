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
    @Environment(FeaturedListModel.self) private var model
    @Environment(\.navigate) private var navigate
    
    @State private var selectedFilter: ActiveFilter? = nil
    @State private var isSettingsOpened = false
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            filtersControll
            
            if model.isLoading {
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
                    DateRangePickerScreen(
                        selectedRange:
                            Binding(
                                get: { model.selectedDataRange },
                                set: { model.selectedDataRange = $0 }
                            ),
                        onDismiss: {
                            self.selectedFilter = nil
                        }
                    )
                    
                case .languageFilter:
                    LanguageFilterScreen(
                        languages: model.languages,
                        selectedLanguage:
                            Binding(
                                get: { model.selectedLanguage },
                                set: {model.selectedLanguage = $0}
                            ),
                        onDismiss: {
                            self.selectedFilter = nil
                        }
                    )
            }
        })
        .onChange(of: model.selectedDataRange, initial: true, { _, _ in
            Task {
                await model.fetchFeaturedList()
            }
        })
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("Trending")
                .font(.title)
                .bold()
            
            Text("See what the GitHub community is most excited about.")
                .multilineTextAlignment(.center)
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 10) {
            List(model.filteredList, rowContent: { repository in
                RepositoryCell(repository: repository)
                    .onTapGesture {
                        navigate(.push(.repoDetail(repository: repository)))
                    }
            })
        }
    }
    
    private var filtersControll: some View {
        HStack(spacing: 20) {
            FilterControlView(
                selectedValue: model.selectedDataRange.title,
                isExpanded: selectedFilter == .dateRangeFilter
            ) {
                selectedFilter = .dateRangeFilter
            }
            
            FilterControlView(
                selectedValue: model.selectedLanguage ?? "All Languages",
                isExpanded: selectedFilter == .languageFilter
            ) {
                selectedFilter = .languageFilter
            }
        }
    }
}

struct FilterControlView: View {
    var selectedValue: String
    var isExpanded: Bool = false
    
    let onTap: () -> Void
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 5) {
                Text(selectedValue)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeIn(duration: 0.2), value: isExpanded)
            }
            .font(.callout)
        }
    }
}

struct RepositoryCell: View {
    
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 5) {
                Text("\(repository.name)")
                    .foregroundStyle(.blue)
                +
                Text(" \\ \(repository.owner.login)")
                    .bold()
                    .foregroundStyle(.blue)
                
                Spacer()
            }
            
            Text(repository.description ?? " - ")
                .font(.caption)
            
            HStack(spacing: 10) {
                Text(repository.language ?? "")
                    .font(.caption)
                    .bold()
                
                StarsView(starsCount: repository.stargazersCount)
                ForksView(forkCount: repository.forksCount)
                
                Spacer()
                
                AvatarView(url: repository.owner.avatarUrl)
                    .frame(maxWidth: 30)
            }
            
        }
        .frame(maxHeight: .infinity)
    }
}

struct AvatarView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
            
        } placeholder: {
            Circle()
                .fill(.gray)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                }
        }
    }
}

struct StarsView: View {
    let starsCount: Int
    
    var body: some View {
        HStack {
            Image(systemName: "star")
            Text("\(starsCount)")
        }
        .font(.caption)
    }
}

struct ForksView: View {
    let forkCount: Int
    
    var body: some View {
        HStack {
            Image(systemName: "tuningfork")
            Text("\(forkCount)")
        }
        .font(.caption)
    }
}

#Preview {
    FeaturedListScreen()
        .environment(
            FeaturedListModel(apiService: ApiService())
        )
}
