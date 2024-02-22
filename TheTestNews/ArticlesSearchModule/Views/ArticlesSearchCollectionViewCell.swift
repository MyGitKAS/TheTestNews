//
//  MainSourceCollectionViewCell.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 19.02.24.
//

import UIKit

class ArticlesSearchCollectionViewCell: UICollectionViewCell {
    
    var buttonTapAction: (()-> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TextSize.large.getSize() , weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TextSize.small.getSize() , weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TextSize.small.getSize() , weight: .light)
        label.textAlignment = .right
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .redraw
        return imageView
    }()
    
    private let goSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show news on website", for: .normal)
        button.addTarget(self, action: #selector(goSiteButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Constants.mainColor.cgColor
        button.layer.cornerRadius = 20
        button.setTitleColor(Constants.mainColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfiguration()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfiguration() {
        self.layer.cornerRadius = Constants.elementCornerRadius
        self.backgroundColor = .white
        stackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(leftLabel)
        horizontalStackView.addArrangedSubview(rightLabel)
        stackView.addArrangedSubview(horizontalStackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(goSiteButton)
        addSubview(stackView)
    }
    
    @objc func goSiteButtonTapped(_ button: UIButton) {
        buttonTapAction?()
        print("PRESSSSSSSSS")
    }
}

extension ArticlesSearchCollectionViewCell {
    
    private func setupConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
     
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        goSiteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        goSiteButton.widthAnchor.constraint(equalToConstant: screenWidth - 40).isActive = true
       
    }
}
