//
//  GeneralNewsPreesenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

protocol GeneralNewsPresenterProtocol: AnyObject {
    var mainNews: MainNewsModel? {get}
    func getNews()
    func newsItemPressed(index: Int)
    init(view: GeneralNewsViewProtocol)
}

class GeneralNewsPresenter: GeneralNewsPresenterProtocol {
    var mainNews: MainNewsModel?
    private let view: GeneralNewsViewProtocol!
    
    required init(view: GeneralNewsViewProtocol ) {
        self.view = view
        getNews()
    }
    
    func getNews() {
        let networkService = NewsAPINetworkService()
        networkService.parseNews { newsData in
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
