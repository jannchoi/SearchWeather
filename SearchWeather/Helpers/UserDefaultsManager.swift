//
//  UserDefaultsManager.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation

@propertyWrapper struct MyDefaults<T> {
    let key: String
    let empty: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? empty
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
@propertyWrapper struct MyJSONDefaults<T: Codable> {
    let key: String
    let empty: T
    var wrappedValue: T {
        get {
            let savedData = UserDefaults.standard.data(forKey: key) ?? Data()
            let data = try? JSONDecoder().decode(T.self, from: savedData)
            return data ?? empty
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

enum UserDefaultsManager {
    enum Key: String {
        case cityID
        case city
    }
    @MyDefaults(key: Key.cityID.rawValue, empty: 1835848)// default: Seoul
    static var cityID
    @MyJSONDefaults(key: Key.city.rawValue, empty: SelectedCity(id: 1835848, koCity: "서울", koCountry: "대한민국"))
    static var city
}

struct SelectedCity: Codable {
    var id: Int
    var koCity: String
    var koCountry: String
}
