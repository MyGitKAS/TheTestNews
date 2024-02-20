//
//  MainSourceViewPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 19.02.24.
//
import Foundation

protocol ArticlesSearchViewPresenterProtocol: PresenterProtocol {
    func getSearchNews(text: String)
    func getCategoryNews(category: Category)
}

class ArticlesSearchViewPresenter: ArticlesSearchViewPresenterProtocol {
    
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
    
    func getSearchNews(text: String) {
        if text == "" {
            newsCollection = nil
            view.success()
        }
        let endpoint = Endpoint.search(searchFilter: text)
        getNews(endpoint: endpoint)
    }
    
    func getCategoryNews(category: Category) {
        let endpoint = Endpoint.articlesFromCategory(category)
        getNews(endpoint: endpoint)
    }
    
}