//
//  ModuleBuilder.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//
import UIKit

protocol Builder {
    static func createMain() -> UIViewController
    static func createGeneralNews() -> UIViewController
    static func createMainSource() -> UIViewController
}

class ModuleBuilder: Builder {
   
    static func createMain() -> UIViewController {
        let view = MainViewController()
        return view
    }
    
    static func createGeneralNews() -> UIViewController {
        let view = GeneralNewsViewController()
        let networkService = NewsAPINetworkService()
        let presenter = GeneralNewsPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    static func createMainSource() -> UIViewController {
        let view = ArticlesSearchViewController()
        let networkService = NewsAPINetworkService()
        let presenter = ArticlesSearchViewPresenter(view: view , networkService: networkService)
        view.presenter = presenter
        return view
    }
}
