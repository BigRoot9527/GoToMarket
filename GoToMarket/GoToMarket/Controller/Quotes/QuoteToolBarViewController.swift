//
//  QuoteToolBarViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/25.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol QuoteToolBarViewControllerDelegate: class {
    
    func sortButtonsTapped(sender: UIButton, sortDescriptor: [NSSortDescriptor]) -> Void
    
    func scrollButtonTapped(sender: UIButton, scrollToTop: Bool) -> Void
}

class QuoteToolBarViewController: UIViewController {
    
    private enum ToolButtonState {
        
        case ascending, descending, none
        
        mutating func next() {
            
            switch self {
                
            case .ascending:
                self = .descending
                
            case .descending:
                self = .none
                
            case .none:
                self = .ascending
            }
        }
        
        func getTintColor() -> UIColor {
            
            switch self {
                
            case .ascending:
                return GoToMarketColor.sortButtonAcendingColor.color()
                
            case .descending:
                return GoToMarketColor.sortButtonDecendingColor.color()
                
            case .none:
                return GoToMarketColor.sortButtonNoneColor.color()
            }
        }
    }
    
    
    @IBOutlet weak var scrollUpButton: UIButton!
    @IBOutlet weak var sortByNameButton: UIButton!
    @IBOutlet weak var sortByQuoteButton: UIButton!
    @IBOutlet weak var sortByCartButton: UIButton!
    
    weak var delegate: QuoteToolBarViewControllerDelegate?
    
    private var nameButtonState: ToolButtonState = .none {
        
        didSet {
            
            sortByNameButton.tintColor = nameButtonState.getTintColor()
        }
    }
    
    private var quoteButtonState: ToolButtonState = .none {
        
        didSet {
            
            sortByQuoteButton.tintColor = quoteButtonState.getTintColor()
        }
    }
    
    private var cartButtonState: ToolButtonState = .none {
        
        didSet {
            
            sortByCartButton.tintColor = cartButtonState.getTintColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        nameButtonState = .none
        quoteButtonState = .none
        cartButtonState = .none
    }
    
    
    @IBAction func didTapScrollUpButton(_ sender: UIButton) {
        
        delegate?.scrollButtonTapped(sender: sender, scrollToTop: true)
    }
    
    @IBAction func didTapSortByNameButton(_ sender: UIButton) {
        
        nameButtonState.next()
    }
    
    @IBAction func didTapSortByQuoteButton(_ sender: UIButton) {
        
        quoteButtonState.next()
    }
    
    @IBAction func didTapSortByCartButton(_ sender: UIButton) {
        
        cartButtonState.next()
    }
    
    
    
    

}
