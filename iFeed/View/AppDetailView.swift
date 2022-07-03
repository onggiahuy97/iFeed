//
//  AppDetailView.swift
//  iFeed
//
//  Created by Huy Ong on 6/28/22.
//

import SwiftUI

struct AppDetailView: View {
    var searchCell: SearchResult.Result?
    var groupCell: Group.FeedResult?
    
    var body: some View {
        if let groupCell = groupCell {
            VStack {
                Text(groupCell.artistName ?? "")
                Text(groupCell.id ?? "")
            }
            .onAppear {
                loadData(appId: groupCell.id ?? "")
            }
        } else if let searchCell = searchCell {
            
        } else {
            ProgressView("Failed to fetch app")
        }
    }
    
    func loadData(appId: String) {
        Task {
            do {
                try await Service.shared.fetchAppDetail(appId: appId) { app in
                    print(app.results.first?.trackName)
                }
            } catch {
                print("Failed to fetch app detail: \(error)")
                return
            }
        }
    }
}
