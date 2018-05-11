//
//  TabBarViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/11.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

enum TabBar {
    
    case quote
    
    case note
    
    case setting
    
    func controller() -> UIViewController {
        switch self {
            
        case .note:
            return UIStoryboard.notes().instantiateInitialViewController()!
            
        case .quote:
            return UIStoryboard.quotes().instantiateInitialViewController()!
            
        case .setting:
            return UIStoryboard.settings().instantiateInitialViewController()!
        }
    }
    
    func image() -> UIImage {
        
        switch self {
            
        case .note:
            return #imageLiteral(resourceName: "buy_icon")
            
        case .quote:
            return #imageLiteral(resourceName: "comboChart_icon")
            
        case .setting:
            return #imageLiteral(resourceName: "services_icon")
        }
        
    }
    
    func selectedImage() -> UIImage {
        switch self {
            
        case .note:
            return #imageLiteral(resourceName: "buy_icon").withRenderingMode(.alwaysTemplate)
            
        case .quote:
            return #imageLiteral(resourceName: "comboChart_icon").withRenderingMode(.alwaysTemplate)
            
        case .setting:
            return #imageLiteral(resourceName: "services_icon").withRenderingMode(.alwaysTemplate)
        }
    }
    
    
}

class TabBarViewController: UITabBarController {
    
    let tabs: [TabBar] = [.quote, .note, .setting]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTab()
    }

    private func setupTab() {
        
        tabBar.tintColor = GoToMarketColor.tabBarTintColor.color()
        
        var controllers: [UIViewController] = []
        
        for tab in tabs {
            
            let controller = tab.controller()
            
            let item = UITabBarItem(
                title: nil,
                image: tab.image(),
                selectedImage: tab.selectedImage()
            )
            
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
//            item.image
            
            controller.tabBarItem = item
            
            controllers.append(controller)
        }
        
        setViewControllers(controllers, animated: false)
        
    }

}
