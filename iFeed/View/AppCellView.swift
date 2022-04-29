//
//  AppCellView.swift
//  iFeed
//
//  Created by Huy Ong on 4/28/22.
//

import SwiftUI


struct CellView: View {
    var cell: Group.FeedResult
    var kind: Group.Kind
    
    init(cell: Group.FeedResult, kind: Group.Kind = .other)  {
        self.cell = cell
        self.kind = kind
    }
    
    let width = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        Button {
            let baseString = "itms-apps://apple.com/app/id"
            if let url = URL(string: baseString.appending(cell.id)) {
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
                .frame(width: 55, height: kind == .other ? 55 : 80)
                .scaledToFill()
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                
                Text(cell.name)
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
