//
//  AppDetailView.swift
//  iFeed
//
//  Created by Huy Ong on 6/28/22.
//

import SwiftUI

struct AppDetailView: View {
    var groupCell: Group.FeedResult
    
    var body: some View {
        appDetailView(groupCell: groupCell)
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
}
