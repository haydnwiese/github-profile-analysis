//
//  DetailsViewController.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-05-01.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

import UIKit
import Charts

class DetailsViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!
    @IBOutlet weak var repoLanguageChartView: PieChartView!
    
    var userDetails: (SearchResult, UserDetails)?
    var profilePicture: UIImage?
    var repos = [RepoDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserDetails()
        fetchRepos()
        
        let players = ["Ozil", "Ramsey", "Haydn", "John", "Sierra", "Laca", "Auba", "Xhaka", "Torreira"]
        let goals = [6, 1, 1, 1, 1, 26, 30, 8, 10]
        repoLanguageChartView.delegate = self
        createRepoLanguageChart(dataPoints: players, values: goals.map{ Double($0) })
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
    
    private func createRepoLanguageChart(dataPoints: [String], values: [Double]) {
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
        
        repoLanguageChartView.legend.enabled = true
        let marker:BalloonMarker = BalloonMarker(color: UIColor(red: 93/255, green: 186/255, blue: 215/255, alpha: 1), font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 25.0, right: 7.0))
        marker.minimumSize = CGSize(width: 75.0, height: 35.0)
        repoLanguageChartView.marker = marker
        repoLanguageChartView.rotationEnabled = false
        repoLanguageChartView.drawEntryLabelsEnabled = false
        repoLanguageChartView.holeColor = nil
        repoLanguageChartView.drawHoleEnabled = true
        repoLanguageChartView.data = pieChartData
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
