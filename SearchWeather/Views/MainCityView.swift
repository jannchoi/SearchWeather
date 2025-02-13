//
//  MainCityView.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit
final class MainCityView: BaseView {
    let stackView = UIStackView()
    let cityLabel = UILabel()
    let dateLabel = UILabel()
    let weatherLabel = UILabel()
    let tempLabel = UILabel()
    let feelsLabel = UILabel()
    let sunriseSunsetLabel = UILabel()
    let pressureHumidityLabel = UILabel()
    let imageBackView = UIView()
    let weatherImageView = UIImageView()
    
    
    
    override func configureHierachy() {
        addSubview(stackView)
        [cityLabel, dateLabel, weatherLabel, tempLabel, feelsLabel, sunriseSunsetLabel, pressureHumidityLabel, imageBackView].forEach { stackView.addArrangedSubview($0) }
        imageBackView.addSubview(weatherLabel)
    }
    override func configureLayout() {
        
    }
    override func configureView() {
        stackView.axis = .vertical
    }
}
