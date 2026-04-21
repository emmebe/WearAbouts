//
//  WeatherServ.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import Foundation

class WeatherService {
    
    // Search for cities by name
    static func searchCity(
        name: String,
        completion: @escaping (Result<[GeocodeResult], Error>) -> Void
    ) {
        let encodedCity = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(encodedCity)&count=10&language=en&format=json"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            
            do {
                let results = try parseGeocodeResults(from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Get weather for specific coordinates
    static func getWeather(
        lat: Double,
        lon: Double,
        completion: @escaping (Result<WeatherResponse, Error>) -> Void
    ) {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,precipitation"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            
            do {
                let result = try parseWeatherResponse(from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private static func parseGeocodeResults(from data: Data) throws -> [GeocodeResult] {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "Invalid geocode response", code: -1)
        }
        
        let results = json["results"] as? [[String: Any]] ?? []
        return results.compactMap { item in
            guard
                let id = item["id"] as? Int,
                let name = item["name"] as? String,
                let latitude = item["latitude"] as? Double,
                let longitude = item["longitude"] as? Double,
                let country = item["country"] as? String
            else {
                return nil
            }
            
            return GeocodeResult(
                id: id,
                name: name,
                latitude: latitude,
                longitude: longitude,
                country: country,
                admin1: item["admin1"] as? String
            )
        }
    }
    
    private static func parseWeatherResponse(from data: Data) throws -> WeatherResponse {
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let current = json["current"] as? [String: Any],
            let temperature = current["temperature_2m"] as? Double,
            let precipitation = current["precipitation"] as? Double
        else {
            throw NSError(domain: "Invalid weather response", code: -1)
        }
        
        return WeatherResponse(
            current: CurrentWeather(
                temperature_2m: temperature,
                precipitation: precipitation
            )
        )
    }
}
