//
//  UILabel+.swift
//  MovieLike
//
//  Created by 최정안 on 1/26/25.
//

import UIKit

extension UILabel {
    func labelDesign(inputText: String, size: CGFloat, weight: UIFont.Weight = .regular, color: UIColor = .black, alignment: NSTextAlignment = .left , lines : Int = 0) {
        text = inputText
        font = UIFont.systemFont(ofSize: size, weight: weight)
        textColor = color
        textAlignment = alignment
        numberOfLines = lines
    }
//    func ColoringSubString(subString: String) {
//        let fullText = text ?? ""
//        let attributedString = NSMutableAttributedString(string: fullText)
//        let range = (fullText as NSString).range(of: subString)
//        attributedString.addAttribute(.foregroundColor, value: UIColor.MyBlue, range: range)
//        attributedText = attributedString
//    }
}

