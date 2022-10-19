//
//  GroupView.swift
//  iFeed
//
//  Created by Huy Ong on 4/29/22.
//

import SwiftUI

struct GroupView: View {
    let groups: [Group]
    
    var userIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
//    var isPortrait: Bool { UIDevice.current.orientation.isPortrait }
    
    var body: some View {
        ForEach(groups) { group in
            VStack(alignment: .leading, spacing: 15) {
                
                // Title View
                NavigationLink(destination: FullCellDetailView(group: group)) {
                    HStack {
                        Image(systemName: group.groupTypeIconName)
                            .imageScale(.large)
                        Text(group.feed.title)
                            .font(.title)
                            .lineLimit(1)
                        Spacer()
                        Text("See All")
                            .padding(.trailing, 5)
                            .font(.footnote)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                
                // Collection View
                ScrollView(.horizontal) {
                    HStack {
                        Spacer()
                            .frame(width: 15)
                        ScrollView(.horizontal) {
                            let rows: [GridItem] = Array.init(repeating: GridItem(), count: 3)
                            let widthScreen = UIScreen.main.bounds.width * (userIdiom == .phone ? 0.7 : 0.4)
                            
                            LazyHGrid(rows: rows, alignment: .top, spacing: 15) {
                                ForEach(group.feed.results) { app in
                                    CellView(cell: app)
                                        .frame(width: widthScreen)
                                }
                            }
                        }
                    }
                }
                .frame(height: group.feed.results.isEmpty ? 0 : 220)
            }
        }
    }
}
