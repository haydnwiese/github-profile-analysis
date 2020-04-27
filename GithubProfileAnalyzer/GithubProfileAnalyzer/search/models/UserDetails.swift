//
//  UserDetails.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-27.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import Foundation

struct UserDetails {
    let name: String
    let bio: String
}

extension UserDetails {
    init?(_ json: [String: Any]) {
        guard let name = json["name"] as? String,
            let bio = json["bio"] as? String
        else {
            print("UserDetails init failed")
            return nil
        }
        self.name = name
        self.bio = bio
    }
}
