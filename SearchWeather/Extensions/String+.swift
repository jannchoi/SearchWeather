//
//  String+.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation
extension String {
    func dateFormat(inputDate: Int) -> String {
        let timestamp: TimeInterval = TimeInterval(inputDate)
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일(EE) a h시 m분"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func formatTime(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시 m분"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: date)
    }
}
