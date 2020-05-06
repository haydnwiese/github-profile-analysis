//
//  DetailsService.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-02.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

class DetailsService {
    
    func fetchRepos(reposUrl: String, _ callback: @escaping (_ response: [RepoDetails]) -> Void) {
        let url = URL(string: reposUrl)!
        let request = ServiceHelper.getUrlRequest(url)
        
        ServiceHelper.performGetRequest(request: request) { response in
            if let json = response as? Array<[String: Any]> {
                var repos = [RepoDetails]()
                for item in json {
                    if let details = RepoDetails(json: item) {
                        repos.append(details);
                    }
                }

                callback(repos)
            }
        }
    }
    
    func fetchNumberOfCommits(username: String, repoName: String, _ callback: @escaping (_ response: Int) -> Void) {
        let urlString = String(format: K.Details.contributionsUrl, username, repoName)
        let url = URL(string: urlString)!
        let request = ServiceHelper.getUrlRequest(url)
        
        ServiceHelper.performGetRequest(request: request) { response in
            if let json = response as? Array<[String: Any]> {
                for item in json {
                    if let login = item["login"] as? String,
                        login == username,
                        let contributions = item["contributions"] as? Int {
                        callback(contributions)
                    }
                }
            }
        }
    }
}
