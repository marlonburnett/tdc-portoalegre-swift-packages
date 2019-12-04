//
//  YoutubeSearchResult.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation

public struct YoutubeSearchResult: Codable {
    public let nextPageToken: String
    public let pageInfo: PageInfo
    public let items: [YoutubeItem]
}
