//
//  RepoDetails.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-02.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

struct RepoDetails {
    let name: String
    let isFork: Bool
    let commitsUrl: String
    let language: Language?
}

enum Language: String, CaseIterable {
    case java = "Java"
    case python = "Python"
    case swift = "Swift"
    case javascript = "JavaScript"
    case typescript = "TypeScript"
}

extension RepoDetails {
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let isFork = json["fork"] as? Bool,
            var commitsUrl = json["commits_url"] as? String else {
                print("RepoDetails init failed")
                return nil
        }
        
        // Remove unused path variable in url string
        commitsUrl.removeLast(6)
        
        self.name = name
        self.isFork = isFork
        self.commitsUrl = commitsUrl
        
        if let language = json["language"] as? String {
            self.language = Language(rawValue: language)
        } else {
            self.language = nil
        }
    }
}
