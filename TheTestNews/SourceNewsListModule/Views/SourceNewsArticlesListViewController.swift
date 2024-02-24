//
//  SourceNewsListViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 21.02.24.
//

import UIKit

protocol SourceNewsArticlesListViewController: ViewControllerProtocol {}

class SourceNewsArticlesViewController: UIViewController {

    var presenter: SourceNewsArticlesListPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let cellWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: cellWidth - 20, height: 120)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SourceNewsArticlesListCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupConstraints()
    }
    
    private func setupConfiguration() {
        view.addSubview(collectionView)
        let sourceName = presenter.source
        self.navigationItem.title = "Article by \(sourceName)"
    }
}

extension SourceNewsArticlesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.newsCollection?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SourceNewsArticlesListCollectionViewCell
        guard let news = presenter.newsCollection else { return cell }
        let article = news.articles[indexPath.row]
        presenter.getImage(index: indexPath.row) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        cell.titleLabel.text = article.title
        cell.sourceLabel.text = article.source.name
        cell.dateLabel.text = article.formattedDate()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.itemIsPressed(index: indexPath.row)
    }
}

extension SourceNewsArticlesViewController: GeneralNewsViewProtocol {

    func present(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func success() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SourceNewsArticlesViewController {
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
