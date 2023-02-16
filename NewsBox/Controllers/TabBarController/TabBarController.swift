//
//  TabBarController.swift
//  NewsBox
//
//  Created by REEMOTTO on 24.01.23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        generateTabBar()
        configureTabBarController()
    }
    
    private func configureTabBarController() {
        
        self.tabBar.backgroundColor = whiteMainColor
        self.tabBar.tintColor = mainTextBlackColor
        self.tabBar.unselectedItemTintColor = mainTextBlackColor
        self.modalPresentationStyle = .fullScreen
        
        if let tabBarItem1 = self.tabBar.items?[0] {
            tabBarItem1.image = UIImage(named: "home_unselected")
            tabBarItem1.selectedImage = UIImage(named: "home_selected")
        }
        if let tabBarItem2 = self.tabBar.items?[1] {
            tabBarItem2.image = UIImage(named: "search_unselected")
            tabBarItem2.selectedImage = UIImage(named: "search_selected")
        }
        if let tabBarItem3 = self.tabBar.items?[2] {
            tabBarItem3.image = UIImage(named: "bookmark_unselected")
            tabBarItem3.selectedImage = UIImage(named: "bookmark_selected")
        }
        if let tabBarItem4 = self.tabBar.items?[3] {
            tabBarItem4.image = UIImage(named: "settings_unselected")
            tabBarItem4.selectedImage = UIImage(named: "settings_selected")
        }
        
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateViewController(viewController: HomeViewController(), image: UIImage(named: "home_unselected")),
            generateViewController(viewController: SearchViewController(), image: UIImage(named: "search_unselected")),
            generateViewController(viewController: BookmarkViewController(), image: UIImage(named: "bookmark_unselected")),
            generateViewController(viewController: SettingsViewController(), image: UIImage(named: "settings_unselected"))
        ]
    }
    
    private func generateViewController(viewController: UIViewController, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.image = image
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}

