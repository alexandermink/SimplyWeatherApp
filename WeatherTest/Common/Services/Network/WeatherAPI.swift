//
//  WeatherAPI.swift
//  WeatherTest
//
//  Created by Александр Минк on 29.05.2025.
//

import Alamofire

final class WeatherAPI {
    
    // MARK: - Locals
    
    private enum Locals {
        static let url = "https://api.weatherapi.com/v1/forecast.json"
        static let apiKey = "6767c22cd2114801b0790813252505"
        static let lang = "ru"
    }
    
    
    // MARK: - Properties
    
    private let alamofireService: AlamofireServiceInput
    
    
    // MARK: - Init
    
    init(alamofireService: AlamofireServiceInput) {
        self.alamofireService = alamofireService
    }
    
    
    // MARK: - Public methods

    func fetchWeather(for city: String, days: Int = 5, completion: @escaping (Result<WeatherForecast, NetworkError>) -> Void) {
        
        let parameters: Parameters = [
            "key": Locals.apiKey,
            "q": city,
            "days": days,
            "lang": Locals.lang
        ]

        alamofireService.request(url: Locals.url, method: .get, parameters: parameters, headers: nil, disableCertificateCheck: false) { result in
             
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    completion(.success(decoded))
                } catch {
                    if let apiError = try? JSONDecoder().decode(WeatherAPIErrorResponse.self, from: data) {
                        if apiError.error.code == 1006 {
                            completion(.failure(.cityNotFound))
                        }
                    } else {
                        completion(.failure(.decodingFailure))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
