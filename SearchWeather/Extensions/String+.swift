//
//  String+.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation
extension String {
    func getWeatherIconURL() -> URL?{
        let iconURL = "https://openweathermap.org/img/wn/\(self)@2x.png"
        let url = URL(string: iconURL)
        return url
    }
}
