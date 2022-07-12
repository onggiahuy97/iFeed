//
//  ItemDetailView.swift
//  iFeed
//
//  Created by Huy Ong on 7/12/22.
//

import SwiftUI

struct ItemDetailView: View {
    let itemID: String
    
    @State private var item: SearchResult.Result?
    
    init(itemID: String) {
        self.itemID = itemID
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .top, spacing: 10) {
                    AsyncImage(url: URL(string: item?.artworkUrl100 ?? "")) { image in
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
                        Text(item?.trackName ?? "Unknown")
                            .bold()
                        Text(item?.artistName ?? "")
                            .font(.caption)
                        Spacer()
                        HStack {
                            Spacer()
                            Button("Open") {
                                if let cellUrl = item?.url, let url = URL(string: cellUrl), UIApplication.shared.canOpenURL(url) {
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
                
                if let screenshotUrls = item?.screenshotUrls {
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
        .onAppear(perform: loadData)
    }
    
    private func loadData() {
        Task {
            do {
                let item = try await Service.shared.fetchItemWithID(itemID: itemID)
                self.item = item?.results.first
            } catch {
                print("Failed for processing data \(error.localizedDescription)")
            }
        }
    }
}
