//
//  SearchResult.swift
//  iFeed
//
//  Created by Huy Ong on 5/2/22.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
    
    struct Result: Decodable, Identifiable {
        var id: Int { trackId }
        let trackId: Int
        let trackViewUrl: String
        let trackName: String
        let primaryGenreName: String
        var averageUserRating: Float?
        var screenshotUrls: [String]?
        let artworkUrl100: String // app icon
        var formattedPrice: String?
        var description: String?
        var releaseNotes: String?
        var artistName: String?
        var collectionName: String?
    }
}


