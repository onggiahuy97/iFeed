//
//  AppView.swift
//  iFeed
//
//  Created by Huy Ong on 4/16/22.
//

import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
//    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var showPickingCountry = false
    
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
                    
//                    NavigationLink(destination: pickedCountryView) {
//                        Image(systemName: "line.3.horizontal.decrease.circle")
//                            .foregroundColor(.white)
//                    }
                    
                    Button {
                        showPickingCountry.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showPickingCountry) {
                        pickedCountryView
                    }
                }
            }
        }
    }
    
    var pickedCountryView: some View {
        NavigationView {
            List(CountryCode.all) { cc in
                Button {
                    viewModel.selectedContry = cc
                    showPickingCountry.toggle()
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
            .toolbar {
                ToolbarItem {
                    
                }
            }
            .searchable(text: $searchText) {
                ForEach(CountryCode.all.filter {
                    $0.country.lowercased().contains(searchText.lowercased()) })
                { cc in
                    Button {
                        viewModel.selectedContry = cc
                        showPickingCountry.toggle()
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
}
