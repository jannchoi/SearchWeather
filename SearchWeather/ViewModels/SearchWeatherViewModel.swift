//
//  SearchWeatherViewModel.swift
//  SearchWeather
//
//  Created by 최정안 on 2/15/25.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchWeatherViewModel {
    private var internalData: InternalData
    let disposeBag = DisposeBag()
    let cityInfo = CityInfo.decode(fileName: "CityInfo")
    let errorMessageTrigger = PublishSubject<String>()

    struct Input {
        let reloadDataTrigger : ControlEvent<Void>
        let selectedCityInfo
        let searchedTerm

    }
    struct Output {
        let cityWeather : PublishSubject<CityWeather>
        let errorMessage : Driver<String>
        let reloadDataTrigger : Driver<Void>

    }
    private struct InternalData {
        var weatherQeury : String? = ""
        var weatherImage : URL? = nil
        var weatherInfo : CurrentWeather? = nil
        var cityWeather = PublishSubject<CityWeather>()
    }
    
    init() {
        internalData = InternalData()
    }

//        
//    }
//    struct Output {
//        var errorMessage: Observable<String> = Observable("")
//        var showEmptyLabel = Observable(false)
//        var filteredCityWeather = Observable([CityWeather]())
//    }
//    private struct InternalData {
//        var weatherInfo = Observable([CurrentWeather]())
//        var cityWeatherInfo = Observable([CityWeather]())
//        var weatherImageUrlList = Observable([URL?]())
//        
//    }
//    
//    init() {
//        input = Input()
//        output = Output()
//        internalData = InternalData()
//        transform()
//    }
    func transform() {
        //초기 진입, 데이터 리로드 :getIdlist ->getquery -> getphot -> getweather -> mapping 순서
        // 검색어 입력 : geIdlist
        input.reloadData.lazyBind { _ in // 데이터 새로고침
            getIdList(nil)
        }
        input.totalCityInfo.lazyBind { cityinfo in // 초기진입시 mainviewmodel에서 얻은 cityinfo를 받아와서 데이터 로드
            guard cityinfo != nil else {return}
            getIdList(nil)
        }
        
        input.searchedTerm.lazyBind { text in // 검색어 입력 시
            guard let text else {return}
            var inputText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            inputText = inputText.lowercased()
            getIdList(inputText)
        }
    }
    
    private func getIdList(_ inputText: String?) {
        internalData.weatherInfo.value.removeAll()
        guard let cityInfo = input.totalCityInfo.value else {return}
        
        if let inputText {// used, 정상검색어
            if !inputText.isEmpty {
                var tempCityWeather = [CityWeather]()
                for (idx,city) in cityInfo.enumerated(){
                    if city.city.lowercased().contains(inputText) || city.koCityName.contains(inputText) || city.country.lowercased().contains(inputText) ||
                        city.koCountryName.contains(inputText) {
                        tempCityWeather.append(internalData.cityWeatherInfo.value[idx])
                    }
                }
                if tempCityWeather.isEmpty { // 내부 전테 데이터 할당
                    output.showEmptyLabel.value = true
                    output.filteredCityWeather.value = internalData.cityWeatherInfo.value
                    return
                } // 필터링된 데이터 할당
                output.filteredCityWeather.value = tempCityWeather

            } else { // 공백 검색 : 내부 전체 데이터 할당
                output.filteredCityWeather.value = internalData.cityWeatherInfo.value
            }
            
        } else { // initial / refresh : 데이터 리로드
            internalData.weatherImageUrlList.value.removeAll()
            getQueryID()
        }
        output.showEmptyLabel.value = false

    }
    private func getQueryID() {
        guard let cityInfo = input.totalCityInfo.value else {return}
        let infoList = cityInfo.map{$0.id}
        
        let cityCount = infoList.count
        let loopCount = (cityCount / 20)
        let group = DispatchGroup() // 루프를 다 돌고 최종적인 날씨 데이터를 확보 후 getWeatherPhoto
        
        for i in 0...loopCount {
            let lastIdx = min((i + 1) * 20, cityCount)
            let tempList = Array(infoList[i*20..<lastIdx])
            group.enter()
            getWeather(tempList, group: group)
        }
        group.notify(queue: .main) {
            self.getWeatherPhoto()
        }
        
    }
    private func getWeather(_ inputID: [Int], group: DispatchGroup) {
        NetworkManager.shared.callRequest(target: .getWeatherInfo(id: inputID),model: Weather.self) { response in
            switch response {
            case .success(let value) :
                self.internalData.weatherInfo.value.append(contentsOf: value.list)
                group.leave()
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
                group.leave()
            }
        }
        
    }
    
    private func getWeatherPhoto() {
        let group = DispatchGroup() // 날씨데이터를 모두 확보 후 mapping
        let queryList = internalData.weatherInfo.value.map{$0.weather.first?.main}
        for i in queryList.indices {
            group.enter()
            var weather = "sunny"
            if queryList[i] != nil {
                weather = queryList[i]!
            }
            NetworkManager.shared.callRequest(target: .getWeatherPhoto(query: weather),model: Photo.self) { response in
                switch response {
                case .success(let value) :
                    var url : URL?
                    if let photo = value.results.first, let photoUrl = photo.urls.thumb {
                        url = URL(string: photoUrl)
                    } else {
                        url = nil
                    }
                    internalData.weatherImageUrlList.value.append(url)
                    group.leave()
                case .failure(let failure) :
                    if let errorType = failure as? NetworkError {
                        self.output.errorMessage.value = errorType.errorMessage
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            mappingCityWeather()

        }
    }
    private func mappingCityWeather() {
        guard let cityInfo = input.totalCityInfo.value else {return}
        let weatehrList = internalData.weatherInfo.value
        var mapped = [CityWeather]()
        if cityInfo.count == internalData.weatherImageUrlList.value.count {
            for (idx,city) in cityInfo.enumerated() {
                if let weather = weatehrList.first(where: {$0.id == city.id}) {
                    let cityweather = CityWeather(cityName: city.city, koCityName: city.koCityName, countryName: city.country, koCountryName: city.koCountryName, cityId: city.id, temp: weather.main.temp, tempMin: weather.main.temp_min, tempMax: weather.main.temp_max, description: weather.weather[0].description, icon: weather.weather[0].icon, windSpeed: weather.wind.speed, sunrise: weather.sys.sunrise, sunset: weather.sys.sunset, dateTime: weather.dt, feels: weather.main.feels_like, humidity: weather.main.humidity, weatherImage: internalData.weatherImageUrlList.value[idx])
                    
                    mapped.append(cityweather)
                }
            }
            let result = mapped.sorted{$0.koCountryName < $1.koCountryName}
            self.internalData.cityWeatherInfo.value = result
            self.output.filteredCityWeather.value = result
        }
    }

}
