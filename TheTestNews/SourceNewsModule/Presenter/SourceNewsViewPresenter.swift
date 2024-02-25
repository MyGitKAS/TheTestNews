//
//  SourceNewsViewPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 20.02.24.
//

import Foundation
import UIKit


protocol SourceNewsViewPresenterProtocol: PresenterProtocol {
    func getSourceNews(endpoint: Endpoint)
    var sourceCollection: SourceNewsModel? { get }
}

class SourceNewsViewPresenter: SourceNewsViewPresenterProtocol{

    var sourceCollection: SourceNewsModel?
    var newsCollection: NewsModel?
    
    private var router: RouterProtocol!
    private weak var view: ViewControllerProtocol!
    private let networkService: NewsAPINetworkServiceProtocol!
    private let startSourceEndpoint = Endpoint.sources(country: "us")
    
    required init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getSourceNews(endpoint: startSourceEndpoint)
    }
    
    func getSourceNews(endpoint: Endpoint) {
        networkService.getSource(endpoint: endpoint) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let source):
                        self?.sourceCollection = source
                        self?.view.success()
                    case .failure(let error):
                        let alertController = ModuleBuilder.createErrorAlert(message: error.localizedDescription)
                        self?.view.present(viewController: alertController)
                }
            }
        }
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
        guard let url = newsCollection?.articles[index].source.url else {
            completion(UIImage(named: "test_image"))
            return
        }
        networkService.downloadImageWith(urlString: url) { image in
            guard let image = image else { return }
            let compressImage =  Helper.resizeImage(image, to: CGSize(width: 80, height: 80))
            completion(compressImage)
        }
    }
    
    func itemIsPressed(index: Int) {
        guard let source = sourceCollection?.sources[index].name else { return }
        router?.showSourceNewsArticles(source: source)
    }
}
