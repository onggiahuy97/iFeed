//
//  SearchView.swift
//  iFeed
//
//  Created by Huy Ong on 5/2/22.
//

import SwiftUI
import Combine

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var errorMessage = "No items to display"
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                SearchBarView()
                PickSearchType
                if let searchResult = viewModel.searchResult {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(searchResult.results) { result in
                                SearchCellView(cell: result)
                            }
                        }
                    }
                } else {
                    Text(errorMessage)
                    Spacer()
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .defaultBackground()
    }
    
    var PickSearchType: some View {
        Picker("", selection: $viewModel.searchType) {
            ForEach(SearchResult.SearchType.allCases) { type in
                Text(type.rawValue)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.searchType) { newValue in
            viewModel.searchType = newValue
            viewModel.performSearch()
        }
    }
}
            
struct SearchBarView: UIViewRepresentable {
    @EnvironmentObject var viewModel: ViewModel
    
    func makeUIView(context: Context) -> some UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        let viewModel: ViewModel
        
        init(_ viewModel: ViewModel) {
            self.viewModel = viewModel
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: searchBar)
            perform(#selector(search), with: searchBar, afterDelay: 0.75)
        }
        
        @objc
        private func search(_ searchBar: UISearchBar) {
            viewModel.searchText = searchBar.text ?? ""
            viewModel.performSearch()
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
