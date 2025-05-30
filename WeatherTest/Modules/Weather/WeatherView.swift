//
//  WeatherView.swift
//  WeatherTest
//
//  Created by Александр Минк on 29.05.2025.
//

import SwiftUI
import Kingfisher

struct WeatherView: View {
    
    // MARK: - Locals
    
    private enum Locals {
        static let navigationTitle = "Прогноз погоды"
        static let textFieldPlaceholder = "Введите город"
        static let progressViewText = "Загрузка..."
    }
    
    
    // MARK: - Properties
    
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = "Москва"

    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 16) {
                
                // Поиск города
                HStack {
                    TextField(Locals.textFieldPlaceholder, text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)

                    Button(action: {
                        viewModel.fetchWeather(for: city)
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .disabled(city.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding([.horizontal, .top])

                // Загрузка
                if viewModel.isLoading {
                    ProgressView(Locals.progressViewText)
                        .padding()
                }

                // Ошибка
                if let errorMessage = viewModel.errorMessage {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.orange)
                            .imageScale(.medium)

                        Text("Ошибка: \(errorMessage)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .transition(.opacity)
                }

                // Прогноз
                if !viewModel.forecastDays.isEmpty {
                    List(viewModel.forecastDays, id: \.date) { day in
                        WeatherCellView(day: day)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .navigationTitle(Locals.navigationTitle)
            .onAppear {
                viewModel.fetchWeather(for: city)
            }
        }
    }
}

#Preview {
    WeatherView()
}
