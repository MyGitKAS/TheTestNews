//
//  SourceNewsViewPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 20.02.24.
//

import Foundation


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
        networkService.getSource(endpoint: endpoint) { [weak self] sourceData in
            guard let source = sourceData else { return }
            self?.sourceCollection = source
            self?.view.success()
        }
    }
    
    func getData(endpoint: Endpoint) {
        networkService.getNews(endpoint: endpoint) { [weak self] newsData in
            guard let news = newsData else { return }
            self?.newsCollection = news
            self?.view.success()
        }
    }
    
    func itemIsPressed(index: Int) {
        guard let source = sourceCollection?.sources[index].name else { return }
        router?.showSourceNewsArticles(source: source)
    }
}
