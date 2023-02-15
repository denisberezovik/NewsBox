//
//  BookmarkViewController.swift
//  NewsBox
//
//  Created by REEMOTTO on 23.01.23.
//

import UIKit
import CoreData

final class BookmarkViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Subviews
    
    private var bookmarkLabel = UILabel()
    private var tableView = UITableView()
    private var articles: [NewsArticle] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = whiteMainColor
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadBookmark()
    }
    
    private func setup() {
        configureBookmarkLabel()
        configureTableView()
        setTableViewDelegates()
        layoutSubviews()
    }
    
    private func configureBookmarkLabel() {
        view.addSubview(bookmarkLabel)
        bookmarkLabel.text = "Bookmarked"
        bookmarkLabel.textColor = mainTextBlackColor
        bookmarkLabel.font = .boldSystemFont(ofSize: 18.0)
        bookmarkLabel.textAlignment = .left
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = whiteMainColor
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    private func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layoutSubviews() {
        
        bookmarkLabel.translatesAutoresizingMaskIntoConstraints = false
        bookmarkLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        bookmarkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        bookmarkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        bookmarkLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: bookmarkLabel.bottomAnchor, constant: 20.0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func loadBookmark() {
        let request = NewsArticle.fetchRequest()
        let newsArticles = try? CoreDataService.context.fetch(request)
        articles = newsArticles ?? []
//        articles.append(article)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        let article = articles[indexPath.row]
        cell.newsTitleLabel.text = article.title
        cell.descriptionLabel.text = article.articleDescription
        cell.sourceLabel.text = article.source
        cell.newsImageView.downloadImageFrom(article.urlToImage)
        cell.selectionStyle = .none
        
        cell.menuButtonDidTap = {[weak self] in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let shareButton = UIAlertAction(title: "Share", style: .default) { share in
                let items: [Any] = ["Read this news immediately!", URL(string: article.self.url ?? "") as Any]
                let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(activityController, animated: true)
            }
            let boomarkButton = UIAlertAction(title: "Remove bookmark", style: .default) { bookmark in
                
                let context = CoreDataService.context
                guard let newsArticle = self?.articles[indexPath.row] else {return}
                
                context.delete(newsArticle)
                self?.articles.remove(at: indexPath.row)
                CoreDataService.saveContext()
                self?.tableView.reloadData()
                
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
    
}
