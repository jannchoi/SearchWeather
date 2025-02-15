//
//  SearchWeatherTableViewCell.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchWeatherTableViewCell: BaseTableViewCell {
    static let id = "SearchWeatherTableViewCell"
    
    private let cityLabel = UILabel()
    private let countryLabel = UILabel()
    private let tempMinMaxLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let tempLabel = UILabel()
    
    func configureData(weather: CurrentWeather, city: City ) {
        cityLabel.text = city.koCityName
        countryLabel.text = city.koCityName
        tempMinMaxLabel.text = String(format: WeatherFormat.tempMinMax, weather.main.temp_min, weather.main.temp_max)
        guard let url = weather.weather[0].icon.getWeatherIconURL() else {return}
        weatherIcon.kf.setImage(with: url)
        tempLabel.text = "\(weather.main.temp)°"
    }
    
    override func configureHierachy() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(tempMinMaxLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(tempLabel)
    }
    override func configureLayout() {
        cityLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.height.equalTo(20)
        }
        countryLabel.snp.makeConstraints { make in
            make.leading.equalTo(cityLabel)
            make.top.equalTo(cityLabel.snp.bottom)
            make.height.equalTo(15)
        }
        tempMinMaxLabel.snp.makeConstraints { make in
            make.leading.equalTo(cityLabel)
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.height.equalTo(15)
        }
        weatherIcon.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIcon.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(8)
            make.height.equalTo(45)
        }
    }
    override func configureView() {
        cityLabel.font = UIFont.boldSystemFont(ofSize: 14)
        countryLabel.font = UIFont.systemFont(ofSize: 12)
        tempMinMaxLabel.font = UIFont.systemFont(ofSize: 12)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 20)
        backgroundColor = .purple.withAlphaComponent(0.3)
        DispatchQueue.main.async {
            self.layer.cornerRadius = 8
        }
    }

}
