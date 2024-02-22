//
//  FullScreenNewsViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 17.02.24.
//

import UIKit

protocol FullScreenNewsViewControllerProtocol: AnyObject {
    func setData()
    func present(viewController: UIViewController)
}

class FullScreenNewsViewController: UIViewController , FullScreenNewsViewControllerProtocol {

    var presenter: FullScreenNewsViewPresenterProtocol!
    
    private var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private var horisontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TextSize.extraLarge.getSize() , weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TextSize.medium.getSize() , weight: .light)
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TextSize.medium.getSize() , weight: .light)
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = Constants.elementCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: TextSize.large.getSize() , weight: .medium)
        return label
    }()
    
    private var goSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(goSiteButtonTapped), for: .touchUpInside)
        button.setTitle("Show news on website", for: .normal)
        button.layer.cornerRadius = Constants.elementCornerRadius
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Constants.mainColor.cgColor
        button.setTitleColor(Constants.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupConstraints()
    }
    
    private func setupConfiguration() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(titleLabel)
        horisontalStack.addArrangedSubview(sourceLabel)
        horisontalStack.addArrangedSubview(dateLabel)
        verticalStack.addArrangedSubview(horisontalStack)
        verticalStack.addArrangedSubview(imageView)
        verticalStack.addArrangedSubview(textLabel)
        verticalStack.addArrangedSubview(goSiteButton)
    }
    
    func setData() {
        DispatchQueue.main.async { [self] in
        self.titleLabel.text = self.presenter.article?.title
        self.sourceLabel.text = presenter.article?.source.name
        self.textLabel.text = presenter.article?.description
        self.dateLabel.text = presenter.article?.publishedAt
        }
    }
    
    func present(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func goSiteButtonTapped(_ button: UIButton) {
        presenter.goSiteButtonTapped()
    }
}

extension FullScreenNewsViewController {
    private func setupConstraints() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            verticalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            verticalStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            verticalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])
   

        horisontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horisontalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            horisontalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            horisontalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
        
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
}
