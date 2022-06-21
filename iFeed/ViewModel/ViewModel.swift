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
        //        Task {
        //            do {
        //                let apps = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .app)
        //                groups += apps
        //                let musics = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .music)
        //                groups += musics
        //                let books = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .book)
        //                groups += books
        //                let audibles = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .audible)
        //                groups += audibles
        //                let podcasts = try await Service.shared.fetchGroup(country: selectedContry, groupKind: .podcast)
        //                groups += podcasts
        //            } catch {
        //                print(error.localizedDescription)
        //                isShowingError = true
        //            }
        //        }
        Task {
            async let apps = Service.shared.fetchGroup(country: selectedContry, groupKind: .app)
            async let music = Service.shared.fetchGroup(country: selectedContry, groupKind: .music)
            async let books = Service.shared.fetchGroup(country: selectedContry, groupKind: .book)
            async let audibles = Service.shared.fetchGroup(country: selectedContry, groupKind: .audible)
            async let podcasts = Service.shared.fetchGroup(country: selectedContry, groupKind: .podcast)
            do {
                try await groups.append(contentsOf: apps + music + books + audibles + podcasts)
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isShowingError = true
                }
            }
        }
//        DispatchQueue.main.async {
//            await groups = apps + music + books + audibles + podcasts
//        }
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

