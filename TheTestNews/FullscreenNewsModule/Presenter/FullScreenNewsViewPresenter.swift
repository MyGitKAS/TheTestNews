//
//  FullScreenNewsViewPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 22.02.24.
//

import Foundation
import SafariServices

protocol FullScreenNewsViewPresenterProtocol {
    var article: Article! { get }
    func goSiteButtonTapped()
    init(view: FullScreenNewsViewControllerProtocol, article: Article, router: RouterProtocol)
}
 
class FullScreenNewsViewPresenter: FullScreenNewsViewPresenterProtocol {
    
    let article: Article!
    private var router: RouterProtocol!
    private weak var view: FullScreenNewsViewControllerProtocol!
  
    required init(view: FullScreenNewsViewControllerProtocol, article: Article, router: RouterProtocol) {
        self.view = view
        self.article = article
        self.router = router
        view.setData()
    }
    
    func goSiteButtonTapped() {
        guard let stringUrl = article.url else { return }
        guard let url = URL(string: stringUrl) else { return }
        let safariViewController = SFSafariViewController(url: url)
        view.present(viewController: safariViewController)
    }
}
