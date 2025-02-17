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
//    
//    init(sys: Sys, description: String, main: WeatherMain, dt: Int, id: Int, name: String, windSpeed: Double, iconURL: URL? = nil) {
//        self.sys = sys
//        self.description = description
//        self.main = main
//        self.dt = dt
//        self.id = id
//        self.name = name
//        self.windSpeed = windSpeed
//        self.iconURL = iconURL
//    }
//    
//    mutating func currentWeatherToSelectedWeather(_ get: CurrentWeather){
//        name = get.name
//        description = get.weather[0].description
//        main = get.main
//        dt = get.dt
//        id = get.id
//        windSpeed = get.wind.speed
//        iconURL = get.weather[0].icon.getWeatherIconURL()
//    }
}
