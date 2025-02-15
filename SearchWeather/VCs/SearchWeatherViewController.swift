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
    var contents: PassDataDelegate?
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        bindData()
    }
    private func bindData() {
        searchViewModel.output.weatherInfo.lazyBind { list in
            print(list.count)
            self.mainView.cityTableView.reloadData()
        }
        searchViewModel.output.errorMessage.lazyBind {[weak self] message in
            self?.showAlert(title: "Error", text: message, button: nil)
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
        return searchViewModel.output.weatherInfo.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchWeatherTableViewCell.id) as? SearchWeatherTableViewCell else {return UITableViewCell()}
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity =  searchViewModel.output.weatherInfo.value[indexPath.row]
        var city : SelectedWeatherInfo?
        city?.currentWeatherToSelectedWeather(selectedCity)
        guard let city else {return}
        contents?.passCityInfo(selected: city)
        navigationController?.popViewController(animated: true)
    }

}
extension SearchWeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.input.searchedTerm.value = searchText
    }
}
