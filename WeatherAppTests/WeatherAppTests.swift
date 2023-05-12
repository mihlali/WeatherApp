//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Mihlali Mazomba on 2023/05/06.
//

import XCTest
@testable import WeatherApp

final class WeatherAppTests: XCTestCase {
    
    private var viewModel: WeatherScreenViewModel!
    private var delegate: MockDelegate!
    private var mockInteractor: MockWeatherService!
    
    class MockDelegate: NSObject, WeatherScreenDelegate {
        
        func showErrorMessage(error: WeatherApp.FetchDataError) {
            didShowFailure = true
        }
        
        var didShowFailure = false
        var didRefreshView = false
        
        func refreshView() {
            didRefreshView = true
        }
    }
    
    override func setUp()  {
        super.setUp()
        mockInteractor = MockWeatherService()
        delegate = MockDelegate()
        viewModel = WeatherScreenViewModel(fetchDataInteractor: mockInteractor,
                                           delegate: delegate)
    }
    
    override func tearDown() {
        delegate = nil
        viewModel = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    
    func testServiceErrorFailure() {
        mockInteractor.result = .failure(.corruptData)
        viewModel.fetchCurrentWeatherData()
        XCTAssertTrue(delegate.didShowFailure)
    }
    
    func testServiceSucces(){
        let mockInteractor = MockWeatherService()
        mockInteractor.result = .success(currentDetail)
        viewModel = WeatherScreenViewModel(fetchDataInteractor: mockInteractor, delegate: delegate)
        viewModel.fetchCurrentWeatherData()
        XCTAssertTrue(delegate.didRefreshView)
    }
    
    var currentDetail : [CurrentWeather] {
        return [CurrentWeather(main: Temperature(
            currentTemperature: 20,
            minTemperature: 8,
            maxTemperature: 25,
            pressure: 8,
            humidity: 6),
                               weather: [Weather(id: 0, main: .clear, description: "Clear Kies", icon: "Clear")]),
                CurrentWeather(main: Temperature(
                    currentTemperature: 25,
                    minTemperature: 10,
                    maxTemperature: 36,
                    pressure: 5,
                    humidity: 7),
                               weather: [Weather(id: 2, main: .clouds, description: "Cloudy", icon: "Clouds")]),
        ]
    }
}
