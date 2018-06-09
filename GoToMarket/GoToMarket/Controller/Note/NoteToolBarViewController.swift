//
//  NoteToolBarViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/28.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol NoteToolBarViewControllertDelegate: class {
    
    func sortButtonsTapped(
        sender: UIViewController,
        sortDescriptor: [NSSortDescriptor]
        )-> Void
    
    func deleteAllButtonTapped(
        sender: UIButton
        ) -> Void
    
    func cleanAllButtonTapped(
        sender: UIButton
        ) -> Void
}

class NoteToolBarViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var sortByFinishedButton: UIButton!
    @IBOutlet weak var sortByTypeButton: UIButton!
    @IBOutlet weak var sortByPriceButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    //Input Custom ItemType
    var itemType: TaskKeys = .crop
    
    weak var delegate: NoteToolBarViewControllertDelegate?
    
    private var finishedButton = SortButton(
        state: .none,
        representAttribute: "isFinished",
        buttonImage: #imageLiteral(resourceName: "checked_icon")) {
        
        didSet {
            changeTintColor()
            getSortDescriptor()
        }
    }
    private var typeButton = SortButton(
        state: .none,
        representAttribute: "cropData.isFruit",
        buttonImage: #imageLiteral(resourceName: "fruit_icon")) {
        
        didSet {
            changeTintColor()
            getSortDescriptor()
        }
    }
    
    private var quoteButton = SortButton(
        state: .ascending,
        representAttribute: "sellingPrice",
        buttonImage: #imageLiteral(resourceName: "money_icon")) {
        
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
        sortByFinishedButton.setImage(finishedButton.getImage(), for: .normal)
        sortByTypeButton.setImage(typeButton.getImage(), for: .normal)
        sortByPriceButton.setImage(quoteButton.getImage(), for: .normal)
    }
    
    private func changeTintColor() {
        
        sortByFinishedButton.tintColor = finishedButton.getTintColor()
        sortByTypeButton.tintColor = typeButton.getTintColor()
        sortByPriceButton.tintColor = quoteButton.getTintColor()
    }
    
    private func getSortDescriptor(){
        
        //notice: sorting priority
        let buttonArray = [finishedButton, typeButton, quoteButton]
        
        let manager = NSSortDescriptorManager()
        
        delegate?.sortButtonsTapped(
            sender: self,
            sortDescriptor: manager.getOrderedNSSortDescriptor(
                sortButtons: buttonArray,
                itemType: itemType)
        )
    }
    
    //MARK: - IBAction
    
    @IBAction func didTapSortByFinishedButton(_ sender: UIButton) {
        
        finishedButton.state.next()
    }
    
    @IBAction func didTapSortByTypeButton(_ sender: UIButton) {
        
        typeButton.state.next()
    }
    
    
    @IBAction func didTapSortByPriceButton(_ sender: UIButton) {
        
        switch quoteButton.state {
            
        case .ascending:
            quoteButton.state = .descending
        default:
            quoteButton.state = .ascending
        }
    }
    
    @IBAction func didTapCleanAllButton(_ sender: UIButton) {
        
        delegate?.cleanAllButtonTapped(sender: sender)
    }
    
    @IBAction func didTapDeleteAllButton(_ sender: UIButton) {
        
        delegate?.deleteAllButtonTapped(sender: sender)
    }
    
    
}
