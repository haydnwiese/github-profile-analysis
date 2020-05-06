//
//  DetailsService.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-02.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

class DetailsService {
    private let session = URLSession.shared
    
    func fetchRepos(reposUrl: String, _ callback: @escaping (_ response: [RepoDetails]) -> Void) {
        let url = URL(string: reposUrl)!
        let request = ServiceHelper.getUrlRequest(url)
        
        session.dataTask(with: request, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // TODO: handle error
                print((response as! HTTPURLResponse).statusCode)
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? Array<[String: Any]> {
                var repos = [RepoDetails]()
                for item in json {
                    if let details = RepoDetails(json: item) {
                        repos.append(details);
                    }
                }
                
                callback(repos)
            }
        }).resume()
    }
    
    func fetchNumberOfCommits(username: String, repoName: String, _ callback: @escaping (_ response: Int) -> Void) {
        let urlString = String(format: K.Details.contributionsUrl, username, repoName)
        let url = URL(string: urlString)!
        let request = ServiceHelper.getUrlRequest(url)
        
        session.dataTask(with: request, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // TODO: handle error
                print((response as! HTTPURLResponse).statusCode)
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? Array<[String: Any]> {
                for item in json {
                    if let login = item["login"] as? String,
                        login == username,
                        let contributions = item["contributions"] as? Int {
                        callback(contributions)
                    }
                }
            }
        }).resume()
    }
}
