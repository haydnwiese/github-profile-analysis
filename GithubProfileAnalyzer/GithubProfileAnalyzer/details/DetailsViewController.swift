//
//  DetailsViewController.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-01.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!
    
    var userDetails: (SearchResult, UserDetails)?
    var profilePicture: UIImage?
    var repos = [RepoDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserDetails()
        fetchRepos()
    }
    
    // MARK: Private Methods
    private func updateUserDetails() {
        // Update screen title with username
        navigationItem.title = userDetails?.0.login
        
        profilePictureImageView.image = profilePicture
        if let details = userDetails?.1 {
            nameLabel.text = details.name
            organizationLabel.text = details.company
        }
    }
    
    private func fetchRepos() {
        let detailsService = DetailsService()
        if let reposUrl = userDetails?.0.reposUrl {
            detailsService.fetchRepos(reposUrl: reposUrl) { response in
                self.repos += response
            }
        }
    }
}
