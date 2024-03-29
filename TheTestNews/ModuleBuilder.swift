//
//  ModuleBuilder.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//
import UIKit

protocol BuilderProtocol {
     static func createMain() -> UIViewController
     static func createErrorAlert(message: String) -> UIAlertController
     func createGeneralNews(router: RouterProtocol) -> UIViewController
     func createMainSource(router: RouterProtocol) -> UIViewController
     func createSourceNews(router: RouterProtocol) -> UIViewController
     func createSourceNewsArticles(router: RouterProtocol, source: String) -> UIViewController
     func createFullScreenNewsView(router: RouterProtocol, article: Article) -> UIViewController
    
    func createGeneralNewsViewController() -> UIViewController
    func createSourceNewsViewController() -> UIViewController
    func createMainSourceViewController() -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    
   static func createMain() -> UIViewController {
        MainViewController()
    }
    
    func createFullScreenNewsView(router: RouterProtocol, article: Article) -> UIViewController {
        let view = FullScreenArticleViewController()
        let networkService = NewsAPINetworkService()
        let presenter = FullScreenArticleViewPresenter(view: view, article: article, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createSourceNewsArticles(router: RouterProtocol, source: String) -> UIViewController {
        let view = SourceNewsArticlesViewController()
        let networkService = NewsAPINetworkService()
        let presenter = SourceNewsArticlesListPresenter(view: view , networkService: networkService, router: router, source: source)
        view.presenter = presenter
        return view
    }
    
    func createSourceNews(router: RouterProtocol) -> UIViewController {
        let view = SourceNewsViewController()
        let networkService = NewsAPINetworkService()
        let presenter = SourceNewsViewPresenter(view: view , networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
     func createGeneralNews(router: RouterProtocol) -> UIViewController {
        let view = GeneralNewsViewController()
        let networkService = NewsAPINetworkService()
        let presenter = GeneralNewsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createMainSource(router: RouterProtocol) -> UIViewController {
        let view = ArticlesSearchViewController()
        let networkService = NewsAPINetworkService()
        let presenter = ArticlesSearchViewPresenter(view: view , networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createGeneralNewsViewController() -> UIViewController {
            let navigationController = UINavigationController()
            let router = Router(navigationController: navigationController, moduleBuilder: self)
            router.showGeneralNews()
            return navigationController
        }
      
    func createSourceNewsViewController() -> UIViewController {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController, moduleBuilder: self)
        router.showSourceNews()
        return navigationController
    }
    
    func createMainSourceViewController() -> UIViewController {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController, moduleBuilder: self)
        router.showMainSource()
        return navigationController
    }
    
    static func createErrorAlert(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}

