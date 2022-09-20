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
    @State private var showAllImages = false
    
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
                .padding()
                
                Divider()
        
                Text("Preview")
                    .bold()
                    .padding(.horizontal)
                
                if let screenshotUrls = item?.screenshotUrls {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Spacer()
                                .frame(width: 15)
                            ForEach(screenshotUrls, id: \.self) { screenshotUrl in
                                AsyncImage(url: URL(string: screenshotUrl)) { image in
                                    image
                                        .resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 150)
                                .cornerRadius(5)
                                .shadow(radius: 3)
                            }
                        }
                    }
                    .onTapGesture {
                        if !screenshotUrls.isEmpty {
                            showAllImages.toggle()
                        }
                    }
                    .sheet(isPresented: $showAllImages) {
                        showAllImages(screenshotUrls)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: loadData)
    }
    
    @ViewBuilder
    private func showAllImages(_ urls: [String]) -> some View {
        TabView {
            ForEach(urls, id: \.self) { url in
                AsyncImage(url: URL(string: url))
                    .scaledToFill()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
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
