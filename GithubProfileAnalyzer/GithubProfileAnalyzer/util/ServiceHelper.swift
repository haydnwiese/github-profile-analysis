//
//  ServiceHelper.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-02.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

class ServiceHelper {
    private static let session = URLSession.shared
    
    static func getUrlRequest(_ url: URL) -> URLRequest {
        let loginData = String(format: "%@:%@", K.Search.username, ProcessInfo.processInfo.environment["access_token"]!)
        let base64LoginData = loginData.toBase64()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    static func performGetRequest(request: URLRequest, _ callback: @escaping (_ response: Any) -> Void) {
        session.dataTask(with: request, completionHandler: {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // TODO: handle error
                print((response as! HTTPURLResponse).statusCode)
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                callback(json)
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
