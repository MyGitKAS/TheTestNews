//
//  Router.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 21.02.24.
//

import Foundation
import UIKit

protocol MainRouterProtocol {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: BuilderProtocol? { get set }
}

protocol RouterProtocol: MainRouterProtocol {
    func showGeneralNews()
    func showMainSource()
    func showSourceNews()
    func popToRoot()
    func showSourceNewsArticles(source: String)
    func showFullscreenNews(article: Article)
}

class Router: RouterProtocol {

    var navigationController: UINavigationController?
    var moduleBuilder: BuilderProtocol?
    
    init(navigationController: UINavigationController, moduleBuilder: BuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
        
    func showFullscreenNews(article: Article) {
        guard let navigationController = navigationController else { return }
        guard let mainViewController = moduleBuilder?.createFullScreenNewsView(router: self, article: article) else { return }
        navigationController.viewControllers.append(mainViewController)
    }
    
    func showSourceNewsArticles(source: String){
        guard let navigationController = navigationController else { return }
        guard let mainViewController = moduleBuilder?.createSourceNewsArticles(router: self, source: source) else { return }
        navigationController.viewControllers.append(mainViewController)
    }
    
    func showGeneralNews() {
        guard let navigationController = navigationController else { return }
        guard let mainViewController = moduleBuilder?.createGeneralNews(router: self) else { return }
        navigationController.viewControllers = [mainViewController]
    }
    
    func showMainSource() {
        guard let navigationController = navigationController else { return }
        guard let mainViewController = moduleBuilder?.createMainSource(router: self) else { return }
        navigationController.viewControllers = [mainViewController]
    }
    
    func showSourceNews() {
        guard let navigationController = navigationController else { return }
        guard let mainViewController = moduleBuilder?.createSourceNews(router: self) else { return }
        navigationController.viewControllers = [mainViewController]
    }
    
    func popToRoot() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }
}
