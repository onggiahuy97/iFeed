//
//  FullCellDetailView.swift
//  iFeed
//
//  Created by Huy Ong on 4/29/22.
//

import SwiftUI

struct FullCellDetailView: View {
    let group: Group
    
    var userIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var countColumns: Int { userIdiom == .phone ? 1 : 2 }
    
    var body: some View {
        ScrollView {
            if group.feed.results.isEmpty {
                Text("The list is empty")
            }
            
            let columns = Array(repeating: GridItem(), count: countColumns)
            LazyVGrid(columns: columns) {
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
