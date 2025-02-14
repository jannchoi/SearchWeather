//
//  SelectedWeatherInfo.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation

struct SelectedWeatherInfo {
    let sys: Sys
    let weatherDetail : WeatherDetail
    let main: WeatherMain
    let windSpeed: Double
    let url: String
}
