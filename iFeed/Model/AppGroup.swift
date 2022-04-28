//
//  AppGroup.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import Foundation

struct AppGroup: Decodable, Identifiable {
    let id = UUID()
    let feed: Feed
    
    struct Feed: Decodable {
        let title: String
        let results: [FeedResult]
    }
    
    struct FeedResult: Decodable, Identifiable {
        let id, name, artistName, artworkUrl100, url: String
    }
}
