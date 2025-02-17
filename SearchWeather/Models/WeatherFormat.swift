//
//  WeatherFormat.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation
import UIKit

struct WeatherFormat {
    
    static let location = "  %@,%@  "
    static let description = "  오늘의 날씨는 %@입니다.  "
    static let temp = "  현재 온도는 %.1f°입니다. 최저 %.1f° 최고 %.1f°  "
    static let tempMinMax = "최저 %.1f° 최고 %.1f°"
    static let feelsList = "  체감 온도는 %.1f°입니다.  "
    static let sunriseSunset = "  %@의 일출 시각은 %@, 일몰 시각은 %@입니다.  "
    static let humidityWind = "  습도는 %.1f%, 풍속은 %.1f m/s입니다.  "
    
    
    static func attributedSubstring(text: String, arguments: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        for target in arguments {
            let range = (text as NSString).range(of: target)
            let bold = UIFont.boldSystemFont(ofSize: 14)
            attributedString.addAttribute(.font, value: bold, range: range)
        }
        
        return attributedString
    }
    
    static func attributToDoubleString(text: String, boldTarget: [Double], grayTarget: [Double]?, temp: Bool = false) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        for target in boldTarget {
            let argument = String(format:" %.1f", target)
            let range = (text as NSString).range(of: argument)
            let bold = UIFont.boldSystemFont(ofSize: 14)
            if temp {
                if target >= 30 {
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: range)
                } else if target < 0{
                    attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
                }
            }
            attributedString.addAttribute(.font, value: bold, range: range)
        }
        
        if let grayTarget = grayTarget {
            for targetIdx in grayTarget.indices {
                var tempText: String
                if targetIdx == 0 {
                    tempText = String(format: "최저 %.1f°", grayTarget[targetIdx])
                } else {
                    tempText = String(format: "최고 %.1f°", grayTarget[targetIdx])
                }
                let range = (text as NSString).range(of: tempText)
                if range.location != NSNotFound {
                    attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: range)
                    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12) as Any, range: range)
                } else {
                    print("text not found: \(tempText)")
                }
            }
        }
        return attributedString
    }
}
