//
//  YoutubeThumbnail.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation

public struct YoutubeThumbnail: Codable {
    public let `default`: Thumbnail
    public let medium: Thumbnail
    public let high: Thumbnail
}
