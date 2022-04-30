//
//  AppCellView.swift
//  iFeed
//
//  Created by Huy Ong on 4/28/22.
//

import SwiftUI


struct CellView: View {
    var cell: Group.FeedResult
    
    let width = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        Button {
            if let url = URL(string: cell.url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(alignment: .center) {
                AsyncImage(url: URL(string: cell.artworkUrl100)) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 60)
                .scaledToFill()
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                
                Text(cell.name)
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
