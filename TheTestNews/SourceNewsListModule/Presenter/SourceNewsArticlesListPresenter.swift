//
//  SourceNewsArticlesListPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 22.02.24.
//

import Foundation
import UIKit

protocol SourceNewsArticlesListPresenterProtocol: PresenterProtocol {
    var source: String { get }
    func getImage(index: Int, completion: @escaping (UIImage?) -> Void)
    init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol, router: RouterProtocol, source: String)
}

class SourceNewsArticlesListPresenter: SourceNewsArticlesListPresenterProtocol {
    
    var source: String
    var newsCollection: NewsModel?
    
    private weak var view: ViewControllerProtocol!
    private let networkService: NewsAPINetworkServiceProtocol!
    private let router: RouterProtocol!
    
    required init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.source = ""
    }
    
    required init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol, router: RouterProtocol, source: String) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.source = source
        startLoad()
    }
    
    private func startLoad() {
        let endpoint = Endpoint.articlesFromSource(source)
        getData(endpoint: endpoint)
    }
    
    func getData(endpoint: Endpoint) {
        networkService.getNews(endpoint: endpoint) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let news):
                        self?.newsCollection = news
                        self?.view.success()
                    case .failure(let error):
                        let alertController = ModuleBuilder.createErrorAlert(message: error.localizedDescription)
                        self?.view.present(viewController: alertController)
                }
            }
        }
    }
    
    func getImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let url = newsCollection?.articles[index].urlToImage else {
            completion(UIImage(named: "test_image"))
            return
        }
        networkService.downloadImageWith(urlString: url) { image in
            guard let image = image else { return }
           let compressImage =  Helper.compress(image: image)
            completion(compressImage)
        }
    }
    
    func itemIsPressed(index: Int) {
        guard let article = newsCollection?.articles[index] else { return }
        router.showFullscreenNews(article: article)
    }
}


