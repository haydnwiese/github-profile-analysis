//
//  SearchService.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

class SearchService {
    
    func fetchUsers(username: String, _ callback: @escaping (_ response: SearchResponse) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: username)]
        var urlComps = URLComponents(string: K.Search.baseUrl)!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        let request = ServiceHelper.getUrlRequest(url)
        
        ServiceHelper.performGetRequest(request: request) { response in
            if let json = response as? [String: Any], let searchResponse = SearchResponse(response: json) {
                callback(searchResponse)
            }
        }
    }
    
    func fetchUserDetails(detailsUrl: String, _ callback: @escaping (_ response: UserDetails) -> Void) {
        let url = URL(string: detailsUrl)!
        let request = ServiceHelper.getUrlRequest(url)
        
        ServiceHelper.performGetRequest(request: request) { response in
            if let json = response as? [String: Any] {
                callback(UserDetails(json))
            }
        }
    }
}


