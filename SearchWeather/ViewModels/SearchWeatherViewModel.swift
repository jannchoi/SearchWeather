//
//  SearchWeatherViewModel.swift
//  SearchWeather
//
//  Created by 최정안 on 2/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchWeatherViewModel {
    private var internalData: InternalData
    let disposeBag = DisposeBag()
    let cityInfo = CityInfo.decode(fileName: "CityInfo")
    let errorMessageTrigger = PublishSubject<String>()

    struct Input {
        let reloadDataTrigger : ControlEvent<Void>
        let selectedCity : ControlEvent<CityWeather>
        let searchedTerm : BehaviorSubject<String?>
        let didscroll : ControlEvent<Void>

    }
    struct Output {
        let cityWeather : PublishSubject<[CityWeather]>
        let errorMessage : Driver<String>
        let showEmptyLabel : Driver<Bool>
        let selectedCity : ControlEvent<CityWeather>
        let didScroll : Driver<Void>

    }
    private struct InternalData {
        var weatherQeury : String? = ""
        var weatherInfo = [CurrentWeather]()
        var filteredCityWeather = BehaviorSubject(value: [CityWeather]())
        var totalCityWeather = [CityWeather]()
        var waetherImageURLList = [URL?]()
        var showEmptyLabel = BehaviorSubject(value: false)
    }
    
    init() {
        internalData = InternalData()
    }
    func transform(input: Input) -> Output {
        //        //초기 진입, 데이터 리로드 :getIdlist ->getquery -> getphot -> getweather -> mapping 순서
        //        // 검색어 입력 : geIdlist
        Observable.merge(input.searchedTerm, input.reloadDataTrigger.map{ _ in nil}).bind(with: self) { owner, text in
            if let text {
                var inputText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                inputText = inputText.lowercased()
                owner.getIdList(inputText)
            } else {
                owner.getIdList(text)
            }

        }.disposed(by: disposeBag)

        let cityWeather = PublishSubject<[CityWeather]>()
        internalData.filteredCityWeather.bind(to: cityWeather).disposed(by: disposeBag)
        
        return Output(cityWeather: cityWeather, errorMessage: errorMessageTrigger.asDriver(onErrorJustReturn: "Unknown Error"), showEmptyLabel: internalData.showEmptyLabel.asDriver(onErrorJustReturn: false),selectedCity: input.selectedCity, didScroll: input.didscroll.asDriver())
    }
    
    private func getIdList(_ inputText: String?) {
        internalData.weatherInfo.removeAll()
        guard let cityInfo = cityInfo else {return}
        if let inputText {// used, 정상검색어
            if !inputText.isEmpty {
                var tempCityWeather = [CityWeather]()
                for (idx,city) in cityInfo.cities.enumerated(){
                    if city.city.lowercased().contains(inputText) || city.koCityName.contains(inputText) || city.country.lowercased().contains(inputText) ||
                        city.koCountryName.contains(inputText) {
                        tempCityWeather.append(internalData.totalCityWeather[idx])
                    }
                }
                if tempCityWeather.isEmpty { // 내부 전테 데이터 할당
                    internalData.showEmptyLabel.onNext(true)
                    internalData.filteredCityWeather.onNext(internalData.totalCityWeather)
                    return
                    
                } // 필터링된 데이터 할당
                internalData.filteredCityWeather.onNext(tempCityWeather)

            } else { // 공백 검색 : 내부 전체 데이터 할당
                internalData.filteredCityWeather.onNext(internalData.totalCityWeather)
            }
            
        } else { // initial / refresh : 데이터 리로드
            internalData.waetherImageURLList.removeAll()
            getQueryID()
        }
        internalData.showEmptyLabel.onNext(false)

    }
    private func getQueryID() {
        guard let cityInfo else {return}
        let infoList = cityInfo.cities.map{$0.id}
        
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
        Observable.just(inputID)
            .flatMap {
                NetworkManager.shared.callRequest(target: .getWeatherInfo(id: $0),model: Weather.self)
                    .catch {[weak self] error in
                        if let error = error as? NetworkError {
                            self?.errorMessageTrigger.onNext(error.errorMessage)
                        }
                        return Observable.just(Weather(list: []))
                    }
            }.subscribe(with: self){ owner, weather in
                owner.internalData.weatherInfo.append(contentsOf: weather.list)
                group.leave()
            } onError: {owner, error in
                print("error", error)
                group.leave()
            } onDisposed: { _ in
                print("disposed")
            }.disposed(by: disposeBag)
        
    }
    
    private func getWeatherPhoto() {
        let group = DispatchGroup() // 날씨데이터를 모두 확보 후 mapping
        let queryList = internalData.weatherInfo.map{$0.weather.first?.main}
        for i in queryList.indices {
            group.enter()
            var weather = "sunny"
            if queryList[i] != nil {
                weather = queryList[i]!
            }
            Observable.just(weather).flatMap{
                NetworkManager.shared.callRequest(target: .getWeatherPhoto(query: $0),model: Photo.self)
            }.catch {[weak self] error in
                if let error = error as? NetworkError {
                    self?.errorMessageTrigger.onNext(error.errorMessage)
                }
                return Observable.just(Photo(results: []))
                
            }.subscribe(with: self){owner, result in
                var url : URL?
                if let photo = result.results.first, let photoUrl = photo.urls.thumb {
                    url = URL(string: photoUrl)
                } else {
                    url = nil
                }
                owner.internalData.waetherImageURLList.append(url)
                group.leave()
            } onError: {owner,error in
                print("error", error)
                group.leave()
            } onDisposed: { _ in
                print("disposed")
            }.disposed(by: disposeBag)
            
            group.notify(queue: .main) {
                self.mappingCityWeather()
            }
        }
        }
        private func mappingCityWeather() {
        guard let cityInfo else {return}
        let weatehrList = internalData.weatherInfo
        var mapped = [CityWeather]()
            if cityInfo.cities.count == internalData.waetherImageURLList.count {
            for (idx,city) in cityInfo.cities.enumerated() {
                if let weather = weatehrList.first(where: {$0.id == city.id}) {
                    let cityweather = CityWeather(cityName: city.city, koCityName: city.koCityName, countryName: city.country, koCountryName: city.koCountryName, cityId: city.id, temp: weather.main.temp, tempMin: weather.main.temp_min, tempMax: weather.main.temp_max, description: weather.weather[0].description, icon: weather.weather[0].icon, windSpeed: weather.wind.speed, sunrise: weather.sys.sunrise, sunset: weather.sys.sunset, dateTime: weather.dt, feels: weather.main.feels_like, humidity: weather.main.humidity, weatherImage: internalData.waetherImageURLList[idx])
                    
                    mapped.append(cityweather)
                }
            }
            let result = mapped.sorted{$0.koCountryName < $1.koCountryName}
            internalData.totalCityWeather = result
            internalData.filteredCityWeather.onNext(result)
        }
    }

}
