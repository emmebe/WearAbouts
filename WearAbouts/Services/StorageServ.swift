//
//  StorageServ.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/9/26.
//

import Foundation

class StorageService {
    
    // MARK: - Saved Destinations
    
    static func getSavedDestinations() -> [SavedDestination] {
        guard let data = UserDefaults.standard.data(forKey: "savedDestinations") else {
            return []
        }
        
        do {
            let destinations = try JSONDecoder().decode([SavedDestination].self, from: data)
            return destinations
        } catch {
            print("Error loading destinations: \(error)")
            return []
        }
    }
    
    static func saveDestination(_ destination: SavedDestination) {
        var destinations = getSavedDestinations()
        
        // Check if already saved
        if destinations.contains(where: { $0.cityName == destination.cityName && $0.country == destination.country }) {
            return // Already saved
        }
        
        destinations.append(destination)
        
        do {
            let data = try JSONEncoder().encode(destinations)
            UserDefaults.standard.set(data, forKey: "savedDestinations")
        } catch {
            print("Error saving destination: \(error)")
        }
    }
    
    static func removeDestination(id: String) {
        var destinations = getSavedDestinations()
        destinations.removeAll { $0.id == id }
        
        do {
            let data = try JSONEncoder().encode(destinations)
            UserDefaults.standard.set(data, forKey: "savedDestinations")
        } catch {
            print("Error removing destination: \(error)")
        }
    }
    
    // MARK: - Luggage Items
    
    static func getLuggageItems() -> [LuggageItem] {
        guard let data = UserDefaults.standard.data(forKey: "luggageItems") else {
            return []
        }
        
        do {
            let items = try JSONDecoder().decode([LuggageItem].self, from: data)
            return items
        } catch {
            print("Error loading luggage: \(error)")
            return []
        }
    }
    
    static func addLuggageItem(_ item: LuggageItem) {
        var items = getLuggageItems()
        items.append(item)
        
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: "luggageItems")
        } catch {
            print("Error saving luggage item: \(error)")
        }
    }
    
    static func removeLuggageItem(id: String) {
        var items = getLuggageItems()
        items.removeAll { $0.id == id }
        
        do {
            let data = try JSONEncoder().encode(items)
            UserDefaults.standard.set(data, forKey: "luggageItems")
        } catch {
            print("Error removing luggage item: \(error)")
        }
    }
    
    static func getSavedOutfits() -> [SavedOutfit] {
        guard let data = UserDefaults.standard.data(forKey: "savedOutfits") else {
            return []
        }
        
        do {
            let outfits = try JSONDecoder().decode([SavedOutfit].self, from: data)
            return outfits
        } catch {
            print("Error loading outfits: \(error)")
            return []
        }
    }

    static func saveOutfit(_ outfit: SavedOutfit) {
        var outfits = getSavedOutfits()
        
        // Check if already saved
        if outfits.contains(where: { $0.imageURL == outfit.imageURL }) {
            return // Already saved
        }
        
        outfits.append(outfit)
        
        do {
            let data = try JSONEncoder().encode(outfits)
            UserDefaults.standard.set(data, forKey: "savedOutfits")
        } catch {
            print("Error saving outfit: \(error)")
        }
    }

    static func removeOutfit(id: String) {
        var outfits = getSavedOutfits()
        outfits.removeAll { $0.id == id }
        
        do {
            let data = try JSONEncoder().encode(outfits)
            UserDefaults.standard.set(data, forKey: "savedOutfits")
        } catch {
            print("Error removing outfit: \(error)")
        }
    }
    
    static func toggleOutfit(from photo: UnsplashPhoto) {
        let outfit = SavedOutfit(from: photo)
        let outfits = getSavedOutfits()
        
        if let existing = outfits.first(where: { $0.imageURL == outfit.imageURL }) {
            removeOutfit(id: existing.id) // unsave
        } else {
            saveOutfit(outfit) // save
        }
    }
    
    static func isOutfitSaved(from photo: UnsplashPhoto) -> Bool {
        let outfits = getSavedOutfits()
        return outfits.contains(where: { $0.imageURL == photo.urls.small })
    }
}
