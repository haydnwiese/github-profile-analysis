//
//  SearchResult.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

struct SearchResult {
    let login: String
    let avatarUrl: String
    let detailsUrl: String
    let reposUrl: String
}

extension SearchResult {
    init?(json: [String: Any]) {
        guard let login = json["login"] as? String,
            let avatarUrl = json["avatar_url"] as? String,
            let detailsUrl = json["url"] as? String,
            let reposUrl = json["repos_url"] as? String
        else {
            print("SearchResult init failed")
            return nil
        }
        
        self.login = login
        self.avatarUrl = avatarUrl
        self.detailsUrl = detailsUrl
        self.reposUrl = reposUrl
    }
}
