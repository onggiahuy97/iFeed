//
//  GroupView.swift
//  iFeed
//
//  Created by Huy Ong on 4/29/22.
//

import SwiftUI

struct GroupView: View {
    let groups: [Group]
    
    var body: some View {
        ForEach(groups) { group in
            VStack(alignment: .leading, spacing: 15) {
                NavigationLink(destination: FullCellDetailView(group: group)) {
                    HStack {
                        Image(systemName: group.groupTypeIconName)
                            .imageScale(.large)
                        Text(group.feed.title)
                            .font(.title)
                        Spacer()
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack {
                        Spacer()
                            .frame(width: 15)
                        ScrollView(.horizontal) {
                            let rows: [GridItem] = Array.init(repeating: GridItem(), count: 3)
                            let widthScreen = UIScreen.main.bounds.width * 0.7
                            LazyHGrid(rows: rows, alignment: .top, spacing: 15) {
                                ForEach(group.feed.results) { app in
                                    CellView(cell: app)
                                        .frame(width: widthScreen)
                                }
                            }
                        }
                    }
                }
                .frame(height: 220)
                .overlay(
                    ZStack {
                        if group.feed.results.isEmpty {
                            Text("The list is empty")
                        }
                    }
                )
            }
        }
    }
}
