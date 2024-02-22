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


