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
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id, name, description: String?
    let url: String?
    let category: Category?
    let language, country: String?
}
