//
//  SettingsModel.swift
//  NewsBox
//
//  Created by REEMOTTO on 14.02.23.
//

import UIKit

struct SettingsModel {
    
    var title : String
    var icon : UIImage?
    var controller: UIViewController?
    
}

extension SettingsModel {
    static func  mocks() -> [SettingsModel] {
        return [
            .init(title: "Account", icon: UIImage(named: "account")),
            .init(title: "Push Notifications", icon: UIImage(named: "notification")),
            .init(title: "Terms & Conditions", icon: UIImage(named: "about"), controller: ConditionViewController()),
            .init(title: "About", icon: UIImage(named: "about"), controller: ConditionViewController()),
            .init(title: "Logout", icon: UIImage(named: "logout")),
            ]
    }
}
