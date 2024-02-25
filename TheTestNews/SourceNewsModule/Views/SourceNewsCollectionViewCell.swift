//
//  SourceNewsCollectionViewCell.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 20.02.24.
//
import UIKit

class SourceNewsCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: TextSize.medium.getSize() , weight: .bold)
        label.numberOfLines = 4
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: TextSize.small.getSize() , weight: .light)
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.elementCornerRadius
        imageView.frame.size = CGSize(width: 70, height: 70)
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named:"test_image")
        return imageView
    }()
    
    let sourceNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: TextSize.extraLarge.getSize() , weight: .light)
        return label
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
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: Constants.elementCornerRadius).cgPath
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(sourceLabel)
        imageView.addSubview(sourceNameLabel)
        addSubview(stackView)
        sourceNameLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
        sourceNameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
        sourceNameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
       ])
    }
}

extension SourceNewsCollectionViewCell {
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
