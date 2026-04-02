//
//  WeatherModel.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import Foundation

// Data models for Geocoding API
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
}

// Data models for Weather API
struct WeatherResponse: Codable, Sendable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable, Sendable {
    let temperature_2m: Double
    let precipitation: Double
}
