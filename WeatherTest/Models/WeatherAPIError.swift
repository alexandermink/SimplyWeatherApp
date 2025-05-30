//
//  WeatherAPIError.swift
//  WeatherTest
//
//  Created by Александр Минк on 30.05.2025.
//

import Foundation

struct WeatherAPIErrorResponse: Decodable {
    let error: WeatherAPIError
}

struct WeatherAPIError: Decodable {
    let code: Int
    let message: String
}
