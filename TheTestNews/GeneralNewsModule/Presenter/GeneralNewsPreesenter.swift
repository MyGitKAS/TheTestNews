//
//  GeneralNewsPreesenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation
import UIKit

protocol GeneralNewsPresenterProtocol: PresenterProtocol {
    func reloadNews()
    func getImage(index: Int, completion: @escaping (UIImage?) -> Void) 
}

class GeneralNewsPresenter: GeneralNewsPresenterProtocol {

    var newsCollection: NewsModel?
    
    private var router: RouterProtocol!
    private weak var view: ViewControllerProtocol!
    private let networkService: NewsAPINetworkServiceProtocol!
    private let startEndpoint = Endpoint.topHeadLines(country: .us)
    
    required init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getData(endpoint: startEndpoint)
    }
    
    func getImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let url = newsCollection?.articles[index].urlToImage else {
            completion(UIImage(named: "test_image"))
            return
        }
        
        networkService.downloadImageWith(urlString: url) { image in
            if let image = image {
                let compressImage = Helper.compress(image: image)
                completion(compressImage)
            } else {
                completion(nil)
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
    
    func itemIsPressed(index: Int) {
        guard let article = newsCollection?.articles[index] else { return }
        router?.showFullscreenNews(article: article)
    }
    
    func reloadNews() {
        getData(endpoint: startEndpoint)
    }
}
