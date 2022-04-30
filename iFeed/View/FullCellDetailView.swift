//
//  FullCellDetailView.swift
//  iFeed
//
//  Created by Huy Ong on 4/29/22.
//

import SwiftUI

struct FullCellDetailView: View {
    let group: Group
    
    var body: some View {
        ScrollView {
            if group.feed.results.isEmpty {
                Text("The list is empty")
            }
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(group.feed.results) { res in
                    CellView(cell: res)
                }
            }
            .padding(.horizontal)
            
            if !group.feed.results.isEmpty {
                Text("Load more")
                    .padding()
                    .onTapGesture { print("Loading") }
            }
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(group.feed.title)
        .defaultBackground()
    }
}
