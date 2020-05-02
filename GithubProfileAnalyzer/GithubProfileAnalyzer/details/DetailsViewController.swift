//
//  DetailsViewController.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-01.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var userDetails: (SearchResult, UserDetails)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = userDetails?.0 {
            navigationItem.title = user.login
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
