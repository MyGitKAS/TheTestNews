//
//  SourceNewsModel.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 20.02.24.
//

import Foundation

// MARK: - SourceNewsModel
struct SourceNewsModel: Codable {
    let status: String
    let sources: [Source]
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

