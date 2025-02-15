//
//  CityInfo.swift
//  SearchWeather
//
//  Created by 최정안 on 2/15/25.
//

import Foundation

struct CityInfo: Decodable {
    let cities: [City]
    
    static func decode(fileName: String) -> CityInfo? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                    print("no matching file : \(fileName).json")
                    return nil
                }
        
        do {
            let data = try Data(contentsOf: url)
            let cityInfo = try JSONDecoder().decode(CityInfo.self, from: data)
            return cityInfo
        } catch {
            print("decoding error")
            return nil
        }
    }
}
struct City: Decodable {
    let city: String
    let koCityName: String
    let country: String
    let koCountryName: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case city
        case koCityName = "ko_city_name"
        case country
        case koCountryName = "ko_country_name"
        case id
    }
}
