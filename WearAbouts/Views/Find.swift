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
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                TextField("Enter city name", text: $cityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onSubmit {
                        searchCity()
                    }
                
                Button("Search") {
                    searchCity()
                }
                
                if !searchResults.isEmpty && selectedCity == nil {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(searchResults) { city in
                                Button(action: {
                                    selectedCity = city
                                    getWeather(lat: city.latitude, lon: city.longitude)
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(city.name)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)
                                            Text("\(city.admin1 ?? ""), \(city.country)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
            
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if selectedCity != nil {
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text(selectedCity?.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Temperature: \(temperature)")
                                .font(.title2)
                            
                            Button(action: {
                                isCelsius.toggle()
                                updateTemperatureDisplay()
                            }) {
                                Text(isCelsius ? "°F" : "°C")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        
                        Text(weatherDescription)
                        Text(culturalInfo)
                            .padding()
                        
                        Button("Search Again") {
                            selectedCity = nil
                            searchResults = []
                            cityName = ""
                            temperature = ""
                            weatherDescription = ""
                            culturalInfo = ""
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    .padding()
                }
            } else {
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .padding()
                    Text("Map placeholder")
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
    }

    func searchCity() {
        if cityName.isEmpty { return }
        
        isLoading = true
        searchResults = []
        selectedCity = nil
        
        WeatherService.searchCity(name: cityName) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let cities):
                    searchResults = cities
                    if cities.isEmpty {
                        culturalInfo = "City not found"
                    }
                case .failure:
                    culturalInfo = "Error finding city"
                }
            }
        }
    }
    
    func getWeather(lat: Double, lon: Double) {
        isLoading = true
        
        WeatherService.getWeather(lat: lat, lon: lon) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let weather):
                    let tempC = weather.current.temperature_2m
                    temperature = isCelsius ? "\(Int(tempC))°C" : "\(Int(tempC * 9/5 + 32))°F"
                    
                    if tempC > 25 {
                        weatherDescription = "It's hot - dress light"
                    } else if tempC > 15 {
                        weatherDescription = "It's mild - dress comfortably"
                    } else {
                        weatherDescription = "It's cold - dress warm"
                    }
                    
                    culturalInfo = "Check local customs for \(selectedCity?.name ?? cityName)"
                case .failure:
                    culturalInfo = "Error getting weather"
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
}

#Preview {
    MapPage()
}
