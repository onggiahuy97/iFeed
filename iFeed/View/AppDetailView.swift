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
    @State private var screenshotUrls: [String]?
    
    init(searchCell: SearchResult.Result? = nil, groupCell: Group.FeedResult? = nil, screenshotUrls: [String]? = nil) {
        self.searchCell = searchCell
        self.groupCell = groupCell
        self.screenshotUrls = screenshotUrls
        
        if let groupCell = groupCell {
            loadData(appId: groupCell.id ?? "")
        }
    }
    
    var body: some View {
        if let groupCell = groupCell {
            appDetailView(groupCell: groupCell)
            .onAppear {
                loadData(appId: groupCell.id ?? "")
            }
        } else if let searchCell = searchCell {
            
        } else {
            ProgressView("Failed to fetch app")
        }
    }
    
    func appDetailView(groupCell: Group.FeedResult) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .top, spacing: 10) {
                    AsyncImage(url: URL(string: groupCell.artworkUrl100 ?? "")) { image in
                        image
                            .resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .scaledToFill()
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                    
                    VStack(alignment: .leading) {
                        Text(groupCell.name ?? "Unknown")
                            .bold()
                        Text(groupCell.artistName ?? "")
                            .font(.caption)
                        Spacer()
                        HStack {
                            Spacer()
                            Button("Open") {
                                if let cellUrl = groupCell.url, let url = URL(string: cellUrl), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .lineLimit(1)
                    
                    Spacer()
                }
                .frame(height: 80)
                
                Divider()
                
                Text("Preview")
                    .bold()
                
                if let screenshotUrls = groupCell.screenshotUrls {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(screenshotUrls, id: \.self) { screenshotUrl in
                                AsyncImage(url: URL(string: screenshotUrl)) { image in
                                    image
                                        .resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    func loadData(appId: String) {
        Task {
            do {
                try await Service.shared.fetchAppDetail(appId: appId) { app in
                    self.screenshotUrls = app.results.first?.screenshotUrls
                }
            } catch {
                print("Failed to fetch app detail: \(error)")
                return
            }
        }
    }
}
