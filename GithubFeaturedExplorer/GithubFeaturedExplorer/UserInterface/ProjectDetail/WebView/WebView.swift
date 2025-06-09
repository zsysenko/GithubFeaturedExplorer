//
//  WebView.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 06/06/2025.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}

struct WebView: View {    
    let htmlString: String?
    
    var body: some View {
        if let htmlString {
            let styledHtml = GithubStyleWrapper.wrap(htmlString: htmlString)
            WebViewRepresentable(htmlString: styledHtml)
        }
    }
}
