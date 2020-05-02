//
//  ServiceHelper.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-02.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

class ServiceHelper {
    static func getUrlRequest(_ url: URL) -> URLRequest {
        let loginData = String(format: "%@:%@", K.Search.username, ProcessInfo.processInfo.environment["access_token"]!)
        let base64LoginData = loginData.toBase64()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
