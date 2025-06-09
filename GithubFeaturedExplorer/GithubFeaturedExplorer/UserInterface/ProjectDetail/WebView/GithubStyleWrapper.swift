//
//  GithubStyleWrapper.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 07/06/2025.
//

import Foundation

final class GithubStyleWrapper {
    
    static func wrap(htmlString: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css">
            <style>
                body {
                    box-sizing: border-box;
                    min-width: 200px;
                    max-width: 980px;
                    margin: 0 auto;
                    padding: 45px;
                }
            </style>
        </head>
        <body class="markdown-body">
            \(htmlString)
        </body>
        </html>
        """
    }
}
