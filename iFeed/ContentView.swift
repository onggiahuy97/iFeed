//
//  ContentView.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: SelectedTab = .search
    
    enum SelectedTab {
        case home, search
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AppView()
                .tabItem {
                    Label("Home", systemImage: "list.bullet.rectangle.portrait")
                }
                .tag(SelectedTab.home)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(SelectedTab.search)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
