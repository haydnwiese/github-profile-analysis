//
//  UserDetails.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-27.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

struct UserDetails {
    let name: String?
    let bio: String?
}

extension UserDetails {
    init(_ json: [String: Any]) {
        if let name = json["name"] as? String {
            self.name = name
        } else {
            self.name = nil
        }
        
        if let bio = json["bio"] as? String {
            self.bio = bio
        } else {
            self.bio = nil
        }
    }
}
