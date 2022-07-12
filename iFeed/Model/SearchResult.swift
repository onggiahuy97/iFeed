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
        var id: Int { trackId ?? UUID().hashValue }
        let trackId: Int?
        let url: String?
        let trackViewUrl: String?
        let trackName: String?
        var averageUserRating: Float?
        var screenshotUrls: [String]?
        let artworkUrl100: String? // app icon
        var formattedPrice: String?
        var description: String?
        var releaseNotes: String?
        var artistName: String?
        var collectionName: String?
    }
}

extension SearchResult {
    enum SearchType: String, CaseIterable, Identifiable {
        case App, Music, Movie, EBook
        
        var id: String { toTerm }
        
        var toTerm: String {
            switch self {
            case .App: return "software"
            case .Music: return ""
            case .Movie: return self.rawValue.lowercased()
            case .EBook: return self.rawValue.lowercased()
            }
        }
    }
}

