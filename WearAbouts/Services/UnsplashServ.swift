//
//  UnsplashServ.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/9/26.
//

import Foundation

class UnsplashService {
    private enum ServiceError: LocalizedError {
        case missingAccessKey
        case invalidURL
        case requestFailed(statusCode: Int, message: String)
        
        var errorDescription: String? {
            switch self {
            case .missingAccessKey:
                return "Unsplash access key is missing. Set UNSPLASH_ACCESS_KEY in the scheme environment or WearAbouts/Secrets.plist."
            case .invalidURL:
                return "Could not build the Unsplash request URL."
            case .requestFailed(let statusCode, let message):
                return "Unsplash request failed (\(statusCode)): \(message)"
            }
        }
    }
    
    private static var accessKey: String? {
        let envKey = ProcessInfo.processInfo.environment["UNSPLASH_ACCESS_KEY"]?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let envKey, !envKey.isEmpty, envKey != "YOUR_UNSPLASH_ACCESS_KEY_HERE" {
            return envKey
        }
        
        let bundleKey = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_ACCESS_KEY") as? String
        let trimmedBundleKey = bundleKey?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let trimmedBundleKey, !trimmedBundleKey.isEmpty, trimmedBundleKey != "YOUR_UNSPLASH_ACCESS_KEY_HERE" {
            return trimmedBundleKey
        }
        
        if
            let secretsURL = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let secrets = NSDictionary(contentsOf: secretsURL) as? [String: Any],
            let plistKey = secrets["UNSPLASH_ACCESS_KEY"] as? String
        {
            let trimmedPlistKey = plistKey.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedPlistKey.isEmpty, trimmedPlistKey != "YOUR_UNSPLASH_ACCESS_KEY_HERE" {
                return trimmedPlistKey
            }
        }
        
        return nil
    }
    
    static func searchFashionPhotos(location: String = "global", completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void) {
        let fashionQueries = [
            "\(location) street style fashion",
            "\(location) street fashion outfit",
            "\(location) fashion style",
            "street style \(location)",
            "\(location) fashion week",
            "\(location) outfit inspiration"
        ]
        
        let query = fashionQueries.randomElement() ?? "street fashion style"
        searchPhotos(query: query, completion: completion)
    }
    
    static func searchPhotos(query: String, completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void) {
        guard let accessKey else {
            completion(.failure(ServiceError.missingAccessKey))
            return
        }
        
        var components = URLComponents(string: "https://api.unsplash.com/search/photos")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "orientation", value: "portrait")
        ]
        
        guard let url = components?.url else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }
            
            do {
                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    let message = String(decoding: data, as: UTF8.self)
                    completion(.failure(ServiceError.requestFailed(statusCode: httpResponse.statusCode, message: message)))
                    return
                }
                
                let photos = try parsePhotos(from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private static func parsePhotos(from data: Data) throws -> [UnsplashPhoto] {
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let results = json["results"] as? [[String: Any]]
        else {
            throw ServiceError.requestFailed(statusCode: -1, message: "Unsplash returned malformed photo data.")
        }
        
        return results.compactMap { item in
            guard
                let id = item["id"] as? String,
                let urlsDict = item["urls"] as? [String: Any],
                let small = urlsDict["small"] as? String,
                let regular = urlsDict["regular"] as? String,
                let userDict = item["user"] as? [String: Any],
                let userName = userDict["name"] as? String
            else {
                return nil
            }
            
            // 🔹 NEW: LOCATION PARSING
            var location: UnsplashLocation? = nil
            if let locDict = item["location"] as? [String: Any] {
                location = UnsplashLocation(
                    name: locDict["name"] as? String,
                    city: locDict["city"] as? String,
                    country: locDict["country"] as? String
                )
            }
            
            return UnsplashPhoto(
                id: id,
                urls: UnsplashURLs(small: small, regular: regular),
                user: UnsplashUser(name: userName),
                description: item["description"] as? String,
                location: location
            )
        }
    }
}


