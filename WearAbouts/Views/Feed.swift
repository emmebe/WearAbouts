//
//  Feed.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import SwiftUI

struct HomePage: View {
    @State private var photos: [UnsplashPhoto] = []
    @State private var isLoading: Bool = false
    @State private var searchQuery: String = "travel fashion street style"
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: Spacing.small) {
                    Text("Style Inspiration")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.appTextPrimary)
                    
                    Text("Global travel fashion & local street style")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
                .padding(.vertical)
                
                // Search bar
                HStack {
                    TextField("Search styles (e.g., Tokyo street fashion)", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: loadPhotos) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.appPrimary)
                    }
                }
                .padding(.horizontal)
                
                // Photo grid
                if isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.appPrimary)
                    Spacer()
                } else if photos.isEmpty {
                    Spacer()
                    VStack(spacing: Spacing.medium) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 60))
                            .foregroundColor(.appTextSecondary)
                        Text("Tap refresh to load style inspiration")
                            .foregroundColor(.appTextSecondary)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(photos) { photo in
                                AsyncImage(url: URL(string: photo.urls.small)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                        .overlay(
                                            ProgressView()
                                                .tint(.appPrimary)
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            if photos.isEmpty {
                loadPhotos()
            }
        }
    }
    
    func loadPhotos() {
        isLoading = true
        
        UnsplashService.searchPhotos(query: searchQuery) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedPhotos):
                    photos = fetchedPhotos
                case .failure(let error):
                    print("Error loading photos: \(error)")
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
