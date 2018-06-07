//
//  QuoteListsViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class QuoteListsViewController: UIViewController {
    
    let childVCsName: [String] = GoToMarketConstant.quoteListsVCName
    
    var childVCs: [QuoteDataViewController] = []
    
    @IBOutlet weak var quoteListsScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVCs()

    }
    
    private func setupVCs() {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let screenHeight = UIScreen.main.bounds.height
        
        for vcName in childVCsName {
            
            guard let vcName = storyboard?.instantiateViewController(withIdentifier: String(des))
            
            
            
            
            
        }
        
        
        
        
        
        
        
    }
    

}
