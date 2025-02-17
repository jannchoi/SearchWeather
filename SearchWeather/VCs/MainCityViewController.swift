//
//  MainCityViewController.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit
import Kingfisher
import SnapKit


class MainCityViewController: UIViewController {
    let mainView = MainCityView()
    let mainViewModel = MainCityViewModel()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        bindData()
    }

    
    private func bindData() {
        
        mainViewModel.output.errorMessage.lazyBind {[weak self] message in
            self?.showAlert(title: "Error", text: message, button: nil)
        }
        mainViewModel.output.outputWeather.lazyBind {  cityWeather in
            guard let cityWeather else {return}
            self.updateLabel(cityWeather)
            self.setWeatherImage(url: cityWeather.icon.getWeatherIconURL(), targetImage: self.mainView.weatherIconImageView)
            self.mainView.cityLabel.text = String(format: WeatherFormat.location, cityWeather.koCountryName, cityWeather.koCityName)
        }
        mainViewModel.output.weatherImage.lazyBind { img in
            self.setWeatherImage(url: img, targetImage: self.mainView.weatherImageView)

        }
    }
    private func setWeatherImage(url: URL?, targetImage: UIImageView) {
        if let url {
            targetImage.kf.setImage(with: url)
        } else {
            targetImage.image = UIImage(systemName: "star")
        }
        
    }
    private func updateLabel(_ model : CityWeather) {
        
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
        let reloadItem = UIBarButtonItem(image: UIImage(systemName: "arrow.trianglehead.clockwise"), style: .plain, target: self, action: #selector(reloadWeather))
        reloadItem.tintColor = .black
        let searchItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchItem.tintColor = .black
        navigationItem.rightBarButtonItems = [searchItem, reloadItem]
        
    }
    @objc private func reloadWeather() {
        mainViewModel.input.reloadDataTrigger.value = ()
    }
    @objc private func searchButtonTapped() {
        let vc = SearchWeatherViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateLayout()
    }
}

protocol PassDataDelegate {
    func passCityInfo() -> CityInfo?
    func passSelectedCityID(cityWeather: CityWeather)
}
extension MainCityViewController: PassDataDelegate {
    func passCityInfo() -> CityInfo? {
        return mainViewModel.output.cityInfo
    }
    func passSelectedCityID(cityWeather: CityWeather) {
        mainViewModel.input.selectedCityWeather.value = cityWeather
    }
}
