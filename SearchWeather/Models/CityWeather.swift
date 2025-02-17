//
//  CityWeather.swift
//  SearchWeather
//
//  Created by 최정안 on 2/16/25.
//

import Foundation

struct CityWeather {
    let cityName: String
    let koCityName: String
    let countryName: String
    let koCountryName: String
    let cityId: Int
    
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let description: String
    let icon: String
    let windSpeed: Double
    let sunrise: Int
    let sunset: Int
    let dateTime: Int
    let feels: Double
    let humidity: Double
    var weatherImage: URL?
}

