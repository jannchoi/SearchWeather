//
//  NetworkError.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    
    var errorMessage : String {
        switch self {
        case .badRequest : return "The request was unacceptable"
        case .unauthorized : return "Invalid Access Token"
        case .forbidden : return "Missing permissions to perform request"
        case .notFound : return "The requested resource doesn’t exist"
        case .serverError : return "Server Error"
        }
    }
    
}
