//
//  QuotesViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class QuotesViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var weightTypeSegControl: UISegmentedControl!
    @IBOutlet weak var quoteSearchBar: UISearchBar!
    @IBOutlet weak var quoteListsContainerView: UIView!
    @IBOutlet weak var searchBarBottomToSafeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarBottomToSwitchBottomConstraint: NSLayoutConstraint!

    // MARK: ToolBar(Opened, Closed) ContraintConstant To SafeArea
    private let topConstant: (CGFloat, CGFloat) = (50.0, 0.0 )

    private var listChildVC = QuoteListsViewController()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSeachBar()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateweightTypeSegControl),
            name: GoToMarketConstant.weightNotificationName,
            object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupUI()
    }

    private func setupSeachBar() {

        quoteSearchBar.delegate = self

        guard let cancelButton = quoteSearchBar.value(forKey: GoToMarketConstant.cancleButtonTitleKey) as? UIButton else { return }

        cancelButton.setTitle(GoToMarketConstant.cancleButtonTitleValue, for: .normal)
    }

    private func setupUI() {

        searchBarBottomToSafeTopConstraint.constant = topConstant.1
        toolBarBottomToSwitchBottomConstraint.constant = topConstant.1

        updateweightTypeSegControl()
    }

    // MARK: - Notification
    @objc private func updateweightTypeSegControl() {

        weightTypeSegControl.selectedSegmentIndex = PriceStringProvider.shared.getSegmentedControlIndex()
    }

    // MARK: - IBAction
    @IBAction func weightTypeSegControlDidChange(_ sender: UISegmentedControl) {

        PriceStringProvider.shared.showInKg = !PriceStringProvider.shared.showInKg

        listChildVC.getWeightTypeChanged()
    }

    @IBAction func didTapToolBarButton(_ sender: UIBarButtonItem) {

        toolBarBottomToSwitchBottomConstraint.constant =
            toolBarBottomToSwitchBottomConstraint.constant == topConstant.0 ? topConstant.1 : topConstant.0
        quoteSearchBar.resignFirstResponder()

        UIView.animate(withDuration: 0.3) { [weak self] in

            self?.view.layoutIfNeeded()
        }
    }

    @IBAction func didTapSearchBarButton(_ sender: UIBarButtonItem) {

        searchBarBottomToSafeTopConstraint.constant =
            searchBarBottomToSafeTopConstraint.constant == topConstant.0 ? topConstant.1 : topConstant.0
        quoteSearchBar.resignFirstResponder()

        UIView.animate(withDuration: 0.3) { [weak self] in

            self?.view.layoutIfNeeded()
        }
    }

    // MARK: - Prepare For Segue
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

// MARK: - QuoteToolBarVCDelegate
extension QuotesViewController: QuoteToolBarViewControllertDelegate {

    func sortButtonsTapped(sender: UIViewController, sortDescriptor: [NSSortDescriptor]) {

        listChildVC.getSortToolBarTapped(sortDescriptor: sortDescriptor)
    }

    func scrollButtonTapped(sender: UIButton, scrollToTop: Bool) {

        listChildVC.getScrollToolBarTapped(scrollToTop: scrollToTop)
    }
}

// MARK: - QuoteSwitchViewControllerDelegate
extension QuotesViewController: QuoteSwitchViewControllerDelegate {

    func switchTypeButtonTapped(sender: UIViewController, selectedIndex: Int) {

        listChildVC.getCropTypeSwitched(selectedIndex: selectedIndex)
    }
}

// MARK: - UISearchBarDelegate
extension QuotesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        self.quoteListsContainerView.isUserInteractionEnabled = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

         self.quoteListsContainerView.isUserInteractionEnabled = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.text = GoToMarketConstant.emptyString
//        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        listChildVC.getSearchBarResult(searchText: GoToMarketConstant.emptyString)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

//        searchBar.setShowsCancelButton(searchText != GoToMarketConstant.emptyString, animated: true)
        listChildVC.getSearchBarResult(searchText: searchText)
    }
}
