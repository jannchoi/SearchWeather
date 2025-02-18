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
        var getForecast: Observable<Void> = Observable(())
    }
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        var outputWeather: Observable<CityWeather?> = Observable(nil)
        var cityInfo = CityInfo.decode(fileName: "CityInfo")
        var weatherForecast = Observable([CityWeather]())
        
    }
    private struct InternalData {
        var weatherQeury : String? = ""
        var weatherImage : URL? = nil
        var weatherInfo : CurrentWeather? = nil
    }
    
    init() {
        input = Input()
        output = Output()
        internalData = InternalData()
        transform()
    }
    func transform() { // getweather -> getphoto -> mapping 순서로 진행
        
        input.selectedCityID.bind { [weak self] id in //초기 진입시
            self?.getWeather([id])
        }
        input.reloadDataTrigger.lazyBind { _ in // 새로고침
            self.getWeather([self.input.selectedCityID.value])
        }
        input.selectedCityWeather.lazyBind { [weak self] cityWeather in //searchview에서 선택된 도시를 받아왔을 때
            guard let cityWeather else {return}
            self?.output.outputWeather.value = cityWeather
            self?.input.selectedCityID.value = UserDefaultsManager.cityID
            UserDefaultsManager.cityID = cityWeather.cityId
        }
        
//        input.getForecast.lazyBind { _ in
//            self.getForecast(UserDefaultsManager.cityID)
//        }
        
        
    }
//    private func getForecast(_ input: Int) {
//        let group = DispatchGroup()
//        group.enter()
//        NetworkManager.shared.callRequest(target: .getForecast(id: input),model: Weather.self) { response in
//            switch response {
//            case .success(let value) :
//                self.internalData.weatherInfo = value.list.first
//                self.internalData.weatherQeury = value.list.description
//                group.leave()
//            case .failure(let failure) :
//                if let errorType = failure as? NetworkError {
//                    self.output.errorMessage.value = errorType.errorMessage
//                }
//                group.leave()
//            }
//        }
//        group.notify(queue: .main) {
//            self.getWeatherPhoto()
//        }
//    }
    
    
    private func getWeather(_ input: [Int]) { //날씨 데이터
        let group = DispatchGroup()
        group.enter()
        NetworkManager.shared.callRequest(target: .getWeatherInfo(id: input),model: Weather.self) { response in
            switch response {
            case .success(let value) :
                self.internalData.weatherInfo = value.list.first //하나의 날씨만 보여줄 거니까 
                self.internalData.weatherQeury = value.list.first?.weather.first?.main
                group.leave()
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.getWeatherPhoto()
        }
    }
    private func getWeatherPhoto() { // 날씨에 대한 사진 
        let group = DispatchGroup()
        group.enter()
        
        var weather = "sunny"
        if internalData.weatherQeury != nil {
            weather = internalData.weatherQeury!
        }
        NetworkManager.shared.callRequest(target: .getWeatherPhoto(query: weather),model: Photo.self) { response in
            switch response {
            case .success(let value) :
                if let photo = value.results.first, let url = photo.urls.thumb {
                    self.internalData.weatherImage = URL(string: url)
                }else {
                    self.internalData.weatherImage = nil
                }
                group.leave()
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
                group.leave()
            }

            group.notify(queue: .main) {
                self.mappingCityWeather()
            }

        }
    }
    private func mappingCityWeather() { // 서버에서 얻은 데이터와 cityinfo데이터를 cityweather로 매핑
        guard let weatherInfo = internalData.weatherInfo, let cityList = output.cityInfo?.cities else {return}
        
        for city in cityList {
            if weatherInfo.id == city.id {
                output.outputWeather.value = CityWeather(cityName: city.city, koCityName: city.koCityName, countryName: city.country, koCountryName: city.koCountryName, cityId: city.id, temp: weatherInfo.main.temp, tempMin: weatherInfo.main.temp_min, tempMax: weatherInfo.main.temp_max, description: weatherInfo.weather[0].description, icon: weatherInfo.weather[0].icon, windSpeed: weatherInfo.wind.speed, sunrise: weatherInfo.sys.sunrise, sunset: weatherInfo.sys.sunset, dateTime: weatherInfo.dt, feels: weatherInfo.main.feels_like, humidity: weatherInfo.main.humidity, weatherImage: internalData.weatherImage)
                return
            }
        }
    }
}
