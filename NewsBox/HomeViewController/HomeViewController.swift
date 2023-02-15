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
    
    private var category = ["general", "business", "technology", "sports", "entertainment", "health", "science"]
    private var articles: [Article] = []
    private var networkManager = NetworkManager()
    
    private let layout = UICollectionViewFlowLayout()
    
    private var selectedCategory = ""
    private var selectedIndex = Int()
    private var currentPage = 1
    
    // MARK: - Subviews
    
    private var pullControl = UIRefreshControl()
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
        configurePullControl()
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
    
    func loadMoreData() {
        
        currentPage += 1
        
        networkManager.getPageData(page: currentPage) { [weak self] model in
            if let model = model {
                self?.articles += model.articles ?? []
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
        appIcon.image = UIImage(named: "logo_horizontal")
        appIcon.contentMode = .scaleAspectFit
    }
    
    private func configurePullControl() {
        pullControl.attributedTitle = NSAttributedString(string: "Loading News Data")
        pullControl.backgroundColor = .clear
        pullControl.tintColor = .black
        pullControl.addTarget(self, action: #selector(refreshNewsData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
        } else {
            tableView.addSubview(pullControl)
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = whiteMainColor
        tableView.separatorColor = mainTextBlackColor
        tableView.separatorStyle = .singleLine
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
    
    @objc private func refreshNewsData(_ sender: Any) {
        loadNewsByCategory()
        tableView.reloadData()
        self.pullControl.endRefreshing() // You can stop after API Call
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
        cell.selectionStyle = .none
        cell.menuButtonDidTap = {[weak self] in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let shareButton = UIAlertAction(title: "Share", style: .default) { share in
                let items: [Any] = ["Read this news immediately!", URL(string: article.self.url ?? "") as Any]
                let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(activityController, animated: true)
            }
            let boomarkButton = UIAlertAction(title: "Bookmark", style: .default) { bookmark in
                
                let context = CoreDataService.context
                context.perform {
                    let newsArticle = NewsArticle(context: context)
                    newsArticle.title = article.title
                    newsArticle.articleDescription = article.articleDescription
                    newsArticle.source = article.source?.name
                    newsArticle.urlToImage = article.urlToImage
                    CoreDataService.saveContext()
                }
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
            let image = UIImage(named: "share")
            let bookmark = UIImage(named: "bookmark_unselected")
            
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.addLoading(indexPath) {
            self.loadMoreData()
        }
        tableView.stopLoading()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        if selectedIndex == indexPath.row
        {
            cell.categoryLabel.backgroundColor = mainTextBlackColor
            cell.categoryLabel.textColor = whiteMainColor
        } else {
            cell.categoryLabel.backgroundColor = lightGreyTextColor
            cell.categoryLabel.textColor = categoryNameTextColor
        }
        
        let category = category[indexPath.row]
        cell.configureCell(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        selectedIndex = indexPath.row
        selectedCategory = category[indexPath.row]
        collectionView.reloadData()
        loadNewsByCategory()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96.0, height: 36.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}


extension UITableView {
    
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .gray
            }
            
            activityIndicatorView.color = .black
            activityIndicatorView.hidesWhenStopped = true
            
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }
    
    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
    }
    
    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        }
        else {
            self.tableFooterView = nil
        }
    }
}
