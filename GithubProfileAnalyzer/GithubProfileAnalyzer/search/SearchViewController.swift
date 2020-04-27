//
//  ViewController.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var combinedResults = [(SearchResult, UserDetails?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print("View started")
        fetchUsers()
        fetchUserDetails()
    }
    
    // MARK: Private Methods
    private func fetchUsers() {
        let searchService = SearchService()
        searchService.fetchUsers(username: "haydn") { response in
            for item in response.items {
                self.combinedResults.append((item, nil))
            }
            self.fetchUserDetails()
        }
    }
    
    private func fetchUserDetails() {
        let searchService = SearchService()
        for (index, item) in combinedResults.enumerated() {
            searchService.fetchUserDetails(detailsUrl: item.0.detailsUrl) { response in
                self.combinedResults[index].1 = response
                if index == self.combinedResults.count - 1 {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }
        
        let result = combinedResults[indexPath.row]
        cell.usernameLabel.text = result.0.login
        cell.profilePictureImageView.load(url: URL(string: result.0.avatarUrl)!)
        
        if let bio = result.1?.bio {
            cell.descriptionLabel.text = bio
        }
        if let name = result.1?.name {
            cell.nameLabel.text = name
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.Search.tableViewRowHeight
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
            
        }
    }
}
