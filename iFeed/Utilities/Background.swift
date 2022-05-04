//
//  Background.swift
//  iFeed
//
//  Created by Huy Ong on 4/29/22.
//

import SwiftUI

extension View {
    func defaultBackground() -> some View {
        self
            .background{
                ZStack{
                    let colors: [Color] = [.blue.opacity(0.3),.blue.opacity(0.3), .red.opacity(0.3)]
                    LinearGradient(colors: colors, startPoint: .topTrailing, endPoint: .bottomLeading)
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .ignoresSafeArea()
            }
            .preferredColorScheme(.dark)
    }
}
