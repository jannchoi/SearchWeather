//
//  NetworkManager.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
    case getWeatherInfo(id: [Int])
    case getWeatherPhoto(query: String)
    case getForecast(id: Int)
    var baseURL: URL {
        switch self {
        case .getWeatherInfo :
            return URL(string: "https://api.openweathermap.org/data/2.5/group")!
        case .getWeatherPhoto :
            return URL(string: "https://api.unsplash.com/search/photos")!
        case .getForecast :
            return URL(string: "api.openweathermap.org/data/2.5/forecast")!
        }
    }
    var method: HTTPMethod {
        return .get
    }
    var header: HTTPHeaders {
        switch self {
        case .getWeatherInfo, .getForecast:
            return ["Content-Type": "application/json"]
        case .getWeatherPhoto:
            return ["Authorization": "Client-ID \(APIKey.photoKey)"]
            
        }

    }
    var path: String {
        switch self {
        case .getWeatherInfo, .getForecast, .getWeatherPhoto :
            return ""
        }
    }
    var parameters: Parameters {
        switch self {
        case .getWeatherInfo(let id):
            let idString = id.map { String($0) }.joined(separator: ",")
            return [
                "id": idString,
                "appid": APIKey.weatherKey,
                "lang": "kr",
                "units": "metric"
            ]
        case .getWeatherPhoto(let query):
            return [
                "query": query,
                "page": 1,
                "per_page": 1
            ]
        case .getForecast(let id) :
            return [
                "id": String(id),
                "appid": APIKey.weatherKey,
                "lang": "kr",
            ]
        }
    }
    func asURLRequest() throws -> URLRequest {
        var urlString = baseURL.absoluteString
        urlString += path
        var request = URLRequest(url: URL(string: urlString)!)
        request.method = method
        request.headers = header
        let urlRequest = try URLEncoding.default.encode(request, with: parameters)
        return urlRequest
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func callRequest<T:Decodable>(target: NetworkRouter,model: T.Type,completionHandler: @escaping (Result<T,Error>) -> Void) {
        AF.request(target)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error) :
                    let code = response.response?.statusCode
                    completionHandler(.failure(self.getErrorMessage(code: code ?? 500)))
                    print(T.self, error)
                }
        }
    }
    // 0 8 16 24 32 40
    private func getErrorMessage(code: Int) -> NetworkError {
        switch code {
        case 400 : return .badRequest
        case 401 : return .unauthorized
        case 403 : return .forbidden
        case 404 : return .notFound
        default : return .serverError
        }
    }
}
