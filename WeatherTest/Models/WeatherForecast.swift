//
//  WeatherForecast.swift
//  WeatherTest
//
//  Created by Александр Минк on 29.05.2025.
//

import Foundation

struct WeatherForecast: Decodable {
    let forecast: Forecast
}

struct Forecast: Decodable {
    let forecastDay: [ForecastDay]

    enum CodingKeys: String, CodingKey {
        case forecastDay = "forecastday"
    }
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
}

struct Day: Decodable {
    let temperature: Double
    let maxWind: Double
    let humidity: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case temperature = "avgtemp_c"
        case maxWind = "maxwind_kph"
        case humidity = "avghumidity"
        case condition
    }
}

struct Condition: Decodable {
    let text: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case text
        case image = "icon"
    }
}

