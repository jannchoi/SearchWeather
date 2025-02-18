//
//  SearchWeatherView.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import UIKit
import SnapKit
final class SearchWeatherView : BaseView {
    let searchBar = UISearchBar()
    let cityTableView = UITableView()
    let emptyResultLabel = UILabel()
    
    override func configureHierachy() {
        addSubview(searchBar)
        addSubview(emptyResultLabel)
        addSubview(cityTableView)
        
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
        emptyResultLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
        cityTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaInsets)
        }
    }
    override func configureView() {
        backgroundColor = .white
        cityTableView.backgroundColor = .purpleBack
        emptyResultLabel.labelDesign(inputText: "원하는 도시를 찾지 못했습니다.", size: 14)
        cityTableView.register(SearchWeatherTableViewCell.self, forCellReuseIdentifier: SearchWeatherTableViewCell.id)
    }
}

