//
//  SettingsScreen.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 05/06/2025.
//

import SwiftUI

enum Appearance: String, CaseIterable, Identifiable {
    case unspecified = "Unspecified"
    case light = "Light"
    case dark = "Dark"
    
    var id: String { self.rawValue }
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
            case .light:
                return .light
            case .dark:
                return .dark
            case .unspecified:
                return .unspecified
        }
    }
}

struct SettingsScreen: View {
    @AppStorage("appearance") private var selectedAppearance: Appearance = .unspecified
    
    var body: some View {
        VStack {
            Text("Select Appearance")
                .font(.headline)
                .padding()
            
            Picker("Appearance", selection: $selectedAppearance) {
                ForEach(Appearance.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing], 20)
            
            Spacer()
        }
        .onChange(of: selectedAppearance, initial: true, { _, newValue in
            let window = UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first
            
            window?.overrideUserInterfaceStyle = newValue.userInterfaceStyle
        })
    }
}

#Preview {
    SettingsScreen()
}
