//
//  Service.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import Foundation
import Combine
import SwiftUI

struct Service {
    static let shared = Service()
    
    @MainActor
    func fetchSearch(_ searchTerm: String, completion: @escaping ((SearchResult) -> Void)) async throws {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        try await fetch(url: url) { completion($0) }
    }
    
    @MainActor
    func fetchGroup(country: CountryCode, groupKind: GroupKind) async throws -> [Group] {
        return try await fetchGenericGroups(groupKind.generateUrls(country))
    }
    
    private func fetchGenericGroups<T: Decodable>(_ urls: [URL]) async throws -> [T] {
        var tGroup = [T]()
        for url in urls {
            try await fetch(url: url, completion: { tGroup.append($0) })
        }
        return tGroup
    }
    
    private func fetch<T: Decodable>(url: URL, completion: @escaping (T) -> Void) async throws {
        let session = URLSession.shared
        let res = try await session.data(from: url)
        let jsonData = try JSONDecoder().decode(T.self, from: res.0)
        await MainActor.run(body: {
            completion(jsonData)
        })
    }
}

extension Service {
    enum GroupKind {
        case app, music, book, podcast, audible
        
        func generateUrls(_ country: CountryCode) -> [URL] {
            var base1 = "https://rss.applemarketingtools.com/api/v2/"
            var base2 = "https://rss.applemarketingtools.com/api/v2/"
            base1.append(country.id)
            base2.append(country.id)
            switch self {
            case .app:
                base1.append("/apps/top-free/25/apps.json")
                base2.append("/apps/top-paid/25/apps.json")
            case .music:
                base1.append("/music/most-played/25/albums.json")
                base2.append("/music/most-played/25/songs.json")
            case .book:
                base1.append("/books/top-free/25/books.json")
                base2.append("/books/top-paid/25/books.json")
            case .audible:
                base1.append("/audio-books/top/25/audio-books.json")
                return [URL(string: base1)!]
            case .podcast:
                base1.append("/podcasts/top/25/podcast-episodes.json")
                base2.append("/podcasts/top/25/podcasts.json")
            }
            return [URL(string: base1)!, URL(string: base2)!]
        }
    }
}
