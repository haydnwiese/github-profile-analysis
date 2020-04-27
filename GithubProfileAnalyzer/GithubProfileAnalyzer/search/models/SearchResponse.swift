//
//  SearchResponse.swift
//  GithubProfileAnalyzer
//
//  Created by Haydn Wiese on 2020-04-26.
//  Copyright © 2020 Haydn Wiese. All rights reserved.
//

struct SearchResponse {
    let totalCount: Int
    let incompleteResults: Bool
    var items: [SearchResult]
}

extension SearchResponse {
    init?(response: [String: Any]) {
        guard let totalCount = response["total_count"] as? Int,
            let incompleteResults = response["incomplete_results"] as? Bool,
            let items = response["items"] as? Array<[String: Any]>
        else {
            print("SearchResponse init failed")
            return nil
        }
        
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        
        self.items = [SearchResult]()
        for item in items {
            guard let searchResult = SearchResult(json: item)
            else {
                print("SearchResponse init failed")
                return nil
            }
            
            self.items.append(searchResult)
        }
    }
}
