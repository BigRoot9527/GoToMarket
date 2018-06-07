//
//  QuotesViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol QuotesViewControllerDelegate: class {
    
    func getSortToolBarTapped(sender: UIViewController, sortDescriptor: [NSSortDescriptor]) -> Void
    func getScrollToolBarTapped(sender: UIViewController, scrollToTop: Bool) -> Void
    func getSearchBarResult(sender: UIViewController, searchText: String) -> Void
    func getWeightTypeChanged(sender: UIViewController) -> Void
}

class QuotesViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var navIndicatorScrollView: UIScrollView!
    @IBOutlet weak var navIndicatorContentView: UIView!
    @IBOutlet weak var quoteDataContainerView: UIView!
    @IBOutlet weak var weightTypeSegControl: UISegmentedControl!
    @IBOutlet weak var toolBarContainerTopToSafeTopConstraint: NSLayoutConstraint!
    
    //MARK: ToolBar(Opened, Closed) ContraintConstant To SafeArea
    private let topConstant: (CGFloat, CGFloat) = ( 0.0, -50.0 )
    
    //MARK: - QuotesViewControllerDelegate
    weak var delegate: QuotesViewControllerDelegate?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        addChildQuoteDataVC()
        self.navIndicatorScrollView.delegate = self
        //TODO: Who is the Trasition delegate?
        //TODO: Who get refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func setupNav() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func addChildQuoteDataVC() {
        
        guard let childTVC = storyboard?.instantiateViewController(withIdentifier: String(describing: QuoteDataViewController.self)) as? QuoteDataViewController else { return }
        
        addChildViewController(childTVC)
        
        childTVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.quoteDataContainerView.addSubview(childTVC.view)
        
        quoteDataContainerView.frame = childTVC.view.frame

        NSLayoutConstraint.activate([
            childTVC.view.topAnchor.constraint(equalTo: quoteDataContainerView.topAnchor),
            childTVC.view.leadingAnchor.constraint(equalTo: quoteDataContainerView.leadingAnchor),
            childTVC.view.bottomAnchor.constraint(equalTo: quoteDataContainerView.bottomAnchor),
            childTVC.view.trailingAnchor.constraint(equalTo: quoteDataContainerView.trailingAnchor)
            ])
        
        childTVC.didMove(toParentViewController: self)
        
        childTVC.contentOffsetDelegate = self
        
        self.delegate = childTVC
    }
    
    private func updateUI() {
        
        weightTypeSegControl.selectedSegmentIndex = PriceStringProvider.shared.getSegmentedControlIndex()
        
        toolBarContainerTopToSafeTopConstraint.constant = topConstant.1
    }

    //MARK: - IBAction
    @IBAction func weightTypeSegControlDidChange(_ sender: UISegmentedControl) {
        
        PriceStringProvider.shared.showInKg = !PriceStringProvider.shared.showInKg
        
        delegate?.getWeightTypeChanged(sender: self)
    }
    
    @IBAction func didTapToolBarButton(_ sender: UIBarButtonItem) {
        
        toolBarContainerTopToSafeTopConstraint.constant =
            toolBarContainerTopToSafeTopConstraint.constant == topConstant.0 ?
                topConstant.1 : topConstant.0
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.view.layoutIfNeeded()
        }
    }
}

//MARK: - QuoteToolBarVCDelegate
extension QuotesViewController: QuoteToolBarViewControllertDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "QuoteToolBarVCSegue" {
            
            if let toolBarVC = segue.destination as? QuoteToolBarViewController {
                toolBarVC.delegate = self
            }
        }
    }
    
    func sortButtonsTapped(sender: UIViewController, sortDescriptor: [NSSortDescriptor]) {
        
        delegate?.getSortToolBarTapped(sender: self, sortDescriptor: sortDescriptor)
    }
    
    func scrollButtonTapped(sender: UIButton, scrollToTop: Bool) {
        
        delegate?.getScrollToolBarTapped(sender: self, scrollToTop: scrollToTop)
    }
}

//MARK: - UISearchResultsUpdating
extension QuotesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text else { return }
        
        delegate?.getSearchBarResult(sender: self, searchText: searchString)
        
    }
}

//MARK: - UISearchBarDelegate
extension QuotesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        navIndicatorScrollView.isUserInteractionEnabled = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        navIndicatorScrollView.isUserInteractionEnabled = true
    }
}



//MARK: - UIScrollViewDelegate
extension QuotesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset)
        print(scrollView.contentInset)
    }
    
}

//MARK:

extension QuotesViewController: QuoteDataVCContentOffsetDelegate {
    
    func getContentOffset(sender: UIViewController, contextOffset: CGPoint) {
        
//        if contextOffset.y >= 0 {
        
            navIndicatorScrollView.contentOffset.y = contextOffset.y
//        }
    }
    
    
    
}

