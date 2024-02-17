//
//  ViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit

protocol MainViewControllerProtocol {
    
}

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
    }
    private func setupConfiguration() {
        
        self.tabBar.tintColor = Constants.mainColor
        self.view.backgroundColor = UIColor.white
        
        let firstViewController = UINavigationController(rootViewController: ModuleBuilder.createGeneralNews())
        let secondViewController = UIViewController()
        let thirdViewController = UIViewController()
        let fourthViewController = UIViewController()

        firstViewController.tabBarItem.image = UIImage(systemName: "person.circle")
        secondViewController.tabBarItem.image = UIImage(systemName: "globe.europe.africa")
        thirdViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        fourthViewController.tabBarItem.image = UIImage(systemName: "gear.circle")
        
        firstViewController.title = "ГЛАВНАЯ"
        secondViewController.title = "ИСТОЧНИКИ"
        thirdViewController.title = "ПОИСК"
        fourthViewController.title = "НАСТРОЙКИ"
        
        let viewControllers = [
            firstViewController,
            secondViewController,
            thirdViewController,
            fourthViewController
        ]
        
        self.viewControllers = viewControllers
    }
}
