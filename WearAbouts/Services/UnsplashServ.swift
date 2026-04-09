//
//  UnsplashServ.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/9/26.
//

import Foundation

class UnsplashService {
    
    // PASTE YOUR UNSPLASH ACCESS KEY HERE
    private static let accessKey = "cTyqggMFRZVEZ46mFM3ZonW0bvY6FGGzNj8_9mmX9HU"
    
    static func searchPhotos(query: String, completion: @escaping (Result<[UnsplashPhoto], Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.unsplash.com/search/photos?query=\(encodedQuery)&per_page=20&client_id=\(accessKey)"
        
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
                let result = try JSONDecoder().decode(UnsplashResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
