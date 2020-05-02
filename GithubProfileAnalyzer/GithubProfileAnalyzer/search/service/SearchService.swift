//
//  SearchService.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

class SearchService {
    private let session = URLSession.shared
    
    func fetchUsers(username: String, _ callback: @escaping (_ response: SearchResponse) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: username)]
        var urlComps = URLComponents(string: K.Search.baseUrl)!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        let request = ServiceHelper.getUrlRequest(url)
        
        session.dataTask(with: request, completionHandler: {data, response, error in
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
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                callback(UserDetails(json))
            }
        }).resume()
    }
}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}


