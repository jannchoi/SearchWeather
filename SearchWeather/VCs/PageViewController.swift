//
//  PageViewController.swift
//  SearchWeather
//
//  Created by 최정안 on 2/17/25.
//

import UIKit

class PageViewController: UIPageViewController {

    private var pages = [UIViewController]()
    private var weatherData = [CityWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        self.delegate = self
        setupPage()
        setupUI()
        
    }
    private func setupPage() {
        let page1 = MainCityViewController()
        page1.mainView.backgroundColor = .red
        let page2 = MainCityViewController()
        page2.mainView.backgroundColor = .yellow
        let page3 = MainCityViewController()
        page3.mainView.backgroundColor = .green
        pages.append(contentsOf: [page1, page2, page3])
    }
    private func setupUI() {
        self.dataSource = self
        self.setViewControllers([pages[0]], direction: .forward, animated: false)
    }

}
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
                
                guard currentIndex > 0 else { return nil }
                return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
                
                guard currentIndex < (pages.count - 1) else { return nil }
                return pages[currentIndex + 1]
    }
    
    
}
