//
//  Group.swift
//  iFeed
//
//  Created by Huy Ong on 4/29/22.
//

import Foundation

struct Group: Decodable, Identifiable {
    let id = UUID()
    let feed: Feed
    
    struct Feed: Decodable {
        let title: String
        let results: [FeedResult]
    }
    
    struct FeedResult: Decodable, Identifiable {
        let id, name, kind, artistName, artworkUrl100, url: String
    }
}

extension Group {
    enum Kind {
        case book, other
    }
}
