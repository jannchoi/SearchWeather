//
//  MainCityViewModel.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation


final class MainCityViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    private var internalData: InternalData
    
    
    
    struct Input {
        var selectedCityID: Observable<Int> = Observable(UserDefaultsManager.cityID)
    }
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        var weatherInfo: Observable<CurrentWeather?> = Observable(nil)
        var weatherImage: Observable<String> = Observable("")
    }
    private struct InternalData {
        var weatherQeury: Observable<String> = Observable("")
    }
    
    init() {
        input = Input()
        output = Output()
        internalData = InternalData()
        transform()
    }
    func transform() {
        input.selectedCityID.bind { id in
            self.getWeather([id])
        }
        internalData.weatherQeury.lazyBind { _ in
            self.getWeatherPhoto()
        }
    }
    private func getWeather(_ input: [Int]) {
        NetworkManager.shared.callRequest(target: .getWeatherInfo(id: input),model: Weather.self) { response in
            switch response {
            case .success(let value) :
                self.output.weatherInfo.value = value.list.first
                self.internalData.weatherQeury.value = value.list.description
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
            }
        }
    }
    private func getWeatherPhoto() {
        NetworkManager.shared.callRequest(target: .getWeatherPhoto(query: internalData.weatherQeury.value),model: Photo.self) { response in
            switch response {
            case .success(let value) :
                guard let url = value.results[0].urls.thumb else {return}
                self.output.weatherImage.value = url
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
            }
        }
        
        
    }
}
