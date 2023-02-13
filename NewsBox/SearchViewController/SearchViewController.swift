//
//  SearchViewController.swift
//  NewsBox
//
//  Created by REEMOTTO on 23.01.23.
//

import UIKit
import SafariServices

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private var articles: [Article] = []
    private var networkManager = NetworkManager()
    
    // MARK: - Subviews
    
    private var searchBar = UISearchController(searchResultsController: nil)
    private var tableView = UITableView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = whiteMainColor
        navigationItem.hidesSearchBarWhenScrolling = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.black], for: .normal)
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Methods
    
    private func setup() {
        createSearch()
        configureTableView()
        setTableViewDelegates()
        layoutSubviews()
    }
    
    private func createSearch() {
        navigationItem.searchController = searchBar
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.delegate = self
        searchBar.searchBar.showsCancelButton = false
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.searchTextField.clearButtonMode = .whileEditing
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        networkManager.getDataForSearch(with: text, completion: { [weak self] model in
            if let model = model {
                self?.articles = model.articles ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchBar.dismiss(animated: true, completion: nil)
                }
            }
        })
        print(text)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        let article = articles[indexPath.row]
        cell.configure(with: article)
        
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

// MARK: - UISearchBarDelegate, UISearchResultsUpdating

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    
}
