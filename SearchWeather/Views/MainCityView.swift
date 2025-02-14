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
            make.height.equalTo(40)
        }
        tempLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(weatherLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        feelsLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(tempLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        sunriseSunsetLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(feelsLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        pressureHumidityLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(sunriseSunsetLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
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
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 10
        weatherStackView.alignment = .center
        weatherStackView.backgroundColor = .white

        cityLabel.labelDesign(inputText: "가갸아아다아타파나타타다아ㅏ", size: 30)
        cityLabel.backgroundColor = .white
        dateLabel.labelDesign(inputText: "dkeinciwnidankv", size: 14)
        dateLabel.backgroundColor = .white
        [weatherLabel, tempLabel, feelsLabel, sunriseSunsetLabel, pressureHumidityLabel, todayLabel].forEach{
            $0.labelDesign(inputText: "dkeinciwnidankv", size: 14)
            $0.backgroundColor = .white
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        weatherImageView.image = UIImage(systemName: "star")
        weatherImageView.backgroundColor = .gray
        imageBackView.backgroundColor = .white
        
    }
    func updateLayout() {
        [weatherStackView, tempLabel, feelsLabel, sunriseSunsetLabel, pressureHumidityLabel, imageBackView].forEach{
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
}
