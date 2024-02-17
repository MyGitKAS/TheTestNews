//
//  ModuleBuilder.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//
import UIKit

protocol Builder {
    static func createMain() -> UIViewController
    static func createGeneralNews() -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createMain() -> UIViewController {
        let view = MainViewController()
        return view
    }
    
    static func createGeneralNews() -> UIViewController {
        let view = GeneralNewsViewController()
        let presenter = GeneralNewsPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
