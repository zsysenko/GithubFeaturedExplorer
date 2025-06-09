//
//  LanguageFilterScreen.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI

struct LanguageFilterScreen: View {
    let languages: [String]
    
    @Binding var selectedLanguage: String?
    var onDismiss: () -> Void
    
    var body: some View {
        List(languages, id: \.self) { language in
            Button {
                selectedLanguage = language
                onDismiss()
            } label: {
                HStack {
                    Text(language)
                    Spacer()
                    if selectedLanguage == language {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    LanguageFilterScreen(
        languages: ["Swift", "Phyton"],
        selectedLanguage: .constant("Swift"),
        onDismiss: {}
    )
}
