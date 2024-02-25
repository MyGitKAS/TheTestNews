//
//  NewsAPINetworkService.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation
import UIKit

protocol NewsAPINetworkServiceProtocol {
    func getNews(endpoint: Endpoint, completion: @escaping (Result<NewsModel?, Error>) -> Void)
    func getSource(endpoint: Endpoint, completion: @escaping (Result<SourceNewsModel?, Error>) -> Void)
    func downloadImageWith(urlString: String?, completion: @escaping (UIImage?) -> Void)
}

final class NewsAPINetworkService : NewsAPINetworkServiceProtocol {

    //let key = "7a00d18dc6ed44ee962c34da384eea7b"
    let key = "97b2b8348ab347aab26fbcb60bfec2cf"
    
    func getNews(endpoint: Endpoint, completion: @escaping (Result<NewsModel?, Error>) -> Void) {
        guard let url = URL(string: "\(endpoint.baseURL)\(endpoint.path())apiKey=\(key)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        fetch(url) { (result: Result<NewsModel, Error>) in
            switch result {
            case .success(let newsModel):
                completion(.success(newsModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSource(endpoint: Endpoint, completion: @escaping (Result<SourceNewsModel?, Error>) -> Void) {
        guard let url = URL(string: "\(endpoint.baseURL)\(endpoint.path())apiKey=\(key)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        fetch(url) { (result: Result<SourceNewsModel, Error>) in
            switch result {
            case .success(let sourceNewsModel):
                completion(.success(sourceNewsModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImageWith(urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let stringUrl = urlString, let url = URL(string: stringUrl) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    private func fetch<T: Codable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noDataReceived))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let fetchedData = try decoder.decode(T.self, from: data)
                completion(.success(fetchedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noDataReceived
    case unableToCreateImage
}

enum Endpoint {
    case topHeadLines(country: CountryForEndpoint)
    case articlesFromCategory(_ category: Category)
    case search (searchFilter: String)
    case sources (country: String)
    case articlesFromSource(_ source: String)
    
    var baseURL:URL {URL(string: "https://newsapi.org/v2/")!}
    
    func path() -> String {
        switch self {
        case .topHeadLines(let country):
            return "top-headlines?\(country.description)"
        case .articlesFromCategory(let category):
            return "top-headlines?category=\(category.rawValue)&"
        case .search(let q):
            return "everything?q=\(q)&"
        case .articlesFromSource(let source):
            return "top-headlines?sources=\(source)&"
        case .sources(let country):
            return "top-headlines/sources?country=\(country)&"
        }
    }
}

enum CountryForEndpoint {
    case us
    case ru
    
    var description: String {
        switch self {
        case .us:
            return "country=us&"
        case .ru:
            return "country=ru&"
        }
    }
}





