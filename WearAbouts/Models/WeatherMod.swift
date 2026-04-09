//
//  WeatherModel.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import Foundation

// MARK: - Geocoding Models
struct GeocodeResponse: Codable, Sendable {
    let results: [GeocodeResult]?
}

struct GeocodeResult: Codable, Sendable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let admin1: String?
    
    var displayName: String {
        if let state = admin1 {
            return "\(name), \(state), \(country)"
        } else {
            return "\(name), \(country)"
        }
    }
}

// MARK: - Weather Models
struct WeatherResponse: Codable, Sendable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable, Sendable {
    let temperature_2m: Double
    let precipitation: Double
}

// MARK: - Wikipedia Models
struct WikipediaResponse: Codable {
    let query: WikiQuery?
}

struct WikiQuery: Codable {
    let pages: [String: WikiPage]?
}

struct WikiPage: Codable {
    let extract: String?
}
