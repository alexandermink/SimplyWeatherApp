//
//  WeatherCellView.swift
//  WeatherTest
//
//  Created by Александр Минк on 30.05.2025.
//

import SwiftUI
import Kingfisher

struct WeatherCellView: View {
    
    // MARK: - Properties
    
    let day: ForecastDay

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            KFImage(URL(string: "https:\(day.day.condition.image)"))
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(day.date.toFormattedDateString())
                    .font(.headline)

                HStack {
                    Label("\(day.day.temperature, specifier: "%.1f")°C", systemImage: "thermometer")
                    Spacer()
                    Label("\(day.day.maxWind, specifier: "%.1f") км/ч", systemImage: "wind")
                }
                .font(.subheadline)

                HStack {
                    Label("\(day.day.humidity, specifier: "%.0f")%", systemImage: "humidity")
                    Spacer()
                    Text(day.day.condition.text)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    WeatherCellView(day: ForecastDay(date: "08.12.2025", day: Day(temperature: 2.2, maxWind: 2.2, humidity: 2.2, condition: Condition(text: "String", image: "Image"))))
}
