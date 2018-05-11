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
            break
            return
            
        case .quote:
            break
//            return #imageLiteral(resourceName: "Quote_Icon")
            
        case .setting:
            break
//            return #imageLiteral(resourceName: "Settings_Icon")
        }
        
    }
    
    func selectedImage() -> UIImage {
        switch self {
            
        case .note:
            return #imageLiteral(resourceName: "Note_Icon").withRenderingMode(.alwaysTemplate)
            
        case .quote:
            return #imageLiteral(resourceName: "Quote_Icon").withRenderingMode(.alwaysTemplate)
            
        case .setting:
            return #imageLiteral(resourceName: "Settings_Icon").withRenderingMode(.alwaysTemplate)
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
