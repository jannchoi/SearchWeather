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
        var selectedCityWeather: Observable<CityWeather?> = Observable(nil)
    }
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        var weatherImage: Observable<URL?> = Observable(nil)
        var outputWeather: Observable<CityWeather?> = Observable(nil)
        var cityInfo = CityInfo.decode(fileName: "CityInfo")
        
    }
    private struct InternalData {
        var weatherQeury: Observable<String> = Observable("")
        
        var weatherInfo : Observable<CurrentWeather?> = Observable(nil)
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
        input.reloadDataTrigger.lazyBind {_ in
            self.getWeather([UserDefaultsManager.cityID])
        }
        internalData.weatherInfo.lazyBind { _ in
            self.mappingCityWeather()
        }
        input.selectedCityWeather.lazyBind { cityWeather in
            guard let cityWeather else {return}
            self.output.outputWeather.value = cityWeather
            UserDefaultsManager.cityID = cityWeather.cityId
        }
        
    }
    private func mappingCityWeather() {
        guard let weatherInfo = internalData.weatherInfo.value, let cityList = output.cityInfo?.cities else {return}
        
        for city in cityList {
            if weatherInfo.id == city.id {
                output.outputWeather.value = CityWeather(cityName: city.city, koCityName: city.koCityName, countryName: city.country, koCountryName: city.koCountryName, cityId: city.id, temp: weatherInfo.main.temp, tempMin: weatherInfo.main.temp_min, tempMax: weatherInfo.main.temp_max, description: weatherInfo.weather[0].description, icon: weatherInfo.weather[0].icon, windSpeed: weatherInfo.wind.speed, sunrise: weatherInfo.sys.sunrise, sunset: weatherInfo.sys.sunset, dateTime: weatherInfo.dt, feels: weatherInfo.main.feels_like, humidity: weatherInfo.main.humidity)
            }
        }
    }
    private func getWeather(_ input: [Int]) {
        NetworkManager.shared.callRequest(target: .getWeatherInfo(id: input),model: Weather.self) { response in
            switch response {
            case .success(let value) :
                self.internalData.weatherInfo.value = value.list.first
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
                if let photo = value.results.first, let url = photo.urls.thumb {
                    self.output.weatherImage.value = URL(string: url)
                }else {
                    self.output.weatherImage.value = nil
                }
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
            }
        }
    }
}
