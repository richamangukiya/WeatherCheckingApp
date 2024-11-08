//
//  WeatherCheckingDamoTests.swift
//  WeatherCheckingDamoTests
//
//  Created by Richa Mangukiya on 10/10/24.
//

import XCTest
@testable import WeatherCheckingDemo

final class WeatherCheckingDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Test case For Fetch Weather Data API Success
    func testFetchWeatherSuccess() {
        let mockService = WeatherService()
        let viewModel = WeatherViewModel(weatherService: mockService)
        let expectation = self.expectation(description: "Weather data fetched successfully")

        viewModel.fetchWeather(for: "Raleigh")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(viewModel.weatherData)
            XCTAssertNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    //MARK: - Test case For Fetch Weather Data API Failure
    func testFetchWeatherFailure() {
        let mockService = WeatherService()
        let viewModel = WeatherViewModel(weatherService: mockService)
        let expectation = self.expectation(description: "Error message set for invalid city")

        viewModel.fetchWeather(for: " ")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(viewModel.weatherData)
            XCTAssertNotNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    //MARK: - Test case for Weather model success
    func testWeatherDataDecoding() {
        let json = """
            {
                "name": "Raleigh",
                "main": {
                    "temp": 25.0
                },
                "weather": [{
                    "description": "Clear sky",
                    "icon": "01d"
                }]
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherModel.self, from: json)
            XCTAssertEqual(weatherData.name, "Raleigh")
            XCTAssertEqual(weatherData.main.temp, 25.0)
            XCTAssertEqual(weatherData.weather.first?.description, "Clear sky")
        } catch {
            XCTFail("Decoding failed: \(error)")
        }
    }

    //MARK: - Test case for Weather model failure
    func testWeatherDataDecodingFailure() {
        let invalidJson = """
            {
                "invalidKey": "Invalid data"
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(WeatherModel.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
