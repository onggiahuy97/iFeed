//
//  ViewModel.swift
//  iFeed
//
//  Created by Huy Ong on 4/17/22.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var isShowingError = false
    @Published var groups = [Group]()
    @Published var searchResult: SearchResult?
    @Published var searchText = ""
    @Published var searchType: SearchResult.SearchType = .App
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
                addGroupInMainThread(apps)
                let musics = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .music)
                addGroupInMainThread(musics)
                let books = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .book)
                addGroupInMainThread(books)
                let audibles = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .audible)
                addGroupInMainThread(audibles)
                let podcasts = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .podcast)
                addGroupInMainThread(podcasts)
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isShowingError = true
                }
            }
        }
    }
    
    func addGroupInMainThread(_ group: [Group]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.groups.append(contentsOf: group)
        }
    }
    
    func performSearch() {
        DispatchQueue.main.async {
            self.isShowingError = false
            self.searchResult = nil
        }
        
        Task {
            do {
                guard !searchText.isEmpty else { return }
                let fixedText = searchText.replacingOccurrences(of: " ", with: "").lowercased()
                try await Service.shared.fetchSearch(fixedText, searchType) { searchResult in
                    print(searchResult.resultCount)
                    withAnimation {
                        self.searchResult = searchResult
                    }
                }
            } catch {
                print(error.localizedDescription)
                isShowingError = true
            }
        }
    }
}

