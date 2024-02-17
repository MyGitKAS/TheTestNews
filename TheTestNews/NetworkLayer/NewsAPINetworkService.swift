//
//  NewsAPINetworkService.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

protocol NewsAPINetworkServiceProtocol {
    
}

final class NewsAPINetworkService : NewsAPINetworkServiceProtocol {
    
    let key = "7a00d18dc6ed44ee962c34da384eea7b"
    let apiUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=7a00d18dc6ed44ee962c34da384eea7b"
    
    func parseNews(completion: @escaping (MainNewsModel?) -> Void) {
        guard let url = URL(string: apiUrl) else {
            completion(nil)
            print("Invalid URL")
            return
        }
        
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
