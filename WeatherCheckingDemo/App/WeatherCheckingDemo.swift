//
//  WeatherCheckingDemoApp.swift
//  WeatherCheckingDemo
//
//  Created by Richa Mangukiya on 10/10/24.
//

import SwiftUI

@main
struct WeatherCheckingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            ContentView(viewModel: viewModel)
        }
    }
}
