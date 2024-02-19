//
//  GeneralNewsPreesenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

protocol GeneralNewsPresenterProtocol: PresenterProtocol {
    var mainNews: MainNewsModel? { get }
    func newsItemPressed(index: Int)
}

class GeneralNewsPresenter: GeneralNewsPresenterProtocol {

    var mainNews: MainNewsModel?
    private let view: ViewControllerProtocol!
    private let networkService: NewsAPINetworkServiceProtocol!
    
    required init(view: ViewControllerProtocol, networkService: NewsAPINetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        getNews()
    }
    
    func getNews() {
        networkService.getNews(endpoint: Endpoint.topHeadLines(country: .us)) { newsData in
            guard let news = newsData else { return }
            self.mainNews = news
            self.view.success()
        }
    }
    
    func newsItemPressed(index: Int) {
        let vc = FullScreenNewsViewController()
        let oneNews = mainNews?.articles[index]
        vc.setValue(article: oneNews)
        view.present(viewController: vc)
    }
}
