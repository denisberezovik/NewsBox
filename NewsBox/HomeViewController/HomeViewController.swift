//
//  HomeViewController.swift
//  NewsBox
//
//  Created by REEMOTTO on 11.01.23.
//

import UIKit
import SafariServices

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var category = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    private var articles: [Article] = []
    private var networkManager = NetworkManager()
    
    private let layout = UICollectionViewFlowLayout()
    
    private var selectedCategory = ""
    
    // MARK: - Subviews
    
    private let appIcon = UIImageView()
    private var tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = whiteMainColor
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Methods
    
    private func setup() {
        configureAppIcon()
        configureTableView()
        configureCollectionView()
        setTableViewDelegates()
        setCollectionViewDelegates()
        layoutSubviews()
        loadData()
    }
    
    func loadData() {
        networkManager.loadTopHeadlines { [weak self] news in
            if let news = news {
                self?.articles = news.articles ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func loadNewsByCategory() {
        networkManager.loadNewsByCathegory(with: selectedCategory) { [weak self] news in
            if let news = news {
                self?.articles = news.articles ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func configureAppIcon() {
        view.addSubview(appIcon)
        appIcon.image = UIImage(named: "logoHorizontal")
        appIcon.contentMode = .scaleAspectFit
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = whiteMainColor
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        layout.scrollDirection = .horizontal
        layout.collectionView?.showsHorizontalScrollIndicator = false
        layout.minimumLineSpacing = 5
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.clipsToBounds = false
    }
    
    private func setCollectionViewDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layoutSubviews() {
        
        appIcon.translatesAutoresizingMaskIntoConstraints = false
        appIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0).isActive = true
        appIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0).isActive = true
        appIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0).isActive = true
        appIcon.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: appIcon.bottomAnchor, constant: 20.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        let article = articles[indexPath.row]
        cell.configure(with: article)
        cell.menuButtonDidTap = {[weak self] in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let shareButton = UIAlertAction(title: "Share", style: .default) { share in
                let items: [Any] = ["Read this news immediately!", URL(string: article.self.url ?? "") as Any]
                let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(activityController, animated: true)
            }
            let boomarkButton = UIAlertAction(title: "Bookmark", style: .default)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            let image = UIImage(systemName: "square.and.arrow.up.fill")
            let bookmark = UIImage(named: "bookmark_selected")
            
            shareButton.setValue(UIColor.black, forKey: "titleTextColor")
            boomarkButton.setValue(UIColor.black, forKey: "titleTextColor")
            cancelButton.setValue(UIColor.black, forKey: "titleTextColor")
            shareButton.setValue(image?.withRenderingMode(.alwaysOriginal), forKey: "image")
            boomarkButton.setValue(bookmark?.withRenderingMode(.alwaysOriginal), forKey: "image")
            
            alert.addAction(shareButton)
            alert.addAction(boomarkButton)
            alert.addAction(cancelButton)
            self?.present(alert, animated: true)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else { return }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let category = category[indexPath.row]
        cell.configureCell(category: category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        selectedCategory = category[indexPath.row]
        loadNewsByCategory()
        print(selectedCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96.0, height: 36.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    
}
