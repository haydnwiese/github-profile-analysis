//
//  SearchService.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

class SearchService {
    let session = URLSession.shared
    
    func fetchUsers(username: String, _ callback: @escaping (_ response: SearchResponse) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: username)]
        var urlComps = URLComponents(string: K.Search.baseUrl)!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        session.dataTask(with: url, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // TODO: handle error
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let searchResponse = SearchResponse(response: json) {
                    callback(searchResponse)
                }
            }
        }).resume()
    }
    
    func fetchUserDetails(detailsUrl: String, _ callback: @escaping (_ response: UserDetails) -> Void) {
        let url = URL(string: detailsUrl)!
        
        session.dataTask(with: url, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // TODO: handle error
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                if let details = UserDetails(json) {
                    callback(details)
                }
            }
        }).resume()
    }
}


