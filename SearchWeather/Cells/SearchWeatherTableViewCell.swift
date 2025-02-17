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
    private let weatherPhoto = UIImageView()
    
    func configureData(cityWeather: CityWeather) {
        cityLabel.text = cityWeather.koCityName
        countryLabel.text = cityWeather.koCountryName
        tempMinMaxLabel.text = String(format: WeatherFormat.tempMinMax, cityWeather.tempMin, cityWeather.tempMax)
        guard let url = cityWeather.icon.getWeatherIconURL() else {return}
        weatherIcon.kf.setImage(with: url)
        tempLabel.text = "\(cityWeather.temp)°"
        if let photo = cityWeather.weatherImage {
            weatherPhoto.kf.setImage(with: photo)
            weatherPhoto.alpha = 0.5
        }else {
            weatherPhoto.image = UIImage(systemName: "heart")
        }
    }
    

    
    override func configureHierachy() {
        contentView.addSubview(weatherPhoto)
        contentView.addSubview(cityLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(tempMinMaxLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(tempLabel)
    }
    
    override func configureLayout() {
        weatherPhoto.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(8)
        }
        weatherIcon.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        tempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tempMinMaxLabel)
            make.trailing.equalToSuperview().inset(8)
            make.height.equalTo(45)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
    override func configureView() {
        cityLabel.font = UIFont.boldSystemFont(ofSize: 14)
        countryLabel.font = UIFont.systemFont(ofSize: 12)
        tempMinMaxLabel.font = UIFont.systemFont(ofSize: 12)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.backgroundColor = .purpleCell
        DispatchQueue.main.async {
            self.contentView.layer.cornerRadius = 8
        }
    }

}
