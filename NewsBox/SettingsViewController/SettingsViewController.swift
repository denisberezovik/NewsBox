//
//  SettingsViewController.swift
//  NewsBox
//
//  Created by REEMOTTO on 14.02.23.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var tableArray = SettingsModel.mocks()
    
    // MARK: - Subviews
    
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = whiteMainColor
        setup()
    }
    
    // MARK: -  Methods
    
    private func setup() {
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 40
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: SettingsViewCell.identifier)
        tableView.pin(to:view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Handlers
    
}
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsViewCell.identifier, for: indexPath) as! SettingsViewCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        let table = tableArray[indexPath.row]
        cell.set(cell: table)
        
        return cell
        
    }
}
        
        extension UIView {
            func pin(to superView: UIView) {
                translatesAutoresizingMaskIntoConstraints = false
                topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
                leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
                trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
                bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
            }
        }
