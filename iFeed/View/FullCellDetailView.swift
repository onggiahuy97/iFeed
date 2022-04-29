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
        List(group.feed.results) { res in
            CellView(cell: res)
        }
        .navigationTitle(group.feed.title)
    }
}
