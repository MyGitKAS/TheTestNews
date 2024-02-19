//
//  MainSourceViewPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 19.02.24.
//

import Foundation

protocol MainSourceViewPresenterProtocol: PresenterProtocol {

}

class MainSourceViewPresenter: MainSourceViewPresenterProtocol {
    
    private let view: ViewControllerProtocol!
    private let networkService: NewsAPINetworkServiceProtocol!
    
    required init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func getNews() {
        networkService.getNews(endpoint: Endpoint.topHeadLines(country: .us)) { newsData in
            guard let news = newsData else { return }
        }
    }
    
}
