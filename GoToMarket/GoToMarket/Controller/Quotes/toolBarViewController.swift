//
//  QuoteToolBarViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/25.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit



protocol ToolBarViewControllertDelegate: class {
    
    func sortButtonsTapped(
        sender: UIViewController,
        sortDescriptor: [NSSortDescriptor]
        )-> Void
    
    func scrollButtonTapped(
        sender: UIButton,
        scrollToTop: Bool
        ) -> Void
}

class toolBarViewController: UIViewController {
    
    
    @IBOutlet weak var scrollUpButton: UIButton!
    @IBOutlet weak var sortByNameButton: UIButton!
    @IBOutlet weak var sortByQuoteButton: UIButton!
    @IBOutlet weak var sortByCartButton: UIButton!
    
    //Input Custom ItemType
    var itemType: TaskKeys = .crop
    
    weak var delegate: ToolBarViewControllertDelegate?
    
    private var nameButton = SortButton(state: .none, representAttribute: "cropName") {
        
        didSet {
            sortByNameButton.tintColor = nameButton.getTintColor()
        }
    }
    
    private var quoteButton = SortButton(state: .none, representAttribute: "newAveragePrice") {
        
        didSet {
            sortByQuoteButton.tintColor = quoteButton.getTintColor()
        }
    }
    
    private var cartButton = SortButton(state: .none, representAttribute: "note.isInCart") {
        
        didSet {
            sortByCartButton.tintColor = cartButton.getTintColor()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    private func getSortDescriptor(){
        
        let buttonArray = [nameButton, quoteButton, cartButton]
        
        let manager = NSSortDescriptorManager()
        
        
        delegate?.sortButtonsTapped(
            sender: self,
            sortDescriptor: manager.getOrderedNSSortDescriptor(
                sortButtons: buttonArray,
                itemType: itemType)
        )
    }
    
    
    
    
    @IBAction func didTapScrollUpButton(_ sender: UIButton) {
        
        delegate?.scrollButtonTapped(sender: sender, scrollToTop: true)
    }
    
    @IBAction func didTapSortByNameButton(_ sender: UIButton) {
        
        nameButton.state.next()
    }
    
    @IBAction func didTapSortByQuoteButton(_ sender: UIButton) {
        
        quoteButton.state.next()
    }
    
    @IBAction func didTapSortByCartButton(_ sender: UIButton) {
        
        cartButton.state.next()
    }
    
    
    
    

}
