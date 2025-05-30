//
//  String.swift
//  WeatherTest
//
//  Created by Александр Минк on 30.05.2025.
//

import Foundation

extension String {
    
    func toFormattedDateString(
        inputFormat: String = "yyyy-MM-dd",
        outputFormat: String = "d MMMM (EEEE)",
        locale: Locale = Locale(identifier: "ru_RU")
    ) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = locale
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = locale
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
}
