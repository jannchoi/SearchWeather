//
//  BaseViewModel.swift
//  MovieLike
//
//  Created by 최정안 on 2/10/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform()
}
