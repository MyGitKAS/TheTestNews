//
//  GeneralTableViewCell.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    let newsImageView = UIImageView()
    let sourceLabel = UILabel()
    let dateLabel = UILabel()
    let titleLabel =  UILabel()
    
    private let mainHStack = UIStackView()
    private let mainVStack = UIStackView()
    private let secondHstack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStack()
        setupConfiguration()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    private func setupConfiguration() {
        newsImageView.image = UIImage(named: "test_image")
        newsImageView.layer.cornerRadius = 10
        newsImageView.layer.masksToBounds = true
        
        titleLabel.numberOfLines = 4
        titleLabel.font = UIFont.systemFont(ofSize: TextSize.medium.getSize() , weight: .bold)
        dateLabel.font = UIFont.systemFont(ofSize: TextSize.small.getSize() , weight: .light)
        sourceLabel.font = UIFont.systemFont(ofSize: TextSize.small.getSize() , weight: .light)
    }

    private func setupStack() {
        addSubview(mainHStack)
        mainHStack.axis = .horizontal
        mainVStack.axis = .vertical
        
        secondHstack.axis = .horizontal
        secondHstack.addArrangedSubview(sourceLabel)
        secondHstack.addArrangedSubview(dateLabel)
        
        mainVStack.addArrangedSubview(titleLabel)
        mainVStack.addArrangedSubview(secondHstack)
        
        mainHStack.addArrangedSubview(newsImageView)
        mainHStack.addArrangedSubview(mainVStack)
        
    }
}
 
extension GeneralTableViewCell {
    private func setupConstraints() {
     
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsImageView.widthAnchor.constraint(equalToConstant: 130),
            newsImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: mainVStack.trailingAnchor, constant: -10),
        ])
        
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            mainHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            mainHStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor)
        ])
    }
}


