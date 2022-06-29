//
//  AppView.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
//    @State private var showSelectedCountry = false
    @State private var searchText = ""
    
    var navigationTitleString: String {
        "\(viewModel.selectedContry.flag) \(viewModel.selectedContry.country)"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.groups.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text(viewModel.isShowingError ? "Please pick other country" : "")
                    }
                }
                GroupView(groups: viewModel.groups)
            }
            .frame(maxWidth: .infinity)
            .navigationTitle(navigationTitleString)
            .defaultBackground()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: pickedCountryView, isActive: $showSelectedCountry) {
//                        Image(systemName: "line.3.horizontal.decrease.circle")
//                            .foregroundColor(.white)
//                    }
                    
                    NavigationLink(destination: pickedCountryView) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    var pickedCountryView: some View {
        List(CountryCode.all) { cc in
            Button {
                viewModel.selectedContry = cc
                showSelectedCountry.toggle()
            } label: {
                HStack {
                    Text(cc.flag)
                    Text(cc.country)
                    Spacer()
                    Image(systemName: "checkmark")
                        .opacity(cc.id == viewModel.selectedContry.id ? 1.0 : 0.0)
                }
            }
        }
        .navigationTitle("Pick a country")
        .searchable(text: $searchText) {
            ForEach(CountryCode.all.filter { $0.country.contains(searchText) }) { cc in
                Button {
                    viewModel.selectedContry = cc
                    showSelectedCountry.toggle()
                } label: {
                    HStack {
                        Text("\(cc.flag) \(cc.country)")
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
