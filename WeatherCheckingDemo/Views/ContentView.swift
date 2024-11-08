//
//  ContentView.swift
//  WeatherCheckingDemo
//
//  Created by Richa Mangukiya on 10/10/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Varaibles
    @StateObject var viewModel: WeatherViewModel
    @State private var city: String = ""
    
    // MARK: - View Body
    var body: some View {
        NavigationView {
            VStack {
                
                // MARK: - Search View
                HStack {
                    TextField(NSLocalizedString("Enter city name", comment: "City Input"), text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        if !city.isEmpty {
                            viewModel.fetchWeather(for: city)
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                    }
                }
                
                // MARK: - Display Weather View
                if viewModel.isLoading {
                    ProgressView(NSLocalizedString("Fetching weather...", comment: "Fetching Weather"))
                } else if let weather = viewModel.weatherData {
                    WeatherDetailView(weather: weather)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                // MARK: - Current Location Weather View
                Button(action: {
                    viewModel.fetchWeatherForCurrentLocation()
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text(NSLocalizedString("Get Weather for Current Location", comment: "Get Current Weather"))
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 40)
            }
            .navigationTitle(NSLocalizedString("Weather App", comment: "Title APP"))
        }
    }
}

// MARK: - Weather Details Display View
struct WeatherDetailView: View {
    let weather: WeatherModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text(weather.name)
                .font(.largeTitle)
                .bold()
            
            if let icon = weather.weather.first?.icon {
                WeatherIconView(icon: icon)
            }
            
            Text("\(String(format: "%.1f", weather.main.temp))°C")
                .font(.system(size: 50))
                .bold()
            
            Text(weather.weather.first?.description.capitalized ?? "")
                .font(.title)
        }
        .padding()
    }
}

// MARK: - Location Weather Icon View
struct WeatherIconView: View {
    
    let icon: String
    
    var body: some View {
        let iconUrl = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        
        AsyncImage(url: URL(string: iconUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else if phase.error != nil {
                Text("Error loading image")
            } else {
                ProgressView()
            }
        }
    }
}

// Preview for SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let weatherService = WeatherService()
        let viewModel = WeatherViewModel(weatherService: weatherService)
        ContentView(viewModel: viewModel)
    }
}
