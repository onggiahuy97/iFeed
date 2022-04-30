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
    @Published var selectedContry: CountryCode = .us {
        didSet {
            groups = []
            reload()
        }
    }
    
    init() {
        reload()
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.isShowingError = false
        }
        Task {
            do {
                let apps = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .app)
                let musics = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .music)
                let books = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .book)
                let audibles = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .audible)
                let podcasts = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .podcast)
                groups = apps + musics + books + audibles + podcasts
            } catch {
                print(error.localizedDescription)
                isShowingError = true
            }
        }
    }
}

