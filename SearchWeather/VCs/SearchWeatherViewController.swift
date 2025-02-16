//
//  SearchWeatherViewController.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit

class SearchWeatherViewController: UIViewController {

    let mainView = SearchWeatherView()
    let searchViewModel = SearchWeatherViewModel()
    var delegate: PassDataDelegate?
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setNavigationBar()
        bindData()
        mainView.searchBar.placeholder = "지금, 날씨가 궁금한 곳은?"
        
    }
    private func setNavigationBar() {
        navigationItem.title = "도시 검색"
    }
    private func bindData() {
        searchViewModel.input.totalCityInfo.value = delegate?.passCityInfo()
        
        searchViewModel.output.cityWeatherInfo.lazyBind { list in
            self.mainView.cityTableView.reloadData()
        }
        searchViewModel.output.errorMessage.lazyBind {[weak self] message in
            self?.showAlert(title: "Error", text: message, button: nil)
        }
        searchViewModel.output.showEmptyLabel.lazyBind { showempty in
            if showempty {
                self.mainView.cityTableView.isHidden = true
            }else  {
                self.mainView.cityTableView.isHidden = false
            }
        }
    }
    private func setDelegate() {
        mainView.cityTableView.delegate = self
        mainView.cityTableView.dataSource = self
        mainView.searchBar.delegate = self
    }

}
extension SearchWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return searchViewModel.output.cityWeatherInfo.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchWeatherTableViewCell.id) as? SearchWeatherTableViewCell else {return UITableViewCell()}
        cell.configureData(cityWeather: searchViewModel.output.cityWeatherInfo.value[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity =  searchViewModel.output.cityWeatherInfo.value[indexPath.row]
        delegate?.passSelectedCityID(id: selectedCity.cityId)
        navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
extension SearchWeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.input.searchedTerm.value = searchText
    }
}
