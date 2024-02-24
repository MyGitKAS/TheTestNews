//
//  ViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit

protocol PresenterProtocol: AnyObject {
    var newsCollection: NewsModel? { get set }
    func getData(endpoint: Endpoint)
    func itemIsPressed(index: Int)
    init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol, router: RouterProtocol)
}

protocol ViewControllerProtocol: AnyObject {
    func success()
    func present(viewController: UIViewController)
}

class MainViewController: UITabBarController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
    }
    
    private func setupConfiguration() {
        
        self.tabBar.tintColor = Constants.mainColor
        self.view.backgroundColor = UIColor.white
        
        let moduleBuilder = ModuleBuilder()
        let firstViewController = moduleBuilder.createGeneralNewsViewController()
        let secondViewController = moduleBuilder.createSourceNewsViewController()
        let thirdViewController = moduleBuilder.createMainSourceViewController()
        let fourthViewController = UIViewController()

        firstViewController.tabBarItem.image = UIImage(systemName: "checkmark.circle")
        secondViewController.tabBarItem.image = UIImage(systemName: "globe.europe.africa")
        thirdViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        fourthViewController.tabBarItem.image = UIImage(systemName: "gear.circle")
        
        firstViewController.title = "Main"
        secondViewController.title = "Sources"
        thirdViewController.title = "Search"
        fourthViewController.title = "Settings"
        
        let viewControllers = [
            firstViewController,
            secondViewController,
            thirdViewController,
            fourthViewController
        ]
        
        self.viewControllers = viewControllers
    }
}


