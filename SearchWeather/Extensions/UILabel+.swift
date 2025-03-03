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
}

