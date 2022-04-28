//
//  iFeedApp.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import SwiftUI

@main
struct iFeedApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
