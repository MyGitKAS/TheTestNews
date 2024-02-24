//
//  MainTableView.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//
import UIKit

protocol GeneralNewsViewProtocol: ViewControllerProtocol {}

class GeneralNewsViewController: UIViewController {

    var presenter: GeneralNewsPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let cellWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: cellWidth - 20, height: 120)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GeneralCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Constants.mainColor
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        presenter.reloadNews()
    }
    
    private func setupConfiguration() {
        view.addSubview(collectionView)
        collectionView.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        self.navigationItem.title = "Main Stream News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension GeneralNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.newsCollection?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GeneralCollectionViewCell
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

extension GeneralNewsViewController: GeneralNewsViewProtocol {
    func present(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func success() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}

extension GeneralNewsViewController {
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
