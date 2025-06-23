//
//  LanguageFilterScreen.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI

struct FilterScreen<Object: FilterObjectProtocol>: View {
    let viewModel: FiltersViewModel<Object>
    
    @State private var searchText: String = ""
    private var objects: [Object] {
        if searchText.isEmpty {
           return viewModel.objects
        } else {
            return viewModel.objects
                .filter {$0.title.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            List(objects, id: \.self) { language in
                Button {
                    select(object: language)
                } label: {
                    HStack {
                        Text(language.title)
                        Spacer()
                        if viewModel.selectedObject == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            if viewModel.isOptionalAvailable {
                Button {
                    select(object: nil)
                } label: {
                    Text("Clear")
                        .frame(maxWidth: .infinity, maxHeight: 30)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 50)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
    }
    
    private func select(object: Object?) {
        viewModel.selectedObject = object
        onDismiss()
    }
}

#Preview {
    FilterScreen(
        viewModel: FiltersViewModel(
            objects: ["Swift", "Python"],
            selectedObject: .constant("Swift"),
            isOptionalAvailable: true
        ),
        onDismiss: {}
    )
}
