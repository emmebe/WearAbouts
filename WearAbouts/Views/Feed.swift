//
//  Feed.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()),
                GridItem(.flexible())], spacing: 10) {
                ForEach(0..<21, id: \.self) { index in
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomePage()
}
