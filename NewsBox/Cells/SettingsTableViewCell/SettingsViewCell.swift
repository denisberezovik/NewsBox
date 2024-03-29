//
//  SettingsViewCell.swift
//  NewsBox
//
//  Created by REEMOTTO on 14.02.23.
//

import UIKit

class SettingsViewCell: UITableViewCell {
    
    // MARK: - Properties

    static var identifier = "SettingsViewCell"
    
    
    // MARK: - Subviews


    var titleLabel = UILabel()
    var feedBackButton = UIButton()
    var icon = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(icon)
        addSubview(titleLabel)
        
        configureLabel()
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configureLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        icon.contentMode = .scaleAspectFit
        icon.sizeToFit()
    }
    
    func set(cell: SettingsModel) {
        titleLabel.text = cell.title
        icon.image = cell.icon
    }

    func setLabelConstraints() {
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
