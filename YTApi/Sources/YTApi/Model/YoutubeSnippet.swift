//
//  YoutubeSnippet.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation

public struct YoutubeSnippet: Codable {
    public let publishedAt: Date
    public let channelId: String
    public let title: String
    public let description: String
    public let thumbnails: YoutubeThumbnail
    public let channelTitle: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isoDateString = try container.decode(String.self, forKey: .publishedAt)
        
        self.publishedAt = try DateFormatterService.shared.parse(isoDateString: isoDateString)
        self.channelId = try container.decode(String.self, forKey: .channelId)
        let titleEncoded = try container.decode(String.self, forKey: .title)
        self.title = String(htmlEncodedString: titleEncoded)!
        let descriptionEncoded = try container.decode(String.self, forKey: .description)
        self.description = String(htmlEncodedString: descriptionEncoded)!
        self.thumbnails = try container.decode(YoutubeThumbnail.self, forKey: .thumbnails)
        self.channelTitle = try container.decode(String.self, forKey: .channelTitle)
    }
    
    private enum CodingKeys: CodingKey {
        case publishedAt
        case channelId
        case title
        case description
        case thumbnails
        case channelTitle
    }
}
