//
//  SourceNewsViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 20.02.24.
//

import UIKit

protocol SourceNewsViewControllerProtocol: ViewControllerProtocol {
    
}

class SourceNewsViewController: UIViewController, UINavigationControllerDelegate {

    var presenter: SourceNewsViewPresenter!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let cellWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: cellWidth - 20, height: 90)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SourceNewsCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupConstraints()
    }
 
    private func setupConfiguration() {
        view.addSubview(collectionView)
        navigationController?.delegate = self
        self.navigationItem.title = "Choose News Source"
    }
}

extension SourceNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.sourceCollection?.sources.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SourceNewsCollectionViewCell
        guard let sources = presenter?.sourceCollection else { return cell }
        let source = sources.sources[indexPath.row]
        cell.titleLabel.text = source.name
        cell.sourceLabel.text = source.description
        cell.imageView.image = UIImage(named: "test_image")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.itemIsPressed(index: indexPath.row)
    }
}

extension SourceNewsViewController: SourceNewsViewControllerProtocol {

    func present(viewController: UIViewController) {
    }

    func success() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SourceNewsViewController {
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


