//
//  MainSourceViewController.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 18.02.24.
//

import UIKit
protocol MainSourceViewControllerProtocol: ViewControllerProtocol {}

class MainSourceViewController: UIViewController {
  
    var presenter: PresenterProtocol!
    
    private let topSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Top Headlines", "Search", "Category"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let bottomSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Constants.newsCategory)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 33)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Top Headlines"
        return label
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let cellWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: cellWidth - 20, height: 400)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainSourceCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topSegmentedControl)
        view.addSubview(bottomSegmentedControl)
        view.addSubview(searchBar)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        bottomSegmentedControl.isHidden = true
        searchBar.isHidden = true
        setupConstraints()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            titleLabel.isHidden = false
            searchBar.isHidden = true
            bottomSegmentedControl.isHidden = true
        case 1:
            titleLabel.isHidden = true
            searchBar.isHidden = false
            bottomSegmentedControl.isHidden = true
        case 2:
            titleLabel.isHidden = true
            searchBar.isHidden = true
            bottomSegmentedControl.isHidden = false
        default:
            break
        }
    }
}

extension MainSourceViewController: MainSourceViewControllerProtocol {
    func success() {
        //
    }
    
    func present(viewController: UIViewController) {
        //
    }
    
 
}

extension MainSourceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainSourceCollectionViewCell
        return cell
    }
}

extension MainSourceViewController {
    
    private func setupConstraints() {
        topSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        bottomSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSegmentedControl.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 10),
            bottomSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

