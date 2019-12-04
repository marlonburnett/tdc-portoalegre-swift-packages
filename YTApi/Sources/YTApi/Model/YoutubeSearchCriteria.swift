//
//  YoutubeSearchCriteria.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation

public enum YoutubeItemType: String {
    case channel
    case playlist
    case video
}

public class YoutubeSearchCriteria {
    let channelId: String?
    let pageToken: String?
    let searchTerm: String?
    let itemTypes: [YoutubeItemType]?
    let maxResultsPerPage: UInt8?
    let sortedBy: YoutubeSearchSortOrder?
    
    public init(channelId: String?, pageToken: String?, searchTerm: String?, itemTypes: [YoutubeItemType]?, maxResultsPerPage: UInt8?, sortedBy: YoutubeSearchSortOrder?) {
        self.channelId = channelId
        self.pageToken = pageToken
        self.searchTerm = searchTerm
        self.itemTypes = itemTypes
        self.maxResultsPerPage = maxResultsPerPage
        self.sortedBy = sortedBy
    }
}

public extension YoutubeSearchCriteria {
    func advance(nextPageToken: String) -> YoutubeSearchCriteria {
        return YoutubeSearchCriteria(channelId: self.channelId, pageToken: nextPageToken, searchTerm: self.searchTerm, itemTypes: self.itemTypes, maxResultsPerPage: self.maxResultsPerPage, sortedBy: self.sortedBy)
    }
    
    func asQueryParameters() -> [String:Any] {
        var dictionary: [String:Any] = ["part": "id,snippet"]
        
        if let channelId = channelId {
            dictionary["channelId"] = channelId
        }
        
        if let pageToken = pageToken {
            dictionary["pageToken"] = pageToken
        }
        
        if let searchTerm = searchTerm {
            dictionary["q"] = searchTerm
        }
        
        if let itemTypes = itemTypes {
            let formattedTypeString = itemTypes.map { $0.rawValue }.reduce("", { (current, type) in
                return "\(current)\(type),"
            }).trimmingCharacters(in: CharacterSet(charactersIn: ", "))
            
            dictionary["type"] = formattedTypeString
        }
        
        if let maxResultsPerPage = maxResultsPerPage {
            dictionary["maxResults"] = maxResultsPerPage
        }
        
        if let sortedBy = sortedBy {
            dictionary["order"] = sortedBy.rawValue
        }
        
        return dictionary
    }
}
