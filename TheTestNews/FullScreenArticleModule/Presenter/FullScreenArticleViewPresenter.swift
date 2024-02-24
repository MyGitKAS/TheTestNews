//
//  FullScreenNewsViewPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 22.02.24.
//

import Foundation
import SafariServices

protocol FullScreenArticlePresenterProtocol {
    var article: Article! { get }
    func goSiteButtonTapped()
    func sourceButtonTapped()
    func getImage(completion: @escaping (UIImage?) -> Void)
    init(view: FullScreenArticleViewControllerProtocol, article: Article, router: RouterProtocol, networkService: NewsAPINetworkServiceProtocol)
}
 
class FullScreenArticleViewPresenter: FullScreenArticlePresenterProtocol {
  
    let article: Article!
    private let networkService: NewsAPINetworkServiceProtocol!
    private var router: RouterProtocol!
    private weak var view: FullScreenArticleViewControllerProtocol!
  
    required init(view: FullScreenArticleViewControllerProtocol, article: Article, router: RouterProtocol, networkService: NewsAPINetworkServiceProtocol) {
        self.view = view
        self.article = article
        self.router = router
        self.networkService = networkService
        view.setData()
    }
    
    func goSiteButtonTapped() {
        guard let stringUrl = article.url else { return }
        guard let url = URL(string: stringUrl) else { return }
        let safariViewController = SFSafariViewController(url: url)
        view.presentWebView(viewController: safariViewController)
    }
    
    func sourceButtonTapped() {
        guard let stringUrl = article.source.url else { return }
        guard let url = URL(string: stringUrl) else { return }
        let safariViewController = SFSafariViewController(url: url)
        view.presentWebView(viewController: safariViewController)
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = article.urlToImage else {
            completion(UIImage(named: "test_image"))
            return
        }
        networkService.downloadImageWith(urlString: url) { image in
            guard let image = image else { return }
            let compressImage =  Helper.compress(image: image)
            completion(compressImage)
        }
    }
}
