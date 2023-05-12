//
//  Weather.swift
//  WeatherApp
//
//  Created by Mihlali Mazomba on 2023/05/07.
//

//* generated using quickType */

import Foundation

// MARK: - Current Weather
struct CurrentWeather: Codable {
    let main: Temperature
    let weather: [Weather]
}

// MARK: - Main
struct Temperature: Codable {
    let currentTemperature: Double
    let minTemperature, maxTemperature: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: WeatherTypes
    let description, icon: String
}
