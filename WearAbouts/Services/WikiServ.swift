//
//  WikiServ.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/8/26.
//

import Foundation

class WikipediaService {
    
    // Get cultural information about a country
    static func getCulturalInfo(
        country: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let encodedCountry = country.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro=1&explaintext=1&titles=Culture_of_\(encodedCountry)"
        
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
                if let extract = try extractWikipediaText(from: data) {
                    let dressInfo = extractDressInfo(from: extract)
                    completion(.success(dressInfo))
                } else {
                    completion(.success("Cultural information not available"))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Extract dress-related information from text
    private static func extractDressInfo(from text: String) -> String {
        let keywords = ["dress", "clothing", "attire", "modest", "custom", "tradition", "etiquette", "wear"]
        let sentences = text.components(separatedBy: ". ")
        
        var relevantSentences: [String] = []
        for sentence in sentences {
            for keyword in keywords {
                if sentence.lowercased().contains(keyword) {
                    relevantSentences.append(sentence)
                    break
                }
            }
            if relevantSentences.count >= 3 { break }
        }
        
        if relevantSentences.isEmpty {
            return "Local customs emphasize respectful dress. Research specific dress codes for religious sites and formal venues."
        }
        
        return relevantSentences.joined(separator: ". ") + "."
    }
    
    private static func extractWikipediaText(from data: Data) throws -> String? {
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let query = json["query"] as? [String: Any],
            let pages = query["pages"] as? [String: Any]
        else {
            throw NSError(domain: "Invalid Wikipedia response", code: -1)
        }
        
        for value in pages.values {
            if let page = value as? [String: Any],
               let extract = page["extract"] as? String,
               !extract.isEmpty {
                return extract
            }
        }
        
        return nil
    }
}
