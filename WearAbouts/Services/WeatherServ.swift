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
        guard let url = URL(string: "https://geocoding-api.open-meteo.com/v1/search?name=\(encodedCity)&count=10") else {
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
                let result = try JSONDecoder().decode(GeocodeResponse.self, from: data)
                completion(.success(result.results ?? []))
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
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,precipitation") else {
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
                let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
