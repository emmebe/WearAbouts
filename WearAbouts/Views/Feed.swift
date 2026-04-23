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
    @State private var searchQuery: String = ""
    @State private var errorMessage: String = ""
    
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
                    TextField("Search a destination (e.g., Tokyo)", text: $searchQuery)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .onSubmit {
                            loadPhotos()
                        }
                    
                    Button(action: loadPhotos) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.appPrimary)
                    }
                }
                .padding(.horizontal)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
                
                // Content
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
                        Text("No style photos found.")
                            .foregroundColor(.appTextSecondary)
                    }
                    Spacer()
                } else {
                    
                    // Masonry Grid
                    ScrollView {
                        HStack(alignment: .top, spacing: 8) {
                            
                            VStack(spacing: 8) {
                                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                                    if index % 2 == 0 {
                                        PhotoCard(photo: photo)
                                    }
                                }
                            }
                            
                            VStack(spacing: 8) {
                                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                                    if index % 2 != 0 {
                                        PhotoCard(photo: photo)
                                    }
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
                loadDefaultPhotos()
            }
        }
    }
    
    // Default feed (always shows on startup)
    func loadDefaultPhotos() {
        isLoading = true
        errorMessage = ""
        
        UnsplashService.searchFashionPhotos(location: "global") { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedPhotos):
                    photos = fetchedPhotos
                case .failure(let error):
                    photos = []
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Search (only when user types)
    func loadPhotos() {
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            loadDefaultPhotos()
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let enhancedQuery = "\(trimmed) street style outfit fashion"
        
        UnsplashService.searchPhotos(query: enhancedQuery) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedPhotos):
                    photos = fetchedPhotos
                    errorMessage = fetchedPhotos.isEmpty ? "No results found." : ""
                case .failure(let error):
                    photos = []
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct PhotoCard: View {
    let photo: UnsplashPhoto
    
    @State private var isSaved: Bool = false
    
    private var imageHeight: CGFloat {
        [180, 220, 260].randomElement()!
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            AsyncImage(url: URL(string: photo.urls.small)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: imageHeight)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: imageHeight)
                    .cornerRadius(12)
                    .overlay(ProgressView())
            }
            
            Button {
                isSaved.toggle()
                StorageService.toggleOutfit(from: photo)
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(isSaved ? Color.appPrimary : Color.black.opacity(0.6))
                    )
                    .scaleEffect(isSaved ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSaved)
            }
            .padding(8)
        }
        .onAppear {
            isSaved = StorageService.isOutfitSaved(from: photo)
        }
    }
}

#Preview {
    HomePage()
}
