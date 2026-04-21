//
//  AIServ.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/16/26.
//

import Foundation

class AICulturalService {
    private enum ServiceError: LocalizedError {
        case missingAPIKey
        case invalidResponse
        case requestFailed(statusCode: Int, message: String)
        
        var errorDescription: String? {
            switch self {
            case .missingAPIKey:
                return "Anthropic API key is missing. Set ANTHROPIC_API_KEY in the scheme environment or Info.plist."
            case .invalidResponse:
                return "The AI service returned an unreadable response."
            case .requestFailed(let statusCode, let message):
                return "Anthropic request failed (\(statusCode)): \(message)"
            }
        }
    }
    
    private static var apiKey: String? {
        let envKey = ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"]?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let envKey, !envKey.isEmpty {
            return envKey
        }
        
        let bundleKey = Bundle.main.object(forInfoDictionaryKey: "ANTHROPIC_API_KEY") as? String
        let trimmedBundleKey = bundleKey?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let trimmedBundleKey, !trimmedBundleKey.isEmpty {
            return trimmedBundleKey
        }
        
        return nil
    }
    
    static func getAICulturalGuidance(
        city: String,
        country: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let apiKey else {
            completion(.failure(ServiceError.missingAPIKey))
            return
        }
        
        let prompt = """
You are a cultural intelligence advisor for travelers. Provide SPECIFIC, NUANCED dress code guidance for \(city), \(country).

Current date: \(Date().formatted(date: .long, time: .omitted))

Address:
1. General strictness level (Casual/Moderate/Strict)
2. Specific body coverage norms:
   - Are shoulders/chest/midriff/legs/knees expected to be covered?
   - Are there DIFFERENCES in importance? (e.g., Japan: chest > legs)
3. Legal requirements vs social customs
4. Religious site requirements
5. Regional differences within the country
6. Current events affecting dress norms (protests, policy changes, etc.)
7. Foreigner treatment (are tourists given more leeway?)

Format as:
[Strictness: Casual/Moderate/Strict]

GENERAL:
[2-3 sentences on overall dress culture]

KEY AREAS:
- Shoulders: [required/recommended/casual]
- Chest: [required/recommended/casual]
- Legs/Knees: [required/recommended/casual]
- Head covering: [required/recommended/not needed]

RELIGIOUS SITES:
[Specific requirements]

IMPORTANT:
[3-4 bullet points with nuanced details, foreigner treatment, regional differences]

Be honest about enforcement - legal vs cultural expectations. Mention if dress codes are strictly enforced or loosely followed.
"""
        
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let body: [String: Any] = [
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 1000,
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
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
                    let message = extractErrorMessage(from: data) ?? String(decoding: data, as: UTF8.self)
                    completion(.failure(ServiceError.requestFailed(statusCode: httpResponse.statusCode, message: message)))
                    return
                }
                
                if let text = extractResponseText(from: data),
                   !text.isEmpty {
                    completion(.success(text))
                } else {
                    completion(.failure(ServiceError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private static func extractResponseText(from data: Data) -> String? {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let content = json["content"] as? [[String: Any]]
        else {
            return nil
        }
        
        return content.first(where: { ($0["type"] as? String) == "text" })?["text"] as? String
    }
    
    private static func extractErrorMessage(from data: Data) -> String? {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let error = json["error"] as? [String: Any]
        else {
            return nil
        }
        
        return error["message"] as? String
    }
}
