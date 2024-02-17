//
//  FullScreenNewsViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 17.02.24.
//

import UIKit

class FullScreenNewsViewController: UIViewController {

    private var scrollView: UIScrollView!
    private var mainVStackView: UIStackView!
    private var dateHStackView: UIStackView!
    private var titleLabel: UILabel!
    private var sourceLabel: UILabel!
    private var dateLabel: UILabel!
    private var imageView: UIImageView!
    private var textLabel: UILabel!
    private var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupImageView()
        setupLabels()
        setupButton()
        setupConstraints()
    }
    
    private func setupConfiguration() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        scrollView = UIScrollView()
        mainVStackView = UIStackView()
        dateHStackView = UIStackView()
        imageView = UIImageView()
        titleLabel = UILabel()
        sourceLabel = UILabel()
        dateLabel = UILabel()
        textLabel = UILabel()
        
        dateHStackView.axis = .horizontal
        mainVStackView.axis = .vertical
        mainVStackView.spacing = 20
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainVStackView)
        mainVStackView.addArrangedSubview(titleLabel)
        dateHStackView.addArrangedSubview(sourceLabel)
        dateHStackView.addArrangedSubview(dateLabel)
        mainVStackView.addArrangedSubview(dateHStackView)
        mainVStackView.addArrangedSubview(imageView)
        mainVStackView.addArrangedSubview(textLabel)
    }
    
    private func setupImageView() {
        imageView.image = UIImage(named:"test_full_size")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }

    private func setupButton() {
        button = UIButton(type: .system)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        mainVStackView.addArrangedSubview(button)
        button.setTitle("Go to site", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Constants.mainColor.cgColor
        button.setTitleColor(Constants.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private func setupLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: TextSize.extraLarge.getSize() , weight: .bold)
        titleLabel.numberOfLines = 0
        sourceLabel.font = UIFont.systemFont(ofSize: TextSize.medium.getSize() , weight: .light)
        dateLabel.font = UIFont.systemFont(ofSize: TextSize.medium.getSize() , weight: .light)
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: TextSize.large.getSize() , weight: .medium)
    }
    
    func setValue(article: Article?) {
        guard let article = article else { return }
        
        Helper.downloadImageWith(url: article.urlToImage) { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
            self?.imageView.image = image
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = article.title
            self?.sourceLabel.text = article.source.name
            self?.textLabel.text = article.description 
            self?.dateLabel.text = article.publishedAt
        }
    }
    
    @objc func buttonTapped() {
        
    }
}

extension FullScreenNewsViewController {
    private func setupConstraints() {
        
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mainVStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            mainVStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            mainVStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            mainVStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            mainVStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20)
        ])
   

        dateHStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateHStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            dateHStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            dateHStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
}
