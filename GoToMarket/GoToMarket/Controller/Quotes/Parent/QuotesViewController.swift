//
//  QuotesViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    //MARK: - IBOutlet

    @IBOutlet weak var weightTypeSegControl: UISegmentedControl!
    @IBOutlet weak var searchBottomToSwitchBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var quoteSearchBar: UISearchBar!
    @IBOutlet weak var quoteListsContainerView: UIView!
    
    //MARK: ToolBar(Opened, Closed) ContraintConstant To SafeArea
    private let topConstant: (CGFloat, CGFloat) = (100.0, 0.0 )
    
    private var listChildVC = QuoteListsViewController()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupSeachBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func setupNav() {
        
    }
    
    private func setupSeachBar() {
    
        quoteSearchBar.delegate = self
        quoteSearchBar.setValue(GoToMarketConstant.cancleButtonTitleValue, forKey: GoToMarketConstant.cancleButtonTitleKey)
    }

    private func updateUI() {
        
        weightTypeSegControl.selectedSegmentIndex = PriceStringProvider.shared.getSegmentedControlIndex()
        
        searchBottomToSwitchBottomConstraint.constant = topConstant.1
    }

    //MARK: - IBAction
    @IBAction func weightTypeSegControlDidChange(_ sender: UISegmentedControl) {
        
        PriceStringProvider.shared.showInKg = !PriceStringProvider.shared.showInKg
        
        listChildVC.getWeightTypeChanged()
    }
    
    @IBAction func didTapToolBarButton(_ sender: UIBarButtonItem) {
        
        searchBottomToSwitchBottomConstraint.constant =
            searchBottomToSwitchBottomConstraint.constant == topConstant.0 ? topConstant.1 : topConstant.0
        
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "QuoteToolBarVCSegue":
            guard let toolBarVC = segue.destination as? QuoteToolBarViewController else { return }
            toolBarVC.delegate = self
            
        case "QuoteSwitchVCSegue":
            guard let switchVC = segue.destination as? QuoteSwitchViewController else { return }
            switchVC.delegate = self
        
        case "QuoteListsVCSegue":
            guard let listVC = segue.destination as? QuoteListsViewController else { return }
            self.listChildVC = listVC
            
        default:
            break
        }
    }
}

//MARK: - QuoteToolBarVCDelegate
extension QuotesViewController: QuoteToolBarViewControllertDelegate {
    
    func sortButtonsTapped(sender: UIViewController, sortDescriptor: [NSSortDescriptor]) {
        
        listChildVC.getSortToolBarTapped(sortDescriptor: sortDescriptor)
    }
    
    func scrollButtonTapped(sender: UIButton, scrollToTop: Bool) {
        
        listChildVC.getScrollToolBarTapped(scrollToTop: scrollToTop)
    }
}

//MARK: - QuoteSwitchViewControllerDelegate
extension QuotesViewController: QuoteSwitchViewControllerDelegate {
    
    func switchTypeButtonTapped(sender: UIViewController, selectedIndex: Int) {
        
        listChildVC.getCropTypeSwitched(selectedIndex: selectedIndex)
    }
}

//MARK: - UISearchBarDelegate
extension QuotesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.quoteListsContainerView.isUserInteractionEnabled = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
         self.quoteListsContainerView.isUserInteractionEnabled = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = GoToMarketConstant.emptyString
        searchBar.setShowsCancelButton(false , animated: true)
        searchBar.resignFirstResponder()
        listChildVC.getSearchBarResult(searchText: GoToMarketConstant.emptyString)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.setShowsCancelButton(searchText != GoToMarketConstant.emptyString , animated: true)
        listChildVC.getSearchBarResult(searchText: searchText)
    }
}

