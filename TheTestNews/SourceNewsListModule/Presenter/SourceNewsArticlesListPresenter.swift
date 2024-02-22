//
//  SourceNewsArticlesListPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 22.02.24.
//

import Foundation

protocol SourceNewsArticlesListPresenterProtocol: PresenterProtocol {
    var source: String { get }
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
        networkService.getNews(endpoint: endpoint) { [weak self] newsData in
            guard let news = newsData else { return }
            self?.newsCollection = news
            self?.view.success()
        }
    }
    
    func itemIsPressed(index: Int) {
        //
    }
}


