//
//  ConditionViewController.swift
//  NewsBox
//
//  Created by REEMOTTO on 14.02.23.
//

import UIKit

final class ConditionViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Subviews
    
    let textView = UITextView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = whiteMainColor
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        self.navigationController?.navigationBar.tintColor = mainTextBlackColor
        setup()
    }
    
    private func setup() {
        buildHierarchy()
        configureSubviews()
        layoutSubviews()
    }
    
    private func buildHierarchy() {
        view.addSubview(textView)
    }
    
    private func configureSubviews() {
        
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mattis quis venenatis, diam leo. Sed bibendum ac dui condimentum consequat tempus vel sit. Lectus sit tristique in nullam vitae sed feugiat. Aliquet diam elit mus viverra. Neque, molestie morbi cursus amet pellentesque aenean posuere nascetur. Eu risus id ultricies est. Ac, faucibus pellentesque ullamcorper amet diam varius interdum. Sit in vitae semper egestas sed posuere tellus nisl diam. Ipsum, nisl aenean fusce a, ut cras varius et. Enim egestas tempus velit molestie odio in aliquet. Orci gravida ac faucibus et eu phasellus elit, tellus. Dictum lacinia massa in amet elit. Felis magna et dis adipiscing porttitor sed. Fringilla ante lacus fermentum, ultricies volutpat neque, aliquet. Cras leo, porttitor tellus mi in. Nec volutpat in sed consequat pharetra tristique pulvinar sit. Id commodo tristique tellus in fringilla scelerisque mauris. Mauris quam euismod sit viverra a dictumst arcu sed laoreet. Volutpat bibendum amet diam semper. Nunc tellus eu auctor tellus vivamus a. Euismod orci, ut consequat consectetur praesent quis euismod id. Ornare quis arcu eget aliquet pretium. Viverra nulla fringilla eget nibh habitasse cras vestibulum amet. Dui luctus dictum leo vulputate tristique lacus. Facilisis facilisi ullamcorper et vitae. Diam molestie sit laoreet lacinia ultrices. Convallis et ipsum quis consectetur sed. Quisque libero lectus quam in leo tincidunt. Venenatis id sodales pellentesque aliquet nibh egestas suspendisse nibh. Hendrerit non mauris, magna malesuada venenatis, eu. Enim, sed metus porttitor amet tortor neque sed."
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 16)
        textView.isSelectable = true
        
    }
    
    private func layoutSubviews() {
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
