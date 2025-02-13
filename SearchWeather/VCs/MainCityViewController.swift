//
//  MainCityViewController.swift
//  SearchWeather
//
//  Created by 최정안 on 2/13/25.
//

import UIKit

class MainCityViewController: UIViewController {
    let mainView = MainCityView()
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
