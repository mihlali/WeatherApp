//
//  WeatherScreenViewModel.swift
//  WeatherApp
//
//  Created by Mihlali Mazomba on 2023/05/07.
//

import Foundation
import MapKit
import SwiftUI

enum WeatherTypes: String, Codable {
   case rain = "Rain"
   case snow = "Snow"
   case clouds = "Clouds"
   case clear = "Clear"
}

struct WeatherData {
    var backGroundImage: String?
    var backgroundColor: Color?
    var tempDescription: String?
    var currentTemperatureValue: Double?
    var daysTemperature: [TempModel]?
    var weeksTemperature: [TemperatureModel]?
}

protocol WeatherScreenDelegate: NSObjectProtocol {
    func refreshView()
    func showErrorMessage(error: FetchDataError)
}

class WeatherScreenViewModel {

    var currentLocation: CLLocation?
    
    private var group = DispatchGroup()
    
    private var fetchDataInteractor: WeatherDataProtocol
    private let key = "2150688755405b96a128b33adac5629e"
    private weak var delegate: WeatherScreenDelegate?
    private(set) var fetchDataError: FetchDataError?
    private(set) var weatherData = WeatherData()
    
    init(fetchDataInteractor : WeatherDataProtocol,
         delegate: WeatherScreenDelegate) {
        self.delegate = delegate
        self.fetchDataInteractor = fetchDataInteractor
    }

    var currentTemperaturString: String {
        return "\(weatherData.currentTemperatureValue?.convertKelvinToCelsius() ?? "")°"
    }
    
    var weatherDescription: String {
        return weatherData.tempDescription ?? ""
    }
    
    var weatherBackGroundColor: Color {
        return weatherData.backgroundColor ?? .weatherColor.sunny
    }
    
    var weatherDaysSummary: [TempModel] {
        return weatherData.daysTemperature ?? [TempModel]()
    }

    var weeksTemperature: [TemperatureModel] {
        return weatherData.weeksTemperature ?? [TemperatureModel]()
    }
    
    func fetchCurrentWeatherData() {
        fetchDataInteractor
            .fetchWeatherInformation(
                formUrl: currentWeatherURL) { [weak self]
                    (result: Result<CurrentWeather, FetchDataError>) in
                    switch result {
                    case .failure(let error):
                        self?.delegate?.showErrorMessage(error: error)
                    case .success(let response):
                        self?.updateWeatherInformation(with: response)
                        self?.fetchWeeksWeatherForCast()
                    }
                }
    }
    
    func fetchWeeksWeatherForCast() {
        fetchDataInteractor
            .fetchWeatherInformation(
                formUrl: foreCastWeatherURL) {[weak self]
                    (result: Result<ForeCastWeatherModel, FetchDataError>) in
                    switch result {
                    case .success(let response):
                        self?.updateWeeksTemperatures(with: response.list)
                        DispatchQueue.main.async {
                            self?.delegate?.refreshView()
                        }
                    case .failure( let error):
                        self?.delegate?.showErrorMessage(error: error)
                    }
                }
    }
    
    private var coordinate: CLLocationCoordinate2D {
        guard let currentLocation = currentLocation else {
            return CLLocationCoordinate2D()
            
        }
        return currentLocation.coordinate
    }
    
    private func updateWeatherInformation(with currentDayDetails: CurrentWeather) {
        let currentWeather = currentDayDetails.weather.first
        let weatherType = currentWeather?.main
        weatherData.tempDescription = currentWeather?.description
        weatherData.daysTemperature = configure(temp: currentDayDetails.main)
        weatherData.currentTemperatureValue = currentDayDetails.main.currentTemperature
        
        switch weatherType {
        case .clear:
            weatherData.backGroundImage = "sea_sunny"
            weatherData.backgroundColor = Color.weatherColor.sunny
        case .rain, .snow:
            weatherData.backGroundImage = "sea_rainy"
            weatherData.backgroundColor = Color.weatherColor.rainy
        case .clouds:
            weatherData.backGroundImage = "sea_cloudy"
            weatherData.backgroundColor = Color.weatherColor.cloudy
        case .none:
            break
        }
    }
    
    private func updateWeeksTemperatures(with weatherList: [CurrentWeather]) {
        var list = [TemperatureModel]()
        
        for index in 0..<4 {
            let day = weatherList[index]
            let weatherType = day.weather.first?.main ?? .clear
            
            list.append(TemperatureModel(weatherDay: weekDays[index],
                         image: icon(for: weatherType),
                                         Temperature: day.main.currentTemperature.convertKelvinToCelsius()))
        }
        weatherData.weeksTemperature = list
    }
    
    private func configure(temp: Temperature) -> [TempModel] {
        
        return [TempModel(title: temp.minTemperature.convertKelvinToCelsius(), subTitle: "min"),
                TempModel(title: temp.currentTemperature.convertKelvinToCelsius(), subTitle: "Current"),
                TempModel(title: temp.maxTemperature.convertKelvinToCelsius(), subTitle: "max")]
    }
    
    private var weekDays: [String] {
        return ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday" , "Saturday"]
    }
    
    private func icon(for weather: WeatherTypes) ->  String {
        switch weather {
        case .clouds:
            return "partlysunny"
        case .snow, .rain:
         return "rain"
        case .clear:
            return "clear"
        }
    }
    
    private var currentWeatherURL: String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(key)"
    }
    
    private var foreCastWeatherURL: String {
        return "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(key)"
    }
}

extension Double {
      func convertKelvinToCelsius() -> String {
        let newTempInCelsius = (self - 273.15).rounded()
        let value = String(format: "%g", newTempInCelsius)
        return "\(value)"
    }
}
