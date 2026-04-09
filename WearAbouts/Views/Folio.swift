//
//  Folio.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import SwiftUI

struct ProfilePage: View {
    @State private var savedDestinations: [SavedDestination] = []
    @State private var luggageItems: [LuggageItem] = []
    @State private var showAddLuggage: Bool = false
    @State private var selectedTab: Int = 0 // 0 = Saved, 1 = Luggage
    
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
                                    gradient: Gradient(colors: [Color.appPrimary, Color.appSecondary]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .shadow(color: Color.appPrimary.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Text("My Travel Profile")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.appTextPrimary)
                }
                .padding(.vertical)
                
                // Tab selector
                HStack(spacing: 0) {
                    Button(action: { selectedTab = 0 }) {
                        VStack(spacing: 4) {
                            Image(systemName: "bookmark.fill")
                            Text("Saved")
                                .font(.caption)
                        }
                        .foregroundColor(selectedTab == 0 ? .appPrimary : .appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedTab == 0 ? Color.appPrimary.opacity(0.1) : Color.clear)
                    }
                    
                    Button(action: { selectedTab = 1 }) {
                        VStack(spacing: 4) {
                            Image(systemName: "bag.fill")
                            Text("Luggage")
                                .font(.caption)
                        }
                        .foregroundColor(selectedTab == 1 ? .appAccent : .appTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedTab == 1 ? Color.appAccent.opacity(0.1) : Color.clear)
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Content
                if selectedTab == 0 {
                    savedDestinationsView
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
                    VStack(spacing: Spacing.medium) {
                        Image(systemName: "mappin.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.appTextSecondary)
                        Text("No saved destinations yet")
                            .foregroundColor(.appTextSecondary)
                        Text("Save destinations from the Map page")
                            .font(.caption)
                            .foregroundColor(.appTextSecondary)
                    }
                    .padding(.top, 60)
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
                        VStack(spacing: Spacing.medium) {
                            Image(systemName: "bag")
                                .font(.system(size: 50))
                                .foregroundColor(.appTextSecondary)
                            Text("Your luggage is empty")
                                .foregroundColor(.appTextSecondary)
                            Text("Add items to build your travel wardrobe")
                                .font(.caption)
                                .foregroundColor(.appTextSecondary)
                        }
                        .padding(.top, 40)
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
    
    func loadData() {
        savedDestinations = StorageService.getSavedDestinations()
        luggageItems = StorageService.getLuggageItems()
    }
}

struct SavedDestinationCard: View {
    let destination: SavedDestination
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            HStack {
                VStack(alignment: .leading) {
                    Text(destination.cityName)
                        .font(.headline)
                        .foregroundColor(.appTextPrimary)
                    Text(destination.country)
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(destination.temperature)
                        .font(.title3)
                        .foregroundColor(.appPrimary)
                    
                    StrictnessIndicator(level: destination.strictnessLevel)
                }
            }
            
            Text(destination.culturalNotes)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
                .lineLimit(2)
            
            HStack {
                Text("Saved \(destination.savedDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .cardStyle()
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
                .font(.caption)
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
                .foregroundColor(.appAccent)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                
                HStack(spacing: 8) {
                    Label(item.category, systemImage: "tag")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                    
                    if item.isModest {
                        Label("Modest", systemImage: "checkmark.circle.fill")
                            .font(.caption)
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
        .cardStyle()
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
