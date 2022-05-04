//
//  ViewModel.swift
//  iFeed
//
//  Created by Huy Ong on 4/17/22.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var isShowingError = false
    @Published var groups = [Group]()
    @Published var searchResult: SearchResult? 
    @Published var selectedContry: CountryCode = .us {
        didSet { reload() }
    }
    
    init() {
        reload()
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.groups = []
            self.isShowingError = false
        }
        Task {
            do {
                let apps = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .app)
                groups += apps
                let musics = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .music)
                groups += musics
                let books = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .book)
                groups += books
                let audibles = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .audible)
                groups += audibles
                let podcasts = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .podcast)
                groups += podcasts
            } catch {
                print(error.localizedDescription)
                isShowingError = true
            }
        }
    }
}

