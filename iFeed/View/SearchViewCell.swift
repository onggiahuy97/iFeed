//
//  SearchViewCell.swift
//  iFeed
//
//  Created by Huy Ong on 5/4/22.
//

import SwiftUI

struct SearchCellView: View {
    
    @State private var showDetailView = false
    
    var cell: SearchResult.Result
    
    let width = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        Button {
//            if let url = URL(string: cell.trackViewUrl ?? ""), UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            }
            showDetailView.toggle()
        } label: {
            HStack(alignment: .center) {
                AsyncImage(url: URL(string: cell.artworkUrl100 ?? "")) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 60)
                .scaledToFill()
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                
                Text(cell.trackName ?? "")
                    .lineLimit(3)
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetailView) {
            AppDetailView(searchCell: cell)
        }
    }
}
