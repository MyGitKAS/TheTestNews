//
//  Constants.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit

struct Constants {
    static let mainColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    static let elementCornerRadius: CGFloat = 10
    static let categoryNews: [Category] = [.business, .sports, .technology, .science, .health ]
}

enum TextSize {
    case small
    case medium
    case large
    case extraLarge

    func getSize() -> CGFloat {
        switch self {
        case .small:
            return 10
        case .medium:
            return 14
        case .large:
            return 18
        case .extraLarge:
            return 25
        }
    }
}
