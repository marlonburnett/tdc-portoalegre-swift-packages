//
//  SearchService.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation

public typealias SearchCompletionHandler = (Result<YoutubeSearchResult,ApiError>) -> ()

public protocol YoutubeSearchServiceContract {
    func search(criteria: YoutubeSearchCriteria?, completionHandler: @escaping SearchCompletionHandler) -> URLSessionTask?
}

public class YoutubeSearchService: YoutubeSearchServiceContract {
    private let apiKey: String
    private let apiClient: ApiClientContract
    private let searchUrl: URL = URL(string: "https://www.googleapis.com/youtube/v3/search")!
    
    public init(youtubeApiKey: String, apiClient: ApiClientContract = ApiClient.shared) {
        self.apiKey = youtubeApiKey
        self.apiClient = apiClient
    }
    
    public func search(criteria: YoutubeSearchCriteria?, completionHandler: @escaping SearchCompletionHandler) -> URLSessionTask? {
        
        let criteria = criteria ?? YoutubeSearchCriteria(channelId: nil, pageToken: nil, searchTerm: nil, itemTypes: nil, maxResultsPerPage: nil, sortedBy: nil)
        
        var queryParameters = criteria.asQueryParameters()
        queryParameters["key"] = apiKey
        
        return self.apiClient.get(from: searchUrl, type: YoutubeSearchResult.self, queryItems: queryParameters) { (result) in
            guard let result = try? result.get() else {
                completionHandler(Result.failure(ApiError.generic))
                return
            }
            
            completionHandler(Result.success(result))
        }
    }
}
