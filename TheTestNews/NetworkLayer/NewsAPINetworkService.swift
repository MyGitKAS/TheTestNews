//
//  NewsAPINetworkService.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

protocol NewsAPINetworkServiceProtocol {
    func getNews(endpoint: Endpoint, completion: @escaping (NewsModel?) -> Void)
    func getSource(endpoint: Endpoint, completion: @escaping (SourceNewsModel?) -> Void)
}

final class NewsAPINetworkService : NewsAPINetworkServiceProtocol {

    //let key = "7a00d18dc6ed44ee962c34da384eea7b"
    let key = "97b2b8348ab347aab26fbcb60bfec2cf"
    
    let endpoint22 = Endpoint.sources(country: "us")
    func getNews(endpoint: Endpoint, completion: @escaping (NewsModel?) -> Void) {
        guard let url = URL(string: "\(endpoint.baseURL)\(endpoint.path())apiKey=\(key)") else {
            completion(nil)
            print("Invalid URL")
            return
        }
        fetch(url, completion: completion)
    }
    
    func getSource(endpoint: Endpoint, completion: @escaping (SourceNewsModel?) -> Void) {
        guard let url = URL(string: "\(endpoint.baseURL)\(endpoint.path())apiKey=\(key)") else {
            completion(nil)
            print("Invalid URL")
            return
        }
       fetch(url, completion: completion)
    }
    
    private func fetch<T: Codable>(_ url: URL, completion: @escaping (T?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let fetchedData = try decoder.decode(T.self, from: data)
                completion(fetchedData)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
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
        case .articlesFromSource:
            return "everything"
        case .sources:
            return "top-headlines/sources?"
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





