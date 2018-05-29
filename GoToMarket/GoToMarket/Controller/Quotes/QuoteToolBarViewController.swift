//
//  QuoteToolBarViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/25.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol QuoteToolBarViewControllertDelegate: class {
    
    func sortButtonsTapped(
        sender: UIViewController,
        sortDescriptor: [NSSortDescriptor]
        )-> Void
    
    func scrollButtonTapped(
        sender: UIButton,
        scrollToTop: Bool
        ) -> Void
}

class QuoteToolBarViewController: UIViewController {
    
    @IBOutlet weak var scrollUpButton: UIButton!
    @IBOutlet weak var scrollDownButton: UIButton!
    @IBOutlet weak var sortByNameButton: UIButton!
    @IBOutlet weak var sortByQuoteButton: UIButton!
    @IBOutlet weak var sortByCartButton: UIButton!
    
    //Input Custom ItemType
    var itemType: TaskKeys = .crop
    
    weak var delegate: QuoteToolBarViewControllertDelegate?

    private var quoteButton = SortButton(
        state: .ascending,
        representAttribute: "note.sellingPrice",
        buttonImage: #imageLiteral(resourceName: "money_icon")) {
        
        didSet {
            changeTintColor()
            getSortDescriptor()
        }
    }
    
    private var cartButton = SortButton(
        state: .none,
        representAttribute: "note.isInCart",
        buttonImage: #imageLiteral(resourceName: "buy_icon")) {
        
        didSet {
            changeTintColor()
            getSortDescriptor()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {

        changeTintColor()
        scrollUpButton.setImage(#imageLiteral(resourceName: "top_icon"), for: .normal)
        scrollDownButton.setImage(#imageLiteral(resourceName: "bottom_icon"), for: .normal)
        sortByCartButton.setImage(cartButton.getImage(), for: .normal)
        sortByQuoteButton.setImage(quoteButton.getImage(), for: .normal)
        
    }
    
    private func changeTintColor() {
        
        sortByCartButton.tintColor = cartButton.getTintColor()
        sortByQuoteButton.tintColor = quoteButton.getTintColor()
    }
    
    private func getSortDescriptor(){
        
        //notice: sorting priority
        let buttonArray = [cartButton, quoteButton]
        
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
    
    @IBAction func didTapScrollDownButton(_ sender: UIButton) {
        
        delegate?.scrollButtonTapped(sender: sender, scrollToTop: false)
    }

    @IBAction func didTapSortByQuoteButton(_ sender: UIButton) {
        
        switch quoteButton.state {
            
        case .ascending:
            quoteButton.state = .descending
        default:
            quoteButton.state = .ascending
        }
    }
    
    @IBAction func didTapSortByCartButton(_ sender: UIButton) {
        
        cartButton.state.next()
    }

    
}
