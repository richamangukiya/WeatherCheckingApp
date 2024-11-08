//
//  OpenWeatherViewModel.swift
//  WeatherCheckingDemo
//
//  Created by Richa Mangukiya on 10/10/24.
//

import Foundation
import CoreLocation

//MARK: - Protocol
protocol WeatherServiceProtocol {
    func fetchWeather(city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void)
    func fetchWeatherByCoordinates(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void)
}

//MARK: - Weather ViewModel
class WeatherViewModel: NSObject, ObservableObject {
    
    //MARK: - Variables
    @Published var weatherData: WeatherModel?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let weatherService: WeatherServiceProtocol
    private let locationManager = CLLocationManager()
    
    //MARK: - Initializers
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        super.init()
        self.locationManager.delegate = self
    }
    
    //MARK: - Fetch Weather By City
    func fetchWeather(for city: String) {
        isLoading = true
        weatherService.fetchWeather(city: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.weatherData = data
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    //MARK: - Fetch Weather Current Location
    func fetchWeatherForCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

//MARK: - Extension For Location Delegates Methods
extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            weatherService.fetchWeatherByCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let data):
                        self?.weatherData = data
                        self?.errorMessage = nil
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Location Error: \(error.localizedDescription)"
        }
    }
}
