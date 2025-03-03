//
//  SearchWeatherViewController.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchWeatherViewController: UIViewController {

    let mainView = SearchWeatherView()
    var searchViewModel = SearchWeatherViewModel()
    let refreshControl = UIRefreshControl()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.cityTableView.refreshControl = refreshControl
        setNavigationBar()
        bindData()
    }

    private func bindData() {

        let recentText = BehaviorSubject<String?>(value: nil)
        let input = SearchWeatherViewModel.Input(reloadDataTrigger: refreshControl.rx.controlEvent(.valueChanged),selectedCity: mainView.cityTableView.rx.modelSelected(CityWeather.self), searchedTerm: recentText, didscroll: mainView.cityTableView.rx.didScroll)
        let output = searchViewModel.transform(input: input)

        
        output.cityWeather.bind(to: mainView.cityTableView.rx.items(cellIdentifier: SearchWeatherTableViewCell.id, cellType: SearchWeatherTableViewCell.self)) { [weak self]
            (row, element, cell) in
            
            cell.configureData(cityWeather: element)
            self?.refreshControl.endRefreshing()
        }.disposed(by: disposeBag)
        
        mainView.searchBar.rx.text.bind(to: recentText).disposed(by: disposeBag)
        
        output.showEmptyLabel.drive(with: self) { owner, showempty in
            if showempty {
                owner.mainView.cityTableView.isHidden = true
            }else  {
                owner.mainView.cityTableView.isHidden = false
            }
        }.disposed(by: disposeBag)
        
        output.errorMessage.drive(with: self) { owner, message in
            owner.showAlert(title: "Error", text: message, button: nil)
        }.disposed(by: disposeBag)
        
        output.didScroll.drive(with: self) { owner, _ in
            owner.mainView.searchBar.resignFirstResponder()
        }.disposed(by: disposeBag)
        
        output.selectedCity.bind(with: self) { owner, item in
            owner.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        mainView.backButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)

        
    }
    private func setNavigationBar() {
        navigationItem.title = "도시 검색"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.backButton)
    }

}


