//
//  NewsTableViewCell.swift
//  NewsBox
//
//  Created by REEMOTTO on 11.01.23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static var identifier = "NewsTableViewCell"
    var menuButtonDidTap: (() -> ())?
    
    // MARK: - Subviews
    
    let newsImageView = UIImageView()
    let newsTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    let sourceLabel = UILabel()
    let menuButton = UIButton()
    let aIndicator = UIActivityIndicatorView.init(style: .medium)
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")}
    
    // MARK: - Methods
    
    private func setup() {
        configureSubviews()
        buildHierarchy()
        layoutSubviews()
    }
    
    func configureSubviews() {
        
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.adjustsFontSizeToFitWidth = true
        newsTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        newsTitleLabel.textColor = mainTextBlackColor
        
        descriptionLabel.textColor = mainTextBlackColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        
        aIndicator.color = .black
        
        newsImageView.clipsToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        
        sourceLabel.numberOfLines = 0
        sourceLabel.adjustsFontSizeToFitWidth = true
        sourceLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        sourceLabel.textColor = .gray
        
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonDidTapped), for: .touchUpInside)
    }
    
    func buildHierarchy() {
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(menuButton)
        contentView.addSubview(aIndicator)
    }
    
    func configure(with model: Article) {
        self.newsTitleLabel.textColor = .black
        self.descriptionLabel.textColor = .black
        
        self.newsTitleLabel.text = model.title
        self.descriptionLabel.text = model.articleDescription
        self.sourceLabel.text = model.source?.name
        
        self.newsImageView.downloadImageFrom(model.urlToImage)
        //        downloaded(from: model.urlToImage ?? "")
    }
    
        override func prepareForReuse() {
            super.prepareForReuse()
            newsTitleLabel.text = nil
            descriptionLabel.text = nil
            sourceLabel.text = nil
            newsImageView.image = nil
        }
    
    override func layoutSubviews() {
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        newsImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10).isActive = true
        newsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        sourceLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 10).isActive = true
        sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5).isActive = true
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        menuButton.leadingAnchor.constraint(equalTo: sourceLabel.trailingAnchor, constant: 10).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        menuButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5).isActive = true
        
        aIndicator.translatesAutoresizingMaskIntoConstraints = false
        aIndicator.centerXAnchor.constraint(equalTo: newsImageView.centerXAnchor).isActive = true
        aIndicator.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor).isActive = true
        
    }
    
    
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
//        aIndicator.startAnimating()
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//            else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.newsImageView.image = image
//                self?.aIndicator.stopAnimating()
//            }
//        }.resume()
//    }
    
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
    
    @objc func menuButtonDidTapped() {
        print("Menu tapped")
        menuButtonDidTap?()
    }
}

