//
//  ViewController.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var combinedResults = [(SearchResult, UserDetails?)]()
    let MAX_RESULTS: Int = 20
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Add recognizer to dismiss keyboard when screen is tapped anywhere
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Ensures empty cells are not shown
        tableView.tableFooterView = UIView()
        
        print("View started")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on this screen
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Ensure row is deselected on return to search screen
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        setupActivityIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Ensure the navigation bar is shown on the details screen
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let detailsViewController = segue.destination as? DetailsViewController else {
            fatalError("Unexpected destination")
        }
        
        guard let selectedSearchCell = sender as? SearchTableViewCell else {
            fatalError("Unexpected sender")
        }
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            fatalError()
        }
        
        let selectedResult = combinedResults[indexPath.row]
        detailsViewController.userDetails = selectedResult as? (SearchResult, UserDetails)
        detailsViewController.profilePicture = selectedSearchCell.profilePictureImageView.image
    }
}

// MARK: Private Methods
private extension SearchViewController {
    func fetchUsers(username: String) {
        indicator.startAnimating()
        
        let searchService = SearchService()
        searchService.fetchUsers(username: username) { response in
            for item in response.items {
                self.combinedResults.append((item, nil))
            }
            let newArraySize = min(self.MAX_RESULTS, self.combinedResults.count + 1)
            self.combinedResults = Array(self.combinedResults[0..<newArraySize - 1])
            self.fetchUserDetails(SearchService())
        }
    }
    
    func fetchUserDetails(index: Int = 0,_ searchService: SearchService) {
        if index >= combinedResults.count {
            DispatchQueue.main.async {
                // Stop activity indicator
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
                self.tableView.reloadData()
            }
            return
        }
        let url = combinedResults[index].0.detailsUrl
        searchService.fetchUserDetails(detailsUrl: url) { response in
            self.combinedResults[index].1 = response
            self.fetchUserDetails(index: index + 1, searchService)
        }
    }
    
    func setupActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = .medium
        indicator.center = view.center
        view.addSubview(indicator)
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
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
        cell.descriptionLabel.text = result.1?.bio
        cell.nameLabel.text = result.1?.name
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.Search.tableViewRowHeight
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide the keyboard
        searchBar.resignFirstResponder()
        
        if let searchTerm = searchBar.text, searchTerm != "" {
            // Clear current results when new search is made
            combinedResults.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            fetchUsers(username: searchTerm)
        }
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
