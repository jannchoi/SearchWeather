//
//  MainCityViewModel.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation
import RxSwift
import RxCocoa


final class MainCityViewModel {
    private var internalData: InternalData
    let disposeBag = DisposeBag()
    let selectedCity = UserDefaultsManager.city
    let selectedCityID = BehaviorRelay(value: UserDefaultsManager.cityID)
    let errorMessageTrigger = PublishSubject<String>()

    struct Input {
        let reloadDataTrigger : ControlEvent<Void>
        let searchButtonTrigger : ControlEvent<Void>

    }
    struct Output {
        let cityWeather : PublishSubject<CityWeather>
        let errorMessage : Driver<String>
        let searchButtonTrigger : Driver<Void>

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
    
    
    // getweather -> getphoto -> mapping 순서로 진행
    func transform(input: Input) -> Output {
        let id = selectedCity.id
        let inputButtonTapped = input.reloadDataTrigger.map{
            id}
        Observable.merge(selectedCityID.asObservable(),inputButtonTapped)
            .bind(with: self) { owner, id in
                owner.getWeather([id])
            }.disposed(by: disposeBag)

        let outputWeather = PublishSubject<CityWeather>()
        internalData.cityWeather.bind(to: outputWeather).disposed(by: disposeBag)
        let errorMessage = PublishRelay<String>()
        errorMessageTrigger.bind(to: errorMessage).disposed(by: disposeBag)

        return Output(cityWeather: outputWeather,errorMessage: errorMessage.asDriver(onErrorJustReturn: ""),searchButtonTrigger: input.searchButtonTrigger.asDriver())
        
        
        
//        input.selectedCityID.bind { [weak self] id in //초기 진입시
//            self?.getWeather([id])
//        }
//        input.reloadDataTrigger.lazyBind { _ in // 새로고침
//            self.getWeather([self.input.selectedCityID.value])
//        }
//        input.selectedCityWeather.lazyBind { [weak self] cityWeather in //searchview에서 선택된 도시를 받아왔을 때
//            guard let cityWeather else {return}
//            self?.output.outputWeather.value = cityWeather
//            self?.input.selectedCityID.value = UserDefaultsManager.cityID
//            UserDefaultsManager.cityID = cityWeather.cityId
//        }

    }
 
    
    private func getWeather(_ input: [Int]) { //날씨 데이터
        let group = DispatchGroup()
        group.enter()
        Observable.just(input)
            .flatMap {
                NetworkManager.shared.callRequest(target: .getWeatherInfo(id: $0),model: Weather.self)
                    .catch { [weak self] error in
                        if let error = error as? NetworkError {
                            self?.errorMessageTrigger.onNext(error.errorMessage)
                        }
                        return Observable.just(Weather(list: []))
                    }
            }
            .subscribe(with: self) { owner, weather in
                owner.internalData.weatherInfo = weather.list.first
                owner.internalData.weatherQeury = weather.list.first?.weather.first?.main
                group.leave()
            } onError: { _, error in
                print("error", error)
                group.leave()
            } onDisposed: { _ in
                print("disposed")
            }.disposed(by: disposeBag)
        
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
        Observable.just(weather).flatMap {
            NetworkManager.shared.callRequest(target: .getWeatherPhoto(query: $0),model: Photo.self)
                .catch { [weak self] error in
                    if let error = error as? NetworkError {
                        self?.errorMessageTrigger.onNext(error.errorMessage)
                    }
                    return Observable.just(Photo(results: []))
                }
                }.subscribe(with: self) { owner, result in
                    if let photo = result.results.first, let url = photo.urls.thumb {
                        owner.internalData.weatherImage = URL(string: url)
                    } else {
                        self.internalData.weatherImage = nil
                    }
                    group.leave()
                } onError: { _, error in
                    print("error", error)
                    group.leave()
                } onDisposed: { _ in
                    print("disposed")
                }.disposed(by: disposeBag)
            
            group.notify(queue: .main) {
                self.mappingCityWeather()
            }
        }
    private func mappingCityWeather()  { // 서버에서 얻은 데이터와 cityinfo데이터를 cityweather로 매핑
        guard let weatherInfo = internalData.weatherInfo else {return}
        var tempWeather : CityWeather
        tempWeather = CityWeather(cityName: selectedCity.koCity, koCityName: selectedCity.koCity, countryName: selectedCity.koCountry, koCountryName: selectedCity.koCountry, cityId: selectedCity.id, temp: weatherInfo.main.temp, tempMin: weatherInfo.main.temp_min, tempMax: weatherInfo.main.temp_max, description: weatherInfo.weather[0].description, icon: weatherInfo.weather[0].icon, windSpeed: weatherInfo.wind.speed, sunrise: weatherInfo.sys.sunrise, sunset: weatherInfo.sys.sunset, dateTime: weatherInfo.dt, feels: weatherInfo.main.feels_like, humidity: weatherInfo.main.humidity, weatherImage: internalData.weatherImage)
        internalData.cityWeather.onNext(tempWeather)
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
       
}
