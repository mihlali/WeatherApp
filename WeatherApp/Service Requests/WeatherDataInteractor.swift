//
//  WeatherDataInteractor.swift
//  WeatherApp
//
//  Created by Mihlali Mazomba on 2023/05/06.
//

import Foundation

enum FetchDataError: Error {
    case badURL
    case corruptData
    case decodingError
    case somethingIsWrongError
}

protocol WeatherDataProtocol {
    func fetchWeatherInformation<T: Codable>(
        formUrl url: String,
        completion: @escaping (_ result: Result<T, FetchDataError>) -> Void)
}

class WeatherDataInteractor: WeatherDataProtocol {
    
    func fetchWeatherInformation<T: Codable>(
        formUrl url: String,
        completion: @escaping (Result<T, FetchDataError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(FetchDataError.badURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
            
        URLSession.shared.dataTask(
            with: urlRequest) { data, response, error in
                
                guard error == nil else {
                    completion(.failure(FetchDataError.decodingError))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(FetchDataError.corruptData))
                    return
                }
                
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode(T.self, from: data) else {
                    completion(.failure(FetchDataError.decodingError))
                    return
                }
                
                completion(.success(decodedData))
            }.resume()
    }
}
