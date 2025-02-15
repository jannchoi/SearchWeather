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
    let dt: Int
    let id: Int
    let name: String
    
    
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
    
    init(sunrise: Int, sunset: Int) {
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

struct WeatherMain: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
    
    init(temp: Double, feels_like: Double, temp_min: Double, temp_max: Double, humidity: Double) {
        self.temp = temp
        self.feels_like = feels_like
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.humidity = humidity
    }

}

struct Wind: Decodable {
    let speed : Double
}
