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
    func fetchAppGroups(_ country: CountryCode) async throws -> [Group] {
        return try await fetchGenericGroups(generateAppGroupURL(country))
    }
    
    @MainActor
    func fetchMusicGroup(_ country: CountryCode) async throws -> [Group] {
        return try await fetchGenericGroups(generateMusicGroupURL(country))
    }
    
    @MainActor
    func fetchBooksGroup(_ country: CountryCode) async throws -> [Group] {
        return try await fetchGenericGroups(generateBooksGroupURL(country))
    }
    
    @MainActor
    func fetchAudibleGroup(_ country: CountryCode) async throws -> [Group] {
        return try await fetchGenericGroups(generateAudibleBooksURL(country))
    }
    
    @MainActor
    func fetchPodcasts(_ country: CountryCode) async throws -> [Group] {
        return try await fetchGenericGroups(generatePodcassURL(country))
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
    
    private func generateAppGroupURL(_ country: CountryCode) -> [URL] {
        let urlFree = "https://rss.applemarketingtools.com/api/v2/\(country.id)/apps/top-free/25/apps.json"
        let urlPaid = "https://rss.applemarketingtools.com/api/v2/\(country.id)/apps/top-paid/25/apps.json"
        return [URL(string: urlFree)!, URL(string: urlPaid)!]
    }
    
    private func generateMusicGroupURL(_ country: CountryCode) -> [URL] {
        let urlAlbums = "https://rss.applemarketingtools.com/api/v2/\(country.id)/music/most-played/25/albums.json"
        let urlSongs = "https://rss.applemarketingtools.com/api/v2/\(country.id)/music/most-played/25/songs.json"
        return [URL(string: urlAlbums)!, URL(string: urlSongs)!]
    }
    
    private func generateBooksGroupURL(_ country: CountryCode) -> [URL] {
        let urlAlbums = "https://rss.applemarketingtools.com/api/v2/\(country.id)/books/top-free/25/books.json"
        let urlSongs = "https://rss.applemarketingtools.com/api/v2/\(country.id)/books/top-paid/25/books.json"
        return [URL(string: urlAlbums)!, URL(string: urlSongs)!]
    }
    
    private func generateAudibleBooksURL(_ country: CountryCode) -> [URL] {
        let url = "https://rss.applemarketingtools.com/api/v2/\(country.id)/audio-books/top/25/audio-books.json"
        return [URL(string: url)!]
    }
    
    private func generatePodcassURL(_ country: CountryCode) -> [URL] {
        let urlPodcastEps = "https://rss.applemarketingtools.com/api/v2/\(country.id)/podcasts/top/25/podcast-episodes.json"
        let urlPodcast = "https://rss.applemarketingtools.com/api/v2/\(country.id)/podcasts/top/25/podcasts.json"
        return [URL(string: urlPodcastEps)!, URL(string: urlPodcast)!]
    }
}
