//
//  GeneralNewsPreesenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

protocol GeneralNewsPresenterProtocol: PresenterProtocol {
    
}

class GeneralNewsPresenter: GeneralNewsPresenterProtocol {

    var newsCollection: NewsModel?

    private let view: ViewControllerProtocol!
    private let networkService: NewsAPINetworkServiceProtocol!
    private let startEndpoint = Endpoint.topHeadLines(country: .us)
    
    required init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getNews(endpoint: startEndpoint)
    }
    
    func getNews(endpoint: Endpoint) {
        networkService.getNews(endpoint: endpoint) { [weak self] newsData in
            guard let news = newsData else { return }
            self?.newsCollection = news
            self?.view.success()
        }
    }
    
    func newsItemPressed(index: Int) {
        let vc = FullScreenNewsViewController()
        let article = newsCollection?.articles[index]
        vc.setValue(article: article)
        view.present(viewController: vc)
    }
}
