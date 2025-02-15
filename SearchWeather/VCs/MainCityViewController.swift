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
        view.backgroundColor = .brown
        
        setNavigationBar()
        bindData()
    }
    
    private func bindData() {
        
        mainViewModel.output.errorMessage.lazyBind {[weak self] message in
            self?.showAlert(title: "Error", text: message, button: nil)
        }
        mainViewModel.input.selectedCityInfo.bind { selectedWeather in
            print(selectedWeather)
            self.updateLabel(selectedWeather)
            self.setWeatherImage(url: selectedWeather.iconURL, targetImage: self.mainView.weatherIconImageView)
            
        }

        mainViewModel.output.weatherImage.lazyBind { img in
            self.setWeatherImage(url: img, targetImage: self.mainView.weatherImageView)

        }
        mainViewModel.output.selectedCity.bind { [weak self] city in
            guard let city else {return}
            self?.mainView.cityLabel.text = String(format: WeatherFormat.location, city.koCountryName, city.koCityName)
        }
    }
    private func setWeatherImage(url: URL?, targetImage: UIImageView) {
        if let url {
            targetImage.kf.setImage(with: url)
        } else {
            targetImage.image = UIImage(systemName: "star")
        }
        
    }
    private func updateLabel(_ model : SelectedWeatherInfo) {
        
        mainView.dateLabel.text = model.dt.dateFormat()
        
        var formattedString = String(format: WeatherFormat.description, model.description)
        mainView.weatherLabel.attributedText = WeatherFormat.attributedSubstring(text: formattedString, arguments: [model.description])

        formattedString = String(format: WeatherFormat.temp, model.main.temp, model.main.temp_min, model.main.temp_max)
        mainView.tempLabel.attributedText = WeatherFormat.attributToDoubleString(text: formattedString, boldTarget: [model.main.temp], grayTarget: [model.main.temp_min, model.main.temp_max])

        formattedString = String(format: WeatherFormat.feelsList, model.main.feels_like)
        mainView.feelsLabel.attributedText = WeatherFormat.attributToDoubleString(text: formattedString, boldTarget: [model.main.feels_like], grayTarget: nil)

        formattedString = String(format: WeatherFormat.sunriseSunset, model.name, model.sys.sunrise.formatTime(), model.sys.sunset.formatTime())
        mainView.sunriseSunsetLabel.attributedText = WeatherFormat.attributedSubstring(text: formattedString, arguments: [model.sys.sunrise.formatTime(), model.sys.sunset.formatTime()])
        mainView.sunriseSunsetLabel.snp.makeConstraints { make in
            make.height.equalTo(mainView.sunriseSunsetLabel.intrinsicContentSize.height)
        }
        formattedString = String(format: WeatherFormat.humidityWind, model.main.humidity, model.windSpeed)
        mainView.pressureHumidityLabel.attributedText = WeatherFormat.attributToDoubleString(text: formattedString, boldTarget: [model.main.humidity, model.windSpeed], grayTarget: nil)
        view.layoutIfNeeded()
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
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateLayout()
    }
}

protocol PassDataDelegate {
    func passCityInfo(selected: SelectedWeatherInfo)
}
extension MainCityViewController: PassDataDelegate {
    func passCityInfo(selected: SelectedWeatherInfo) {
        mainViewModel.input.selectedCityInfo.value = selected
    }
}
