//
//  AppDetailView.swift
//  iFeed
//
//  Created by Huy Ong on 6/28/22.
//

import SwiftUI

struct AppDetailView: View {
    var searchCell: SearchResult.Result? {
        didSet {
            
        }
    }
    
    var groupCell: Group.FeedResult? {
        didSet {
            
        }
    }
    
    var body: some View {
        if let searchCell = searchCell {
            
        }
        
        if let groupCell = groupCell {
            Text(groupCell.artistName ?? "")
        }
    }
}
