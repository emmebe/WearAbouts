//
//  Folio.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import SwiftUI

struct ProfilePage: View {
    @State private var savedDestinations: [SavedDestination] = []
    @State private var savedOutfits: [SavedOutfit] = []
    @State private var luggageItems: [LuggageItem] = []
    @State private var showAddLuggage: Bool = false
    @State private var selectedTab: Int = 0 // 0 = Saved Places, 1 = Saved Outfits, 2 = Luggage
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: Spacing.small) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.brandPrimary, Color.brandDark]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .shadow(color: Color.brandPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("My Travel Profile")
                        .font(AppFont.title2)
                        .foregroundColor(.appTextPrimary)
                }
                .padding(.vertical)
                
                // Tab selector
                HStack(spacing: 0) {
                    Button(action: { selectedTab = 0 }) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                            Text("Places")
                                .font(AppFont.caption)
                        }
                        .foregroundColor(selectedTab == 0 ? .brandPrimary : .appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedTab == 0 ? Color.brandPrimary.opacity(0.1) : Color.clear)
                    }
                    
                    Button(action: { selectedTab = 1 }) {
                        VStack(spacing: 4) {
                            Image(systemName: "bookmark.fill")
                            Text("Outfits")
                                .font(AppFont.caption)
                        }
                        .foregroundColor(selectedTab == 1 ? .brandAccent : .appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedTab == 1 ? Color.brandAccent.opacity(0.1) : Color.clear)
                    }
                    
                    Button(action: { selectedTab = 2 }) {
                        VStack(spacing: 4) {
                            Image(systemName: "bag.fill")
                            Text("Luggage")
                                .font(AppFont.caption)
                        }
                        .foregroundColor(selectedTab == 2 ? .brandDark : .appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedTab == 2 ? Color.brandDark.opacity(0.1) : Color.clear)
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Content
                if selectedTab == 0 {
                    savedDestinationsView
                } else if selectedTab == 1 {
                    savedOutfitsView
                } else {
                    luggageView
                }
            }
        }
        .onAppear {
            loadData()
        }
        .sheet(isPresented: $showAddLuggage) {
            AddLuggageView(onAdd: { item in
                StorageService.addLuggageItem(item)
                loadData()
            })
        }
    }
    
    var savedDestinationsView: some View {
        ScrollView {
            VStack(spacing: Spacing.medium) {
                if savedDestinations.isEmpty {
                    emptyState(
                        icon: "mappin.slash",
                        title: "No saved destinations yet",
                        subtitle: "Save destinations from the Map page"
                    )
                } else {
                    ForEach(savedDestinations) { destination in
                        SavedDestinationCard(destination: destination, onDelete: {
                            StorageService.removeDestination(id: destination.id)
                            loadData()
                        })
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    var savedOutfitsView: some View {
        ScrollView {
            VStack(spacing: Spacing.medium) {
                if savedOutfits.isEmpty {
                    emptyState(
                        icon: "bookmark.slash",
                        title: "No saved outfits yet",
                        subtitle: "Long press photos on the home feed to save them"
                    )
                } else {
                    let columns = [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(savedOutfits) { outfit in
                            SavedOutfitCard(outfit: outfit, onDelete: {
                                StorageService.removeOutfit(id: outfit.id)
                                loadData()
                            })
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    var luggageView: some View {
        VStack {
            // Add button
            Button(action: { showAddLuggage = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Item to Luggage")
                }
            }
            .accentButton()
            .padding()
            
            ScrollView {
                VStack(spacing: Spacing.medium) {
                    if luggageItems.isEmpty {
                        emptyState(
                            icon: "bag",
                            title: "Your luggage is empty",
                            subtitle: "Add items to build your travel wardrobe"
                        )
                    } else {
                        ForEach(luggageItems) { item in
                            LuggageItemCard(item: item, onDelete: {
                                StorageService.removeLuggageItem(id: item.id)
                                loadData()
                            })
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }
    
    func emptyState(icon: String, title: String, subtitle: String) -> some View {
        VStack(spacing: Spacing.medium) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(spacing: Spacing.small) {
                Text(title)
                    .font(AppFont.headline)
                    .foregroundColor(.appTextPrimary)
                Text(subtitle)
                    .font(AppFont.caption)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 60)
    }
    
    func loadData() {
        savedDestinations = StorageService.getSavedDestinations()
        savedOutfits = StorageService.getSavedOutfits()
        luggageItems = StorageService.getLuggageItems()
    }
}

// MARK: - Saved Outfit Card
struct SavedOutfitCard: View {
    let outfit: SavedOutfit
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: outfit.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(16)
            } placeholder: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
            }
            
            // Delete button
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.red)
                            .frame(width: 28, height: 28)
                    )
            }
            .padding(8)
        }
    }
}

// Keep existing SavedDestinationCard, LuggageItemCard, etc...

struct SavedDestinationCard: View {
    let destination: SavedDestination
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            HStack {
                VStack(alignment: .leading) {
                    Text(destination.cityName)
                        .font(AppFont.headline)
                        .foregroundColor(.appTextPrimary)
                    Text(destination.country)
                        .font(AppFont.caption)
                        .foregroundColor(.appTextSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(destination.temperature)
                        .font(AppFont.title2)
                        .foregroundColor(.brandPrimary)
                    
                    StrictnessIndicator(level: destination.strictnessLevel)
                }
            }
            
            Text(destination.culturalNotes)
                .font(AppFont.caption)
                .foregroundColor(.appTextSecondary)
                .lineLimit(2)
            
            HStack {
                Text("Saved \(destination.savedDate, style: .date)")
                    .font(AppFont.caption)
                    .foregroundColor(.appTextSecondary)
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .brandCard()
    }
}

struct StrictnessIndicator: View {
    let level: String
    
    var color: Color {
        switch level {
        case "Strict": return .red
        case "Moderate": return .orange
        default: return .green
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(level)
                .font(AppFont.caption)
                .foregroundColor(color)
        }
    }
}

struct LuggageItemCard: View {
    let item: LuggageItem
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: categoryIcon(item.category))
                .foregroundColor(.brandAccent)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(AppFont.headline)
                    .foregroundColor(.appTextPrimary)
                
                HStack(spacing: 8) {
                    Label(item.category, systemImage: "tag")
                        .font(AppFont.caption)
                        .foregroundColor(.appTextSecondary)
                    
                    if item.isModest {
                        Label("Modest", systemImage: "checkmark.circle.fill")
                            .font(AppFont.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .brandCard()
    }
    
    func categoryIcon(_ category: String) -> String {
        switch category {
        case "Top": return "tshirt"
        case "Bottom": return "rectangle.stack"
        case "Shoes": return "shoe"
        case "Accessory": return "bag"
        default: return "square"
        }
    }
}

struct AddLuggageView: View {
    @Environment(\.dismiss) var dismiss
    let onAdd: (LuggageItem) -> Void
    
    @State private var name: String = ""
    @State private var category: String = "Top"
    @State private var isModest: Bool = true
    @State private var isWeatherAppropriate: Bool = true
    
    let categories = ["Top", "Bottom", "Shoes", "Accessory"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Item Details") {
                    TextField("Item name (e.g., Blue t-shirt)", text: $name)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
                
                Section("Properties") {
                    Toggle("Modest / Conservative", isOn: $isModest)
                    Toggle("Weather Appropriate", isOn: $isWeatherAppropriate)
                }
                
                Button("Add to Luggage") {
                    let item = LuggageItem(
                        name: name,
                        category: category,
                        isModest: isModest,
                        isWeatherAppropriate: isWeatherAppropriate
                    )
                    onAdd(item)
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("Add Luggage Item")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
}

#Preview {
    ProfilePage()
}
