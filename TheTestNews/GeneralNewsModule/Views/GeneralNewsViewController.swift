//
//  MainTableView.swift
//  TheTestNews
//
//  Created by Aleksey Kuhlenkov on 16.02.24.
//

import UIKit

protocol GeneralNewsViewProtocol {
    func success()
    func present(viewController: UIViewController)
}

class GeneralNewsViewController: UIViewController, UINavigationControllerDelegate{
   
    var presenter: GeneralNewsPresenterProtocol!
    private let reloadDataButton = UIButton(type: .system)
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupActivityIndicator()
        setupTableView()
        setupReloadDataButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayoutReloadDataButton()
    }
    
    private func setupConfiguration() {
        navigationController?.delegate = self
        self.navigationItem.title = "Main Stream News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let imageItem = UIImage(systemName: "flame")
        let btn = UIBarButtonItem(image: imageItem, style: .plain, target: self, action: #selector(hotNewsButtonTapped(_:)))
        navigationItem.rightBarButtonItem = btn
    }
    
    
    private func setupActivityIndicator() {
        activityIndicator.color = Constants.mainColor
        activityIndicator.center = view.center
        tableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GeneralTableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    private func setupLayoutReloadDataButton() {
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        let buttonHeight: CGFloat = 44
        let buttonWidth: CGFloat = 150
        let centrX = (view.bounds.width / 2) - (buttonWidth / 2)
        reloadDataButton.frame = CGRect(x: centrX, y: view.bounds.height - tabBarHeight - buttonHeight - 20, width: buttonWidth, height: buttonHeight)
        reloadDataButton.layer.cornerRadius = buttonHeight / 2
    }
 
    private func setupReloadDataButton() {
        view.addSubview(reloadDataButton)
        reloadDataButton.setTitle("Reload Data", for: .normal)
        reloadDataButton.addTarget(self, action: #selector(refreshData(_:)), for: .touchUpInside)
        reloadDataButton.backgroundColor = .white
        reloadDataButton.layer.borderWidth = 1.0
        reloadDataButton.layer.borderColor = Constants.mainColor.cgColor
        reloadDataButton.setTitleColor(Constants.mainColor, for: .normal)
        reloadDataButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    @objc func refreshData(_ sender: UIButton) {
        guard let presenterTrue = presenter else { return }
        presenterTrue.getNews()
        activityIndicator.startAnimating()
    }
    
    @objc func hotNewsButtonTapped(_ sender: UIButton) {
   
    }
}

extension GeneralNewsViewController: GeneralNewsViewProtocol {
    func present(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func success() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}

extension GeneralNewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let newCell = cell as! GeneralTableViewCell
        guard let news = presenter.mainNews else { return }
        let oneNews = news.articles[indexPath.row]
        let Url = oneNews.urlToImage
        Helper.downloadImageWith(url: Url) { image in
            DispatchQueue.main.async {
                newCell.newsImageView.image = image
            }
        }
        newCell.titleLabel.text = oneNews.title
        newCell.sourceLabel.text = oneNews.source.name
        newCell.dateLabel.text = oneNews.publishedAt
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.newsItemPressed(index: indexPath.row)
        print(indexPath.row)
        }
}

extension GeneralNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.mainNews?.articles.count ?? 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GeneralTableViewCell()
        return cell
   }
}










