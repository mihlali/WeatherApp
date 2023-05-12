//
//  MockWeatherService.swift
//  WeatherAppTests
//
//  Created by Mihlali Mazomba on 2023/05/11.
//

import Foundation



@testable import WeatherApp
import XCTest

final class MockWeatherService: WeatherDataProtocol {
    
    var result: Result<[Any], FetchDataError>?
    
    func fetchWeatherInformation<T: Codable>(
        formUrl url: String,
        completion: @escaping (Result<T, FetchDataError>) -> Void){
            
        guard let result = result as? Result<T, FetchDataError> else {
            completion(.failure(.somethingIsWrongError))
            return
        }
        completion(result)
    }
}
