//
//  MainCityViewController.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit
import Kingfisher


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
        mainViewModel.output.weatherInfo.lazyBind { currentWeather in
            <#code#>
        }
        mainViewModel.output.weatherImage.lazyBind { [weak self] img in
            if let url = URL(string: img) {
                self?.mainView.weatherImageView.kf.setImage(with: url)
            } else {
                self?.mainView.weatherImageView.image = UIImage(systemName: "star")
            }
        }
    }
    private func updateLabel(_ model : CurrentWeather) {
        
    }
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.trianglehead.clockwise"), style: .plain, target: self, action: #selector(reloadWeather))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
    }
    @objc private func reloadWeather() {
        
    }
    @objc private func searchButtonTapped() {
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateLayout()
    }


}
