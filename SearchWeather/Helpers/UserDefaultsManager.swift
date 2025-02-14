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

enum UserDefaultsManager {
    enum Key: String {
        case cityID
    }
    @MyDefaults(key: Key.cityID.rawValue, empty: 1835848)// default: Seoul
    static var cityID
}
