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
        var selectedCityInfo = Observable(SelectedWeatherInfo.init(sys: Sys.init(sunrise: 0, sunset: 0), description: "", main: WeatherMain.init(temp: 0, feels_like: 0, temp_min: 0, temp_max: 0, humidity: 0), dt: 0, id: 0, name: "", windSpeed: 0, iconURL: nil)
        )
    }
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        
        var weatherImage: Observable<URL?> = Observable(nil)
        var selectedCity: Observable<City?> = Observable(nil)
    }
    private struct InternalData {
        var weatherInfo: Observable<CurrentWeather?> = Observable(nil)
        var weatherQeury: Observable<String> = Observable("")
        var cityInfo = CityInfo.decode(fileName: "CityInfo")
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
        guard let cityinfo = internalData.cityInfo else {return}
        for city in cityinfo.cities {
            if id == city.id {
                output.selectedCity.value = city
            }
        }
    }
    private func getWeather(_ input: [Int]) {
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.callRequest(target: .getWeatherInfo(id: input),model: Weather.self) { response in
            switch response {
            case .success(let value) :
                self.internalData.weatherInfo.value = value.list.first
                self.internalData.weatherQeury.value = value.list.description
                group.leave()
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            guard let receivedData = self.internalData.weatherInfo.value else {return}
            self.currentWeatherToSelectedWeather(receivedData)
            print(self.input.selectedCityInfo.value)
        }

    }
    private func currentWeatherToSelectedWeather(_ get: CurrentWeather) {        input.selectedCityInfo.value.name = get.name
        input.selectedCityInfo.value.description = get.weather[0].description
        input.selectedCityInfo.value.main = get.main
        input.selectedCityInfo.value.dt = get.dt
        input.selectedCityInfo.value.id = get.id
        input.selectedCityInfo.value.windSpeed = get.wind.speed
        input.selectedCityInfo.value.iconURL = get.weather[0].icon.getWeatherIconURL()
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
