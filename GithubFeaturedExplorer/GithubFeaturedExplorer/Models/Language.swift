//
//  Language.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import SwiftUI

typealias JsonLanguage = [String: Double]

struct Language: Decodable {
    let name: String
    let value: Double
    
    var color: Color {
        return Language.languageColors[name] ?? .gray
    }
}

extension Language {
    static var languageColors: [String: Color] = [
        "JavaScript": .yellow,
        "Python": .blue,
        "Java": .orange,
        "Jupyter Notebook": .pink,
        "Rust": .green,
        "TypeScript": .cyan,
        "Swift": .mint,
        "Ruby": .red,
        "Go": .teal,
    ]
}
