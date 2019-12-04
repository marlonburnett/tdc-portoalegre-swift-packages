//
//  DetailViewModel.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 27/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation
import YTApi

protocol DetailViewModelContract {
    var videoId: String { get }
    var title: String { get }
    var description: String { get }
    var publishDate: String { get }
    var largeThumbnailUrl: URL { get }
}

class DetailViewModel: DetailViewModelContract {
    private let item: YoutubeItem
    private let formatter: DateFormatterServiceContract
    
    var videoId: String { item.id.videoId }
    var title: String { item.snippet.title }
    var description: String { item.snippet.description }
    var publishDate: String { formatter.stringRepresentingTime(for: item.snippet.publishedAt) }
    var largeThumbnailUrl: URL { item.snippet.thumbnails.high.url }
    
    init(item: YoutubeItem, formatter: DateFormatterServiceContract = DateFormatterService.shared) {
        self.item = item
        self.formatter = formatter
    }
}
