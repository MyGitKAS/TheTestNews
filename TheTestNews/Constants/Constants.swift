//
//  Constants.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit

struct Constants {
   static let mainColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
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
