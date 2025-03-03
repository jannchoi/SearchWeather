//
//  MainCityViewController.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit
import Kingfisher
import SnapKit
import RxSwift
import RxCocoa

class MainCityViewController: UIViewController {
    let mainView = MainCityView()
    let mainViewModel = MainCityViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bindData()
//        mainView.forecastButton.addAction(UIAction(handler: { _ in
//            self.present(PageViewController(), animated: true)
//        }), for: .touchUpInside)
    }

    
    private func bindData() {
        let input = MainCityViewModel.Input(reloadDataTrigger: mainView.reloadButton.rx.tap, searchButtonTrigger: mainView.searchButton.rx.tap)
        let output = mainViewModel.transform(input: input)
        
        output.cityWeather.bind(with: self) { owner, cityweather in
            owner.updateLabel(cityweather)
            owner.setWeatherImage(url: cityweather.icon.getWeatherIconURL(), targetImage: owner.mainView.weatherIconImageView)
            owner.setWeatherImage(url: cityweather.weatherImage, targetImage: owner.mainView.weatherImageView)
        }.disposed(by: disposeBag)
        
        output.errorMessage.drive(with: self) { owner, message in
            owner.showAlert(title: "Error", text: message, button: nil)
        }.disposed(by: disposeBag)
        
        output.searchButtonTrigger.drive(with: self) { owner, _ in
            let vc = SearchWeatherViewController()
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)

    }
    private func setWeatherImage(url: URL?, targetImage: UIImageView) {
        if let url {
            targetImage.kf.setImage(with: url)
        } else {
            targetImage.image = UIImage(systemName: "star")
        }
    }
    private func updateLabel(_ model : CityWeather) {
        
        //city
        mainView.cityLabel.text = String(format: WeatherFormat.location, model.koCountryName, model.koCityName)
        //date
        mainView.dateLabel.text = model.dateTime.dateFormat()
        
        // description
        var formattedString = String(format: WeatherFormat.description, model.description)
        mainView.weatherLabel.attributedText = WeatherFormat.attributedSubstring(text: formattedString, arguments: [model.description])

        //temp tempmin tempmax
        formattedString = String(format: WeatherFormat.temp, model.temp, model.tempMin, model.tempMax)
        mainView.tempLabel.attributedText = WeatherFormat.attributToDoubleString(text: formattedString, boldTarget: [model.temp], grayTarget: [model.tempMin, model.tempMax], temp: true)

        //feelslike
        formattedString = String(format: WeatherFormat.feelsList, model.feels)
        mainView.feelsLabel.attributedText = WeatherFormat.attributToDoubleString(text: formattedString, boldTarget: [model.feels], grayTarget: nil, temp: true)

        //sun
        formattedString = String(format: WeatherFormat.sunriseSunset, model.koCityName, model.sunrise.formatTime(), model.sunset.formatTime())
        mainView.sunriseSunsetLabel.attributedText = WeatherFormat.attributedSubstring(text: formattedString, arguments: [model.sunrise.formatTime(), model.sunset.formatTime()])
        
        // humidity wind
        formattedString = String(format: WeatherFormat.humidityWind, model.humidity, model.windSpeed)
        mainView.pressureHumidityLabel.attributedText = WeatherFormat.attributToDoubleString(text: formattedString, boldTarget: [model.humidity, model.windSpeed], grayTarget: nil)
    }
    private func setNavigationBar() {
        let reloadItem = UIBarButtonItem(customView: mainView.reloadButton)
        let searchItem = UIBarButtonItem(customView: mainView.searchButton)
        navigationItem.rightBarButtonItems = [searchItem, reloadItem]
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateLayout()
    }
}

protocol PassDataDelegate {
    func passCityInfo() -> [City]?
    func passSelectedCityID(cityWeather: CityWeather)
}
