//
//  WeatherFormat.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation
import UIKit

struct WeatherFormat {
    static let description = "오늘의 날씨는 %@입니다."
    static let temp = "현재 온도는 %.1f입니다. 최저 %.1f 최고 %.1f"
    static let feelsList = "체감 온도는 %.1f입니다."
    static let sunriseSunset = "%@의 일출 시각은 %@, 일몰 시각은 %@입니다."
    static let humidityWind = "습도는 %.1f이고, 풍속은 %.1f m/s입니다."
    
    
    static func attributedSubstring(text: String, argument: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: argument)
        let bold = UIFont.boldSystemFont(ofSize: 14)
        attributedString.addAttribute(.font, value: bold, range: range)
        return attributedString
    }
    
    static func attributToDoubleString(text: String, boldTarget: [Double], grayTarget: [String]?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        for target in boldTarget {
            let argument = String(format:" %.1f", target)
            let range = (text as NSString).range(of: argument)
            let bold = UIFont.boldSystemFont(ofSize: 14)
            attributedString.addAttribute(.font, value: bold, range: range)
        }
        
        if let grayTarget {
            for target in grayTarget {
                let range = (text as NSString).range(of: "\(target)")
                attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: range)
            }
        }


        return attributedString
    }
}
