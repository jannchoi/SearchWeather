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
    
    override func configureHierachy() {
        addSubview(searchBar)
        addSubview(cityTableView)
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
        cityTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        cityTableView.register(SearchWeatherTableViewCell.self, forCellReuseIdentifier: SearchWeatherTableViewCell.id)
    }
}

