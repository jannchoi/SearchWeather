//
//  Weather.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation
struct Weather: Decodable {
    let list: [CurrentWeather]
}
struct CurrentWeather: Decodable {
    let sys: Sys
    let weather: [WeatherDetail]
    let main: WeatherMain
    let wind : Wind
    
}
struct WeatherDetail: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct Sys:Decodable {
    let sunrise: Int
    let sunset: Int
}

struct WeatherMain: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
    let dt: Int
    let id: Int
    let name: String
}

struct Wind: Decodable {
    let speed : Double
}
