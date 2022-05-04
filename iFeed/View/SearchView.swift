//
//  SearchView.swift
//  iFeed
//
//  Created by Huy Ong on 5/2/22.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            SearchBarView(searchResult: $viewModel.searchResult)
            if let searchResult = viewModel.searchResult {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(searchResult.results) {
                            Text($0.trackName)
                        }
                    }
                }
            } else {
                Spacer()
            }
        }
        .defaultBackground()
    }
}

struct SearchBarView: UIViewRepresentable {
    @Binding var searchResult: SearchResult?
    
    func makeUIView(context: Context) -> some UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(searchResult: $searchResult)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var searchResult: SearchResult?
        
        init(searchResult: Binding<SearchResult?>) {
            _searchResult = searchResult
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: searchBar)
            perform(#selector(search), with: searchBar, afterDelay: 0.75)
        }
        
        @objc
        private func search(_ searchBar: UISearchBar) {
            Task {
                do {
                    guard let text = searchBar.text, !text.isEmpty else { return }
                    let fixedText = text.replacingOccurrences(of: " ", with: "").lowercased()
                    try await Service.shared.fetchSearch(fixedText) { searchResult in
                        print(searchResult.resultCount)
                        withAnimation {
                            self.searchResult = searchResult
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
