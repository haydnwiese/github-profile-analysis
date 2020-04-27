//
//  ViewController.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let session = URLSession.shared
    var url = URL(string: "https://api.github.com/search/users?q=haydn")!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View started")
        fetchUsers()
    }
    
    // MARK: Private Methods
    private func fetchUsers() {
        let searchService = SearchService()
        searchService.fetchUsers(username: "haydn", callback: { response in
            print(response.items[0])
        })
    }
}

