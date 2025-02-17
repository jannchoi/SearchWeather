//
//  SelectedWeatherInfo.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation

struct SelectedWeatherInfo {
    var sys: Sys
    var description : String
    var main: WeatherMain
    var dt: Int
    var id: Int
    var name: String
    var windSpeed: Double
    var iconURL: URL?

}
