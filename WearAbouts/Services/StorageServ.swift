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
}
