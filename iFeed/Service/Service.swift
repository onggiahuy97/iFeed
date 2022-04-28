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
    
    func fetchAppGroup(url: URL, completion: @escaping (AppGroup) -> Void) async throws {
        let session = URLSession.shared
        let responese = try await session.data(from: url)
        let jsonData = try JSONDecoder().decode(AppGroup.self, from: responese.0)
        await MainActor.run(body: {
            completion(jsonData)
        })
    }
    
    @MainActor
    func fetchAppGroups(_ country: CountryCode) async throws -> [AppGroup] {
        var appGroups = [AppGroup]()
        try await fetchAppGroup(url: generateAppGroupURL(country).0, completion: { appGroups.append($0) })
        try await fetchAppGroup(url: generateAppGroupURL(country).1, completion: { appGroups.append($0) })
        return appGroups
    }
    
    private func generateAppGroupURL(_ country: CountryCode) -> (URL,URL) {
        let urlFree = "https://rss.applemarketingtools.com/api/v2/\(country.id)/apps/top-free/25/apps.json"
        let urlPaid = "https://rss.applemarketingtools.com/api/v2/\(country.id)/apps/top-paid/25/apps.json"
        return (URL(string: urlFree)!, URL(string: urlPaid)!)
    }
}

extension Service {
    static let appGroupUrls: [URL] = [
        "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/25/apps.json",
        "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/25/apps.json"
    ].map { URL(string: $0)! }
}


