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
            HStack {
                Text("WearAbouts")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.appPrimary)
                
                Spacer()
                
                HStack(spacing: Spacing.small) {
                    NavButton(
                        icon: "house.fill",
                        isSelected: selectedPage == 1,
                        action: { selectedPage = 1 }
                    )
                    
                    NavButton(
                        icon: "map.fill",
                        isSelected: selectedPage == 2,
                        action: { selectedPage = 2 }
                    )
                    
                    NavButton(
                        icon: "person.fill",
                        isSelected: selectedPage == 3,
                        action: { selectedPage = 3 }
                    )
                }
            }
            .padding()
            .background(Color.appBackground)
            
            Divider()

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

struct NavButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isSelected ? .appPrimary : .appSecondary)
                .frame(width: 44, height: 44)
                .background(isSelected ? Color.appPrimary.opacity(0.2) : Color.clear)
                .clipShape(Circle())
        }
    }
}

#Preview {
    ContentView()
}
