//
//  ContentView.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPage: Int = 1
    
    var body: some View {
        VStack(spacing: 0) {
            // NAV BAR
            HStack {
                Text("WearAbouts")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Home Button
                Button(action: { selectedPage = 1 }) {
                    Image(systemName: "house.fill")
                        .font(.title3)
                        .foregroundColor(selectedPage == 1 ? .blue : .gray)
                        .frame(width: 44, height: 44)
                        .background(selectedPage == 1 ? Color.blue.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                }
                
                // Map Button
                Button(action: { selectedPage = 2 }) {
                    Image(systemName: "map.fill")
                        .font(.title3)
                        .foregroundColor(selectedPage == 2 ? .blue : .gray)
                        .frame(width: 44, height: 44)
                        .background(selectedPage == 2 ? Color.blue.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                }
                
                // Profile Button
                Button(action: { selectedPage = 3 }) {
                    Image(systemName: "person.fill")
                        .font(.title3)
                        .foregroundColor(selectedPage == 3 ? .blue : .gray)
                        .frame(width: 44, height: 44)
                        .background(selectedPage == 3 ? Color.blue.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            
            Divider()
            
            // PAGE CONTENT
            if selectedPage == 1 {
                HomePage()
            } else if selectedPage == 2 {
                MapPage()
            } else {
                ProfilePage()
            }
        }
    }
}

#Preview {
    ContentView()
}
