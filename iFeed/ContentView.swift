//
//  ContentView.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AppView()
            SearchCountryView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}