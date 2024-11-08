//
//  OpenWeatherServices.swift
//  WeatherCheckingDemo
//
//  Created by Richa Mangukiya on 10/10/24.
//

import Foundation

class WeatherService: WeatherServiceProtocol {
    
    //MARK: - Variables
    private let apiKey = "61a47720854efca46d8fd660f2f91af1"
    
    //MARK: - Fetch Weather By CITY API Call
    func fetchWeather(city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 400, userInfo: nil)))
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    //MARK: - Fetch Weather Data By Lat, Long
    func fetchWeatherByCoordinates(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 400, userInfo: nil)))
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
