//
//  DetailsViewController.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-01.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import UIKit
import Charts

class DetailsViewController: UIViewController {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!
    @IBOutlet weak var repoLanguageChartView: PieChartView!
    @IBOutlet weak var commitLanguageChartView: PieChartView!
    @IBOutlet weak var commitsRepoChartView: PieChartView!
    
    var userDetails: (SearchResult, UserDetails)?
    var profilePicture: UIImage?
    var repos = [(RepoDetails, Int?)]()
    let detailsService = DetailsService()
    
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
        if let reposUrl = userDetails?.0.reposUrl {
            detailsService.fetchRepos(reposUrl: reposUrl) { response in
                for repo in response {
                    self.repos.append((repo, nil))
                }
                DispatchQueue.main.async {
                    self.repoCountLabel.text = "\(response.count) public repos"
                    self.generateRepoLanguageChart()
                    self.fetchCommits()
                }
            }
        }
    }
    
    private func fetchCommits(index: Int = 0) {
        if index >= repos.count {
            DispatchQueue.main.async {
                self.generateCommitsPerRepoChart()
            }
            return
        }
        
        if repos[index].0.isFork {
            fetchCommits(index: index + 1)
        } else {
            detailsService.fetchNumberOfCommits(username: userDetails!.0.login, repoName: repos[index].0.name) { response in
                self.repos[index].1 = response
                self.fetchCommits(index: index + 1)
            }
        }
    }
    
    private func generateCommitsPerRepoChart() {
        var commitsPerRepo = [String: Int]()
        
        for repo in repos {
            if let commitsNum = repo.1, !repo.0.isFork {
                commitsPerRepo[repo.0.name] = commitsNum
            }
        }
        
        let vals = Array(commitsPerRepo.values).map { Double($0) }
        let labels = Array(commitsPerRepo.keys)
        generateChartView(chartView: commitsRepoChartView, dataPoints: labels, values: vals)
        generateCommitsPerLanguageChart(commitsPerRepo)
    }
    
    private func generateCommitsPerLanguageChart(_ commitsPerRepo: [String: Int]) {
        var commitsPerLanguage = [Language: Int]()
        var repoLanguages = [String: Language]()
        
        for repo in repos {
            if let lang = repo.0.language {
                repoLanguages[repo.0.name] = lang
            }
        }
        
        for (repoName, commitCount) in commitsPerRepo {
            if let lang = repoLanguages[repoName] {
                if commitsPerLanguage[lang] == nil {
                    commitsPerLanguage[lang] = commitCount
                } else {
                    commitsPerLanguage[lang]! += commitCount
                }
            }
        }
        
        let vals = Array(commitsPerLanguage.values).map { Double($0) }
        let labels = Array(commitsPerLanguage.keys).map { $0.rawValue }
        generateChartView(chartView: commitLanguageChartView, dataPoints: labels, values: vals)
    }
    
    private func generateRepoLanguageChart() {
        var languageAmount = [Language: Int]()

        for repo in repos {
            if let lang = repo.0.language {
                if languageAmount[lang] != nil {
                    // Increment amount for language if it's already in dict
                    languageAmount[lang]! += 1
                } else {
                    // Add language to dict with value of 1
                    languageAmount[lang] = 1
                }
            }
        }

        let vals = Array(languageAmount.values).map { Double($0) }
        let labels = Array(languageAmount.keys).map { $0.rawValue }
        generateChartView(chartView: repoLanguageChartView, dataPoints: labels, values: vals)
    }
    
    private func generateChartView(chartView: PieChartView, dataPoints: [String], values: [Double]) {
        var dataEntries = [ChartDataEntry]()
        for (i,label) in dataPoints.enumerated() {
            let dataEntry = PieChartDataEntry(value: values[i], label: label, data: label as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        pieChartData.setDrawValues(false)
        
        chartView.legend.enabled = true
        let marker:BalloonMarker = BalloonMarker(color: UIColor(red: 93/255, green: 186/255, blue: 215/255, alpha: 1), font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0))
        marker.minimumSize = CGSize(width: 75.0, height: 35.0)
        chartView.marker = marker
        chartView.rotationEnabled = false
        chartView.drawEntryLabelsEnabled = false
        chartView.holeColor = nil
        chartView.drawHoleEnabled = true
        
        chartView.data = pieChartData
    }
    
    // TODO: Update to have set color for each language
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}
