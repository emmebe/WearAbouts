//
//  Find.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/2/26.
//

import SwiftUI

struct MapPage: View {
    @State private var cityName: String = ""
    @State private var searchResults: [GeocodeResult] = []
    @State private var selectedCity: GeocodeResult?
    @State private var temperature: String = ""
    @State private var weatherDescription: String = ""
    @State private var culturalInfo: String = ""
    @State private var isLoading: Bool = false
    @State private var isCelsius: Bool = true
    @State private var showError: String = ""
    @State private var isSaved: Bool = false  // THIS WAS MISSING
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search section
                VStack(spacing: Spacing.medium) {
                    TextField("Enter city name", text: $cityName)
                        .appTextField()
                        .onSubmit {
                            searchCity()
                        }
                    
                    Button(action: searchCity) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search Destination")
                        }
                    }
                    .primaryButton()
                    .disabled(cityName.isEmpty)
                    .opacity(cityName.isEmpty ? 0.5 : 1.0)
                    
                    if !showError.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(showError)
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                    }
                    
                    // City selection list
                    if !searchResults.isEmpty && selectedCity == nil {
                        ScrollView {
                            VStack(spacing: Spacing.small) {
                                Text("Select a location:")
                                    .font(.headline)
                                    .foregroundColor(.appTextPrimary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                
                                ForEach(searchResults) { city in
                                    Button(action: {
                                        withAnimation {
                                            selectedCity = city
                                            getWeather(lat: city.latitude, lon: city.longitude)
                                            getCulturalInfo(country: city.country)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundColor(.appPrimary)
                                                .font(.title2)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(city.name)
                                                    .font(.headline)
                                                    .foregroundColor(.appTextPrimary)
                                                Text(city.displayName)
                                                    .font(.caption)
                                                    .foregroundColor(.appTextSecondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.appTextSecondary)
                                                .font(.caption)
                                        }
                                    }
                                    .cardStyle()
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.top)
                
                // Loading or Results
                if isLoading {
                    Spacer()
                    VStack(spacing: Spacing.medium) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.appPrimary)
                        Text("Loading destination info...")
                            .foregroundColor(.appTextSecondary)
                    }
                    Spacer()
                } else if selectedCity != nil {
                    // Weather results page
                    ScrollView {
                        VStack(spacing: Spacing.large) {
                            // City header
                            VStack(spacing: Spacing.small) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.appPrimary)
                                
                                Text(selectedCity?.name ?? "")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.appTextPrimary)
                                
                                Text(selectedCity?.country ?? "")
                                    .foregroundColor(.appTextSecondary)
                            }
                            .padding(.top)
                            
                            // Temperature card with gradient
                            VStack(spacing: Spacing.medium) {
                                HStack {
                                    Text("Temperature")
                                        .font(.headline)
                                        .foregroundColor(.appTextPrimary)
                                    Spacer()
                                    Button(action: {
                                        isCelsius.toggle()
                                        updateTemperatureDisplay()
                                    }) {
                                        Text(isCelsius ? "°C" : "°F")
                                    }
                                    .secondaryButton()
                                }
                                
                                Text(temperature)
                                    .font(.system(size: 56, weight: .bold))
                                    .foregroundColor(.appPrimary)
                                
                                Text(weatherDescription)
                                    .font(.headline)
                                    .foregroundColor(.appTextSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .featuredCardStyle()
                            .padding(.horizontal)
                            
                            // Cultural info card
                            VStack(alignment: .leading, spacing: Spacing.medium) {
                                HStack {
                                    Image(systemName: "book.fill")
                                        .foregroundColor(.appPrimary)
                                    Text("Cultural Dress Guidance")
                                        .font(.headline)
                                        .foregroundColor(.appTextPrimary)
                                }
                                
                                Text(culturalInfo)
                                    .font(.body)
                                    .foregroundColor(.appTextSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .cardStyle()
                            .padding(.horizontal)
                            
                            // Strictness indicator
                            VStack(alignment: .leading, spacing: Spacing.small) {
                                Text("Dress Code Level")
                                    .font(.headline)
                                    .foregroundColor(.appTextPrimary)
                                
                                HStack(spacing: Spacing.small) {
                                    let strictness = determineStrictness(country: selectedCity?.country ?? "")
                                    Circle()
                                        .fill(strictnessColor(strictness))
                                        .frame(width: 12, height: 12)
                                    Text(strictness)
                                        .font(.subheadline)
                                        .foregroundColor(.appTextSecondary)
                                }
                            }
                            .cardStyle()
                            .padding(.horizontal)
                            
                            // SAVE BUTTON
                            Button(action: toggleSave) {
                                HStack {
                                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                    Text(isSaved ? "Saved" : "Save Destination")
                                }
                            }
                            .primaryButton()
                            .padding(.horizontal)
                            
                            Button(action: resetSearch) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Search Another Destination")
                                }
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .padding(.horizontal)
                            
                            Spacer(minLength: Spacing.xLarge)
                        }
                        .padding(.bottom)
                    }
                } else {
                    Spacer()
                    VStack(spacing: Spacing.medium) {
                        Image(systemName: "map")
                            .font(.system(size: 60))
                            .foregroundColor(.appPrimary.opacity(0.5))
                        Text("Search for a destination to begin")
                            .foregroundColor(.appTextSecondary)
                    }
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Functions
    
    func searchCity() {
        if cityName.isEmpty { return }
        
        isLoading = true
        showError = ""
        searchResults = []
        selectedCity = nil
        
        WeatherService.searchCity(name: cityName) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let cities):
                    if cities.isEmpty {
                        showError = "No cities found. Try a different search."
                    } else {
                        searchResults = cities
                    }
                case .failure(let error):
                    showError = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func getWeather(lat: Double, lon: Double) {
        isLoading = true
        
        WeatherService.getWeather(lat: lat, lon: lon) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    let tempC = weather.current.temperature_2m
                    temperature = isCelsius ? "\(Int(tempC))°C" : "\(Int(tempC * 9/5 + 32))°F"
                    
                    if tempC > 30 {
                        weatherDescription = "Very Hot - Light, breathable fabrics recommended"
                    } else if tempC > 25 {
                        weatherDescription = "Hot - Dress light and stay cool"
                    } else if tempC > 20 {
                        weatherDescription = "Warm - Comfortable casual attire"
                    } else if tempC > 15 {
                        weatherDescription = "Mild - Light layers recommended"
                    } else if tempC > 10 {
                        weatherDescription = "Cool - Bring a jacket"
                    } else if tempC > 5 {
                        weatherDescription = "Cold - Warm clothing needed"
                    } else {
                        weatherDescription = "Very Cold - Heavy winter clothing required"
                    }
                    
                    checkIfSaved()  // Check if already saved
                    isLoading = false
                    
                case .failure:
                    showError = "Could not fetch weather data"
                    isLoading = false
                }
            }
        }
    }
    
    func getCulturalInfo(country: String) {
        WikipediaService.getCulturalInfo(country: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    culturalInfo = info
                case .failure:
                    culturalInfo = "General tip: Research local customs before visiting. Many cultures value modest dress, especially at religious sites."
                }
            }
        }
    }
    
    func updateTemperatureDisplay() {
        let tempString = temperature.replacingOccurrences(of: "°C", with: "").replacingOccurrences(of: "°F", with: "")
        if let temp = Double(tempString) {
            if isCelsius {
                let tempC = (temp - 32) * 5/9
                temperature = "\(Int(tempC))°C"
            } else {
                let tempF = temp * 9/5 + 32
                temperature = "\(Int(tempF))°F"
            }
        }
    }
    
    func checkIfSaved() {
        let saved = StorageService.getSavedDestinations()
        isSaved = saved.contains(where: {
            $0.cityName == selectedCity?.name && $0.country == selectedCity?.country
        })
    }
    
    func toggleSave() {
        guard let city = selectedCity else { return }
        
        if isSaved {
            // Remove
            let saved = StorageService.getSavedDestinations()
            if let destination = saved.first(where: { $0.cityName == city.name && $0.country == city.country }) {
                StorageService.removeDestination(id: destination.id)
                isSaved = false
            }
        } else {
            // Save
            let strictness = determineStrictness(country: city.country)
            let destination = SavedDestination(
                from: city,
                temp: temperature,
                notes: culturalInfo,
                strictness: strictness
            )
            StorageService.saveDestination(destination)
            isSaved = true
        }
    }
    
    func determineStrictness(country: String) -> String {
        let strictCountries = ["Saudi Arabia", "Iran", "United Arab Emirates", "Qatar", "Afghanistan"]
        let moderateCountries = ["India", "Thailand", "Malaysia", "Indonesia", "Turkey", "Egypt", "Morocco"]
        
        if strictCountries.contains(country) {
            return "Strict"
        } else if moderateCountries.contains(country) {
            return "Moderate"
        } else {
            return "Casual"
        }
    }
    
    func strictnessColor(_ level: String) -> Color {
        switch level {
        case "Strict": return .red
        case "Moderate": return .orange
        default: return .green
        }
    }
    
    func resetSearch() {
        selectedCity = nil
        searchResults = []
        cityName = ""
        temperature = ""
        weatherDescription = ""
        culturalInfo = ""
        showError = ""
        isSaved = false
    }
}

#Preview {
    MapPage()
}
