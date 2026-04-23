//
//  AppMod.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/9/26.
//

import Foundation

// MARK: - Saved Destination
struct SavedDestination: Codable, Identifiable {
    let id: String
    let cityName: String
    let country: String
    let latitude: Double
    let longitude: Double
    let temperature: String
    let culturalNotes: String
    let strictnessLevel: String // "Casual", "Moderate", "Strict"
    let savedDate: Date
    
    init(from city: GeocodeResult, temp: String, notes: String, strictness: String) {
        self.id = UUID().uuidString
        self.cityName = city.name
        self.country = city.country
        self.latitude = city.latitude
        self.longitude = city.longitude
        self.temperature = temp
        self.culturalNotes = notes
        self.strictnessLevel = strictness
        self.savedDate = Date()
    }
}

// MARK: - Luggage Item
struct LuggageItem: Codable, Identifiable {
    let id: String
    let name: String
    let category: String // "Top", "Bottom", "Shoes", "Accessory"
    let isModest: Bool
    let isWeatherAppropriate: Bool
    
    init(name: String, category: String, isModest: Bool, isWeatherAppropriate: Bool) {
        self.id = UUID().uuidString
        self.name = name
        self.category = category
        self.isModest = isModest
        self.isWeatherAppropriate = isWeatherAppropriate
    }
}

struct UnsplashPhoto: Identifiable {
    let id: String
    let urls: UnsplashURLs
    let user: UnsplashUser
    let description: String?
    let location: UnsplashLocation?   // ✅ ADD THIS
}

struct UnsplashURLs {
    let small: String
    let regular: String
}

struct UnsplashUser {
    let name: String
}

// ✅ ADD THIS ENTIRE STRUCT (NEW)
struct UnsplashLocation {
    let name: String?
    let city: String?
    let country: String?
}

// MARK: - Country Info
struct CountryResponse: Codable {
    let name: CountryName
    let region: String
    let subregion: String?
}

struct CountryName: Codable {
    let common: String
}

// MARK: - Saved Outfit
struct SavedOutfit: Codable, Identifiable {
    let id: String
    let imageURL: String
    let photographer: String
    let savedDate: Date
    let notes: String?
    
    init(from photo: UnsplashPhoto, notes: String? = nil) {
        self.id = UUID().uuidString
        self.imageURL = photo.urls.regular
        self.photographer = photo.user.name
        self.savedDate = Date()
        self.notes = notes
    }
}
