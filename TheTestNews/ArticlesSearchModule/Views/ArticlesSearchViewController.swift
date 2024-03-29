//
//  MainSourceViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 18.02.24.
//

import UIKit

protocol ArticlesSearchViewControllerProtocol: ViewControllerProtocol {}

class ArticlesSearchViewController: UIViewController {
  
    var presenter: ArticlesSearchViewPresenterProtocol!
    
    private let topSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Top Headlines", "Search", "Category"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = Constants.mainColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return segmentedControl
    }()

    private lazy var bottomSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Constants.categoryNews.map{$0.rawValue})
        segmentedControl.addTarget(self, action: #selector(bottomSegmentedControlValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = Constants.mainColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return segmentedControl
    }()
    
   private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 33)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Top Headlines"
        return label
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 4, bottom: 0, right: 4)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let screenWidth = UIScreen.main.bounds.width
        layout.estimatedItemSize = CGSize(width: screenWidth - 20, height: 400)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ArticlesSearchCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupConstraints()
    }
    
    private func setupConfiguration() {
        view.addSubview(topSegmentedControl)
        view.addSubview(bottomSegmentedControl)
        view.addSubview(searchBar)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        bottomSegmentedControl.isHidden = true
        searchBar.isHidden = true
        searchBar.delegate = self
        self.navigationItem.title = "Search your News"
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            titleLabel.isHidden = false
            searchBar.isHidden = true
            bottomSegmentedControl.isHidden = true
            presenter.getData(endpoint: .topHeadLines(country: .us))
        case 1:
            titleLabel.isHidden = true
            searchBar.isHidden = false
            bottomSegmentedControl.isHidden = true
            presenter.newsCollection = nil
            searchBar.endEditing(true)
            searchBar.text = ""
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case 2:
            titleLabel.isHidden = true
            searchBar.isHidden = true
            bottomSegmentedControl.isHidden = false
            if bottomSegmentedControl.selectedSegmentIndex == -1 {
                DispatchQueue.main.async { [weak self] in
                    self?.presenter.newsCollection = nil
                    self?.collectionView.reloadData()
                }
            } else {
                let category = Constants.categoryNews[bottomSegmentedControl.selectedSegmentIndex]
                DispatchQueue.main.async { [weak self] in
                    self?.presenter.getCategoryNews(category: category)
                    self?.collectionView.reloadData()
                }
            }
        default:
            break
        }
    }
    
    @objc func bottomSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let category = Constants.categoryNews[sender.selectedSegmentIndex]
        presenter.getCategoryNews(category: category)
    }
}

extension ArticlesSearchViewController: ArticlesSearchViewControllerProtocol {
    func present(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func success() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ArticlesSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.newsCollection?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ArticlesSearchCollectionViewCell
        guard let news = presenter.newsCollection else { return cell }
        let article = news.articles[indexPath.row]
        presenter.getImage(index: indexPath.row) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        cell.titleLabel.text = article.title
        cell.leftLabel.text = article.source.name
        cell.rightLabel.text = article.formattedDate()
        cell.buttonTapAction = { [weak self] in self?.presenter.itemIsPressed(index: indexPath.row)}
        cell.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        return cell
    }
}

extension ArticlesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.getSearchNews(text: searchText)
    }
}

extension ArticlesSearchViewController {
    
    private func setupConstraints() {
        topSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            topSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        bottomSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSegmentedControl.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 10),
            bottomSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            bottomSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

