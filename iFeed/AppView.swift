//
//  AppView.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showSelectedCountry = false
    @State private var searchText = ""
    
    var navigationTitleString: String {
        "\(viewModel.selectedContry.flag) \(viewModel.selectedContry.country)"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.appGroups.isEmpty {
                    ProgressView()
                }
                ForEach(viewModel.appGroups) { appGroup in
                    VStack(alignment: .leading) {
                        NavigationLink(destination: fullAppsDetail(appGroup)) {
                            HStack {
                                Text(appGroup.feed.title)
                                    .font(.title)
                                Spacer()
                                Image(systemName: "list.bullet")
                            }
                        }
                        .buttonStyle(.plain)
                        ScrollView(.horizontal) {
                            let rows: [GridItem] = Array.init(repeating: GridItem(), count: 3)
                            let widthScreen = UIScreen.main.bounds.width * 0.8
                            LazyHGrid(rows: rows, alignment: .top, spacing: 12) {
                                ForEach(appGroup.feed.results) { app in
                                    AppCellView(app: app)
                                        .frame(width: widthScreen)
                                }
                            }
                            .frame(height: 150)
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .navigationTitle(navigationTitleString)
            .background{
                ZStack{
                    let colors: [Color] = [.blue.opacity(0.3),.blue.opacity(0.3), .red.opacity(0.3)]
                    LinearGradient(colors: colors, startPoint: .topTrailing, endPoint: .bottomLeading)
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: pickedCountryView, isActive: $showSelectedCountry) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func fullAppsDetail(_ appGroup: AppGroup) -> some View {
        List(appGroup.feed.results) { app in
            AppCellView(app: app)
        }
        .navigationTitle(appGroup.feed.title)
    }
    
    var pickedCountryView: some View {
        List(CountryCode.all) { cc in
            Button {
                viewModel.selectedContry = cc
                showSelectedCountry.toggle()
            } label: {
                HStack {
                    Text(cc.country)
                    Spacer()
                    Image(systemName: "checkmark")
                        .opacity(cc.id == viewModel.selectedContry.id ? 1.0 : 0.0)
                }
            }
        }
        .navigationTitle("Pick a country")
        .searchable(text: $searchText, prompt: "Conutry") {
            ForEach(CountryCode.all.filter { $0.country.contains(searchText) }) { cc in
                Button {
                    viewModel.selectedContry = cc
                    showSelectedCountry.toggle()
                } label: {
                    HStack {
                        Text(cc.country)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(cc.id == viewModel.selectedContry.id ? 1.0 : 0.0)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct AppCellView: View {
    var app: AppGroup.FeedResult
    let width = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        Button {
            let baseString = "itms-apps://apple.com/app/id"
            if let url = URL(string: baseString.appending(app.id)) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                AsyncImage(url: URL(string: app.artworkUrl100)) { image in
                    image
                        .resizable()
                        .frame(width: 45, height: 45)
                        .scaledToFill()
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                } placeholder: {
                    ProgressView()
                }
                
                Text(app.name)
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
