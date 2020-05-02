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
    let company: String?
}

extension UserDetails {
    init(_ json: [String: Any]) {
        self.name = json["name"] as? String
        self.bio = json["bio"] as? String
        self.company = json["company"] as? String
    }
}
