//
//  NewsAPINetworkService.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

protocol NewsAPINetworkServiceProtocol {
    func getNews(endpoint: Endpoint, completion: @escaping (MainNewsModel?) -> Void)
}

final class NewsAPINetworkService : NewsAPINetworkServiceProtocol {

    let key = "7a00d18dc6ed44ee962c34da384eea7b"
   
    func getNews(endpoint: Endpoint, completion: @escaping (MainNewsModel?) -> Void) {
        guard let url = URL(string: "\(endpoint.baseURL)\(endpoint.path())apiKey=\(key)") else {
            completion(nil)
            print("Invalid URL")
            return
        }
       fetch(url, completion: completion)
    }
    
    private func fetch(_ url: URL, completion: @escaping (MainNewsModel?) -> Void) {
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
                let newsResponse = try decoder.decode(MainNewsModel.self, from: data)
                completion(newsResponse)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}

enum Endpoint {
    case topHeadLines(country: CountryNews)
    case articlesFromCategory(_ category: CategoryNews)
    case search (searchFilter: String)
    case sources (country: String)
    case articlesFromSource(_ source: String)
    
    var baseURL:URL {URL(string: "https://newsapi.org/v2/")!}
    
    func path() -> String {
        switch self {
        case .topHeadLines(let country):
            return "top-headlines?\(country.description)"
        case .articlesFromCategory(let category):
            return "top-headlines?category=\(category.description)&"
        case .search(let q):
            return "everything?q=\(q)&"
        case .articlesFromSource:
            return "everything"
        case .sources:
            return "top-headlines/sources?"
        }
    }
}

enum CountryNews {
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

enum CategoryNews: CustomStringConvertible {
    case non
    case general
    case health
    case science
    case sports
    case technology
    case business
    case entertainment
    
    var description: String {
        switch self {
        case .non:
            return ""
        case .general:
            return "general"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .technology:
            return "technology"
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
        }
    }
}



