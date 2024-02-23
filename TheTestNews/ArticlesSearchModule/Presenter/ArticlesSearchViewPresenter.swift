//
//  MainSourceViewPresenter.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 19.02.24.
//
import Foundation
import SafariServices
import UIKit

protocol ArticlesSearchViewPresenterProtocol: PresenterProtocol {
    func getSearchNews(text: String)
    func getCategoryNews(category: Category)
    func getImage(index: Int, completion: @escaping (UIImage?) -> Void)
}

class ArticlesSearchViewPresenter: ArticlesSearchViewPresenterProtocol {
    
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
    
    func getSearchNews(text: String) {
        if text == "" {
            newsCollection = nil
            view.success()
        }
        let endpoint = Endpoint.search(searchFilter: text)
        getData(endpoint: endpoint)
    }
    
    func getCategoryNews(category: Category) {
        let endpoint = Endpoint.articlesFromCategory(category)
        getData(endpoint: endpoint)
    }
    
    func itemIsPressed(index: Int) {
        guard let stringUrl = newsCollection?.articles[index].url else { return }
        guard let url = URL(string: stringUrl) else { return }
        let safariViewController = SFSafariViewController(url: url)
        view.present(viewController: safariViewController)
    }
    
    func getImage(index: Int, completion: @escaping (UIImage?) -> Void) {
        guard let url = newsCollection?.articles[index].urlToImage else {
            completion(UIImage(named: "test_image"))
            return
        }
        networkService.downloadImageWith(urlString: url) { image in
            guard let image = image else { return }
           let compressImage =  Helper.compress(image: image)
            completion(compressImage)
        }
    }
}
