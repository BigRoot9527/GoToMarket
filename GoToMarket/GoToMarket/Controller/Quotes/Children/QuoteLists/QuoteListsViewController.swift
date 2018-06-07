//
//  QuoteListsViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/8.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class QuoteListsViewController: UIViewController {
    
    var childVCsData: [QuotesViewControllerData] = []
    
    var childVCs: [QuoteDataViewController] = []
    
    @IBOutlet weak var quoteListsScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateVCs()
        
        setupVCs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupChildFrame()
    }
    
    private func generateVCs() {
        
        let allVC = QuotesViewControllerData(vcName: "allVC", basePredicate: "(newAveragePrice > 0)", isMainVC: true)
        
        let vegeVC = QuotesViewControllerData(vcName: "vegeVC", basePredicate: "(newAveragePrice > 0) AND (isFruit = false)", isMainVC: false)
        let fruitVC = QuotesViewControllerData(vcName: "fruitVC", basePredicate: "(newAveragePrice > 0) AND (isFruit = true)", isMainVC: false)
        
//        childVCsData = [allVC, vegeVC, fruitVC]
        childVCsData = [allVC]
    }
    
    private func setupVCs() {
        
        for vcData in childVCsData {
            
            guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: QuoteDataViewController.self)) as? QuoteDataViewController else { return }
            
            vc.basePredicateString = vcData.basePredicate
            
            vc.isMainVC = vcData.isMainVC
            
            addChildViewController(vc)
            
            quoteListsScrollView.addSubview(vc.view)
            
            vc.didMove(toParentViewController: self)
            
            childVCs.append(vc)
        }
    }
    
    private func setupChildFrame() {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        var count = 0
        
        for childVC in childVCs {
            
            let originX = screenWidth * CGFloat(count)
            
            childVC.view.frame = CGRect(x: originX, y: 0, width: screenWidth, height: screenHeight)
            
            count += 1
            print(quoteListsScrollView.frame)
            print(quoteListsScrollView.bounds)
            print(quoteListsScrollView.contentSize)
        }
    }
    

}

extension QuoteListsViewController: UIScrollViewDelegate {
    
    
    
    
}
