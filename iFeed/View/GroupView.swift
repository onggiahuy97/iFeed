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
            VStack(alignment: .leading) {
                NavigationLink(destination: FullCellDetailView(group: group)) {
                    HStack {
                        let kind = group.feed.results.first?.kind == "books" ? "Books" : ""
                        Text("\(group.feed.title) \(kind)")
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
                        ForEach(group.feed.results) { app in
                            CellView(cell: app)
                                .frame(width: widthScreen)
                        }
                    }
                    .frame(height: 200)
                }
            }
        }
        .padding()
    }
}
