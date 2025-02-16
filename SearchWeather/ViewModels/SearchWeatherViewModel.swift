//
//  SearchWeatherViewModel.swift
//  SearchWeather
//
//  Created by 최정안 on 2/15/25.
//

import Foundation

struct SearchWeatherViewModel: BaseViewModel {
    private(set) var input: Input
    private(set) var output: Output
    private var internalData: InternalData

    struct Input {
        var reloadDataTrigger: Observable<Void> = Observable(())
        var selectedCityInfo: Observable<SelectedWeatherInfo?> = Observable(nil)
        var searchedTerm: Observable<String?> = Observable(nil)
        var totalCityInfo : Observable<CityInfo?> = Observable(nil)
        
    }
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        var cityWeatherInfo = Observable([CityWeather]())
        var showEmptyLabel = Observable(false)
    }
    private struct InternalData {
        var cityIdList = Observable([Int]())
        var weatherInfo = Observable([CurrentWeather]())
    }
    
    init() {
        input = Input()
        output = Output()
        internalData = InternalData()
        transform()
    }
    func transform() {
        input.totalCityInfo.lazyBind { cityinfo in
            guard cityinfo != nil else {return}
            getIdList(nil)
        }
        
        input.searchedTerm.lazyBind { text in
            guard let text else {return}
            var inputText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            inputText = inputText.lowercased()
            getIdList(inputText)
        }
        internalData.weatherInfo.bind { _ in
            self.mappingCityWeather()
        }
    }
    
    private func getIdList(_ inputText: String?) {
        internalData.weatherInfo.value.removeAll()
        guard let cityInfo = input.totalCityInfo.value else {return}
        
        if let inputText, inputText != "" {
            var idList = [Int]()
            for i in cityInfo.cities{
                if i.city.lowercased().contains(inputText) || i.koCityName.contains(inputText) || i.country.lowercased().contains(inputText) ||
                    i.koCountryName.contains(inputText) {
                    idList.append(i.id)
                }
            }
            internalData.cityIdList.value = idList
            if idList.isEmpty {
                output.showEmptyLabel.value = true
                return
            }
        } else {
            internalData.cityIdList.value = cityInfo.cities.map{$0.id}
        }
        output.showEmptyLabel.value = false
        getQueryID()
    }
    private func getQueryID() {

        let cityCount = internalData.cityIdList.value.count
        let loopCount = (cityCount / 20)
        for i in 0...loopCount {
            let lastIdx = min((i + 1) * 20, cityCount)
            let tempList = Array(internalData.cityIdList.value[i*20..<lastIdx])
            getWeather(tempList)
        }
        
    }
    private func getWeather(_ inputID: [Int]) {

        NetworkManager.shared.callRequest(target: .getWeatherInfo(id: inputID),model: Weather.self) { response in
            switch response {
            case .success(let value) :
                self.internalData.weatherInfo.value.append(contentsOf: value.list)
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                    print(inputID)
                }
            }
        }
    }
    private func mappingCityWeather() {
        guard let cityInfo = input.totalCityInfo.value else {return}
        let cityList = cityInfo.cities
        let weatehrList = internalData.weatherInfo.value
        var mapped = [CityWeather]()
        
        for city in cityList {
            if let weather = weatehrList.first(where: {$0.id == city.id}) {
                let cityweather = CityWeather(cityName: city.city, koCityName: city.koCityName, countryName: city.country, koCountryName: city.koCountryName, cityId: city.id, temp: weather.main.temp, tempMin: weather.main.temp_min, tempMax: weather.main.temp_max, description: weather.weather[0].description, icon: weather.weather[0].icon, windSpeed: weather.wind.speed, sunrise: weather.sys.sunrise, sunset: weather.sys.sunset, dateTime: weather.dt)
                
                mapped.append(cityweather)
            }
        }
        output.cityWeatherInfo.value = mapped
    }
}
