//
//  MainNewsModel.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import Foundation

// MARK: - SourceNewsModel
struct NewsModel: Codable {
    let status: String?
    let totalResults: Double?
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?

    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yy HH:mm"
        
        if let date = publishedAt {
            return dateFormatter.string(from: date)
        } else {
            return "Unknow date"
        }
    }
}

// MARK: - Source
struct Source: Codable {
    let id, name, description: String?
    let url: String?
    let category: Category?
    let language, country: String?
}

// MARK: - Category
enum Category: String, Codable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}
