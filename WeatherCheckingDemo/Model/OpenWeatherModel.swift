//
//  OpenWeatherModel.swift
//  WeatherCheckingDemo
//
//  Created by Richa Mangukiya on 10/10/24.
//

import Foundation

//MARK:- Weather data model
struct WeatherModel: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
