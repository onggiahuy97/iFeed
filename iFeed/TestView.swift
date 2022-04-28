//
//  TestView.swift
//  iFeed
//
//  Created by Huy Ong on 4/20/22.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        let rows: [GridItem] = Array(repeating: .init(.fixed(20)), count: 2)
        let columns: [GridItem] = Array(repeating: .init(.fixed(50)), count: 3)
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, alignment: .top) {
                ForEach((0...79), id: \.self) {
                    let codepoint = $0 + 0x1f600
                    let codepointString = String(format: "%02X", codepoint)
                    Text("\(codepointString)")
                        .font(.footnote)
                    let emoji = String(Character(UnicodeScalar(codepoint)!))
                    Text("\(emoji)")
                        .font(.largeTitle)
                }
                .background(.red)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

