//
//  SearchViewModel.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 27/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation
import YTApi

protocol SearchViewModelDelegate: class {
    func didUpdateItems()
    func didAddMoreItens(numberOfItens: Int)
}

protocol SearchViewModelContract {
    func loadMore(searchCriteria: String?)
    func refresh()
    func numberOfItems() -> Int
    func item(at index: Int) -> YoutubeItem?
}

class SearchViewModel: SearchViewModelContract {
    private let service: YoutubeSearchServiceContract
    private var searchCriteria: String?
    private var nextPageToken: String?
    private var items = [YoutubeItem]()
    private var lastResult: YoutubeSearchResult?
    private var hasMore: Bool { lastResult?.pageInfo.totalResults ?? Int.max > items.count }
    private var isLoading: Bool = false
    private var currentTask: URLSessionTask? = nil
    
    weak var delegate: SearchViewModelDelegate?
    
    init(service: YoutubeSearchServiceContract = YoutubeSearchService(youtubeApiKey: K.youtubeApiKey), delegate: SearchViewModelDelegate?) {
        self.service = service
        self.delegate = delegate
    }
    
    func loadMore(searchCriteria: String?) {
        if self.searchCriteria != searchCriteria {
            self.currentTask?.cancel()
            self.searchCriteria = searchCriteria
            self.lastResult = nil
            self.nextPageToken = nil
            self.items.removeAll()
            self.delegate?.didUpdateItems()
            self.isLoading = false
        }
        
        guard !isLoading && (lastResult == nil || hasMore) else {
            return
        }
        
        isLoading = true
        
        let criteria = YoutubeSearchCriteria(channelId: K.tedChannelId, pageToken: self.nextPageToken, searchTerm: self.searchCriteria, itemTypes: [.video], maxResultsPerPage: 10, sortedBy: .relevance)
        
        self.currentTask = self.service.search(criteria: criteria) { [weak self] (result) in
            guard let self = self else { return }
            
            self.currentTask = nil
            
            self.isLoading = false
            
            guard let result = try? result.get() else { return }
            
            self.nextPageToken = result.nextPageToken
            self.items.append(contentsOf: result.items)
            
            if self.items.count == result.items.count {
                self.delegate?.didUpdateItems()
            } else {
                self.delegate?.didAddMoreItens(numberOfItens: result.items.count)
            }
        }
    }
    
    func refresh() {
        self.nextPageToken = nil
        self.items.removeAll()
        self.loadMore(searchCriteria: self.searchCriteria)
    }
    
    func numberOfItems() -> Int {
        return self.items.count
    }
    
    func item(at index: Int) -> YoutubeItem? {
        guard self.items.indices.contains(index) else { return nil }
        
        return self.items[index]
    }
}
