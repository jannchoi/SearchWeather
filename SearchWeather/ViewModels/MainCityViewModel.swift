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
        var reloadDataTrigger: Observable<Void> = Observable(())
    }
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        var weatherImage: Observable<URL?> = Observable(nil)
        var selectedCity: Observable<City?> = Observable(nil)
        var selectedWeather: Observable<CurrentWeather?> = Observable(nil)
        var cityInfo = CityInfo.decode(fileName: "CityInfo")
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
            self.findCityInCityInfo(id: id)
        }
        internalData.weatherQeury.lazyBind { _ in
            self.getWeatherPhoto()
        }
        input.reloadDataTrigger.lazyBind {_ in
            self.getWeather([self.input.selectedCityID.value])
            self.findCityInCityInfo(id: self.input.selectedCityID.value)
        }
    }
    private func findCityInCityInfo(id: Int) {
        guard let cityinfo = output.cityInfo else {return}
        for city in cityinfo.cities {
            if id == city.id {
                output.selectedCity.value = city
                return
            }
        }
    }
    private func getWeather(_ input: [Int]) {
        NetworkManager.shared.callRequest(target: .getWeatherInfo(id: input),model: Weather.self) { response in
            switch response {
            case .success(let value) :
                self.output.selectedWeather.value = value.list.first
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
                self.output.weatherImage.value = URL(string: url)
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
            }
        }
    }
}
