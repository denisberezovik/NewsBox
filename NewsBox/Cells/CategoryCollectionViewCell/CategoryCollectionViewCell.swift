//
//  CategoryCollectionViewCell.swift
//  NewsBox
//
//  Created by REEMOTTO on 25.01.23.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var identifier = "CategoryCollectionViewCell"
        
    // MARK: - Subviews
    
    let categoryLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")}
    
    // MARK: - Methods
    
    func configureSubviews() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 15.0
        
        addSubview(categoryLabel)
        
        categoryLabel.textAlignment = .center
        categoryLabel.font = .systemFont(ofSize: 14.0)
        categoryLabel.adjustsFontSizeToFitWidth = true
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func configureCell(category: String) {
        self.categoryLabel.text = category
        
    }
    
}
