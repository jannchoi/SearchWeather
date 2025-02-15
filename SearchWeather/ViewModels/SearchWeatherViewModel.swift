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
    }
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        var selectedCity: Observable<City?> = Observable(nil)
        var weatherInfo = Observable([CurrentWeather]())
    }
    private struct InternalData {

        var totalCityInfo = CityInfo.decode(fileName: "CityInfo")
        var cityIdList = Observable([Int]())
    }
    
    init() {
        input = Input()
        output = Output()
        internalData = InternalData()
        transform()
    }
    func transform() {
        getIdList(nil)
        
        input.searchedTerm.lazyBind { text in
            guard let text else {return}
            var inputText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            inputText = inputText.lowercased()
            getIdList(inputText)
            
        }
        
    }
    private func getIdList(_ inputText: String?) {
        guard let cityInfo = internalData.totalCityInfo else {return}

        if let inputText, inputText != "" {
            var idList = [Int]()
            for i in cityInfo.cities{
                if i.city.lowercased().contains(inputText) || i.koCityName.contains(inputText) || i.country.lowercased().contains(inputText) ||
                    i.koCountryName.contains(inputText) {
                    idList.append(i.id)
                }
            }
            internalData.cityIdList.value = idList
        } else {
            internalData.cityIdList.value = cityInfo.cities.map{$0.id}
        }
        
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
                self.output.weatherInfo.value.append(contentsOf: value.list)
            case .failure(let failure) :
                if let errorType = failure as? NetworkError {
                    self.output.errorMessage.value = errorType.errorMessage
                }
            }
        }
    }
}
