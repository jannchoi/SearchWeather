//
//  Int+.swift
//  SearchWeather
//
//  Created by 최정안 on 2/15/25.
//

import Foundation
extension Int {
    func dateFormat() -> String {
        let timestamp: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "  M월 d일(EE) a h시 m분"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func formatTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시 m분"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: date)
    }
}
