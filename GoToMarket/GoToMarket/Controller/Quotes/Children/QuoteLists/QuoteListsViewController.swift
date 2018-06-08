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
    
    //Input
    var activeIndex: Int = 0
    
    @IBOutlet weak var quoteListsScrollView: UIScrollView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateVCs()
        setupVCs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCropTypeSwitched(selectedIndex: activeIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupScrollView()
        setupChildFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    private func generateVCs() {
        
        let allVC = QuotesViewControllerData(vcName: "allVC", basePredicate: "(newAveragePrice > 0)", isMainVC: true)
        
        let vegeVC = QuotesViewControllerData(vcName: "vegeVC", basePredicate: "(newAveragePrice > 0) AND (isFruit = false)", isMainVC: false)
        let fruitVC = QuotesViewControllerData(vcName: "fruitVC", basePredicate: "(newAveragePrice > 0) AND (isFruit = true)", isMainVC: false)
        
        childVCsData = [allVC, vegeVC, fruitVC]
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
    
    private func setupScrollView() {
        
        quoteListsScrollView.contentSize = CGSize(width: quoteListsScrollView.frame.width * CGFloat(childVCs.count), height: quoteListsScrollView.frame.height)
    }
    
    private func setupChildFrame() {
        
        for (index, childVC) in childVCs.enumerated() {
            
            let originX = quoteListsScrollView.frame.width * CGFloat(index)
            
            childVC.view.frame = CGRect(x: originX, y: 0, width: quoteListsScrollView.frame.width, height: quoteListsScrollView.frame.height)
            
            print(childVC.view.frame)
            print(quoteListsScrollView.frame)
            print(quoteListsScrollView.bounds)
            print(quoteListsScrollView.contentSize)
        }
    }
    
    //MARK: - Accessable Function
    func getSortToolBarTapped(sortDescriptor: [NSSortDescriptor]) {
        
        for vc in childVCs {
            vc.sortQuoteData(sortDescriptor: sortDescriptor)
        }
    }
    
    func getScrollToolBarTapped(scrollToTop bool: Bool) {
        
        for vc in childVCs {
            vc.scrollTableView(scrollToTop: bool)
        }
    }
    
    func getSearchBarResult(searchText text: String) {
        
        for vc in childVCs {
            vc.searchQuote(searchText: text)
        }
    }
    
    func getCropTypeSwitched(selectedIndex index: Int) {
        
        self.activeIndex = index
        
        quoteListsScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(activeIndex), y: 0), animated: true)
        
        for vc in childVCs {
            
            vc.isActive = false
        }
        childVCs[activeIndex].isActive = true
    }
    
    func getWeightTypeChanged() {
        
        for vc in childVCs {
            
            vc.changeQuoteWeight()
        }
    }
}
