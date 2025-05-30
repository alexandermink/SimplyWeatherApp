//
//  WeatherViewModel.swift
//  WeatherTest
//
//  Created by Александр Минк on 29.05.2025.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var forecastDays: [ForecastDay] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let weatherAPI = WeatherAPI(alamofireService: AlamofireService.shared)
    
    
    // MARK: - Public methods

    func fetchWeather(for city: String) {
        isLoading = true
        errorMessage = nil
        forecastDays = []

        weatherAPI.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let forecast):
                    self?.forecastDays = forecast.forecast.forecastDay
                case .failure(let error):
                    self?.errorMessage = error.title
                }
            }
        }
    }
}
