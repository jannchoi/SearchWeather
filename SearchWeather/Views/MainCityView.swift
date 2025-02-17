//
//  MainCityView.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit
import SnapKit

final class MainCityView: BaseView {
    let cityLabel = UILabel()
    let dateLabel = UILabel()
    let weatherStackView = UIStackView()
    let weatherIconImageView = UIImageView()
    let weatherLabel = UILabel()
    let tempLabel = UILabel()
    let feelsLabel = UILabel()
    let sunriseSunsetLabel = UILabel()
    let pressureHumidityLabel = UILabel()
    let imageBackView = UIView()
    let todayLabel = UILabel()
    let weatherImageView = UIImageView()
    
    
    
    override func configureHierachy() {
        addSubview(weatherStackView)
        
        [cityLabel, dateLabel, tempLabel, feelsLabel, sunriseSunsetLabel, pressureHumidityLabel, imageBackView].forEach { addSubview($0) }
        weatherStackView.addArrangedSubview(weatherIconImageView)
        weatherStackView.addArrangedSubview(weatherLabel)
        imageBackView.addSubview(todayLabel)
        imageBackView.addSubview(weatherImageView)
    }
    override func configureLayout() {
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(50)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        weatherStackView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
        }
        weatherIconImageView.snp.makeConstraints { make in
            make.size.equalTo(38)
        }
        tempLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(weatherStackView.snp.bottom).offset(8)
            make.height.equalTo(45)
        }
        feelsLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(tempLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
        }
        sunriseSunsetLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(feelsLabel.snp.bottom).offset(8)
        }
        pressureHumidityLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(sunriseSunsetLabel.snp.bottom).offset(8)
            make.height.equalTo(45)
        }
        imageBackView.snp.makeConstraints { make in
            make.top.equalTo(pressureHumidityLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(8)
        }
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(imageBackView)
            make.leading.equalTo(imageBackView)
            make.height.equalTo(40)
        }
        weatherImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(imageBackView).inset(8)
            make.top.equalTo(todayLabel.snp.bottom)
            make.bottom.equalTo(imageBackView).inset(8)
        }
    }
    override func configureView() {
        backgroundColor = .purpleBack
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 10
        weatherStackView.alignment = .center
        weatherStackView.backgroundColor = .white
        cityLabel.labelDesign(inputText: "", size: 30, weight: .bold)
        dateLabel.labelDesign(inputText: "", size: 14, weight: .bold)
        [weatherLabel, tempLabel, feelsLabel, sunriseSunsetLabel, pressureHumidityLabel].forEach{
            $0.labelDesign(inputText: "", size: 14)
            $0.backgroundColor = .white
        }
        todayLabel.labelDesign(inputText: "  오늘의 사진", size: 14)
        weatherImageView.image = UIImage(systemName: "star")
        weatherImageView.backgroundColor = .white
        imageBackView.backgroundColor = .white
        
    }
    func updateLayout() {
        [cityLabel,dateLabel,weatherStackView, weatherImageView, tempLabel, feelsLabel, sunriseSunsetLabel, pressureHumidityLabel, imageBackView].forEach{
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
}
