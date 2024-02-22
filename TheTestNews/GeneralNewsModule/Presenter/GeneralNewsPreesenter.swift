//
//  GeneralNewsPreesenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

protocol GeneralNewsPresenterProtocol: PresenterProtocol {
    func reloadNews()
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
    
    func getData(endpoint: Endpoint) {
        networkService.getNews(endpoint: endpoint) { [weak self] newsData in
            guard let news = newsData else { return }
            self?.newsCollection = news
            self?.view.success()
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
