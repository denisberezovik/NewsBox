//
//  BookmarkViewController.swift
//  NewsBox
//
//  Created by REEMOTTO on 23.01.23.
//

import UIKit

final class BookmarkViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Subviews
    
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
        configureTableView()
        setTableViewDelegates()
        layoutSubviews()
        loadBookmark()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = whiteMainColor
        tableView.separatorColor = mainTextBlackColor
        tableView.separatorStyle = .singleLine
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    private func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layoutSubviews() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func loadBookmark() {
        let request = NewsArticle.fetchRequest()
        let newsArticles = try? CoreDataService.context.fetch(request)
        guard let article = newsArticles?.last else {return}
        articles.append(article)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
