//
//  QuotesViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData
import Hero
import SwipeCellKit

class QuotesViewController: UIViewController {
    
    var showInKg: Bool = true

    //MARK: - IBOutlet
    @IBOutlet weak var quotesTableView: UITableView!
    @IBOutlet weak var weightTypeSegControl: UISegmentedControl!
    @IBOutlet weak var toolBarTopToSafeAreaConstraint: NSLayoutConstraint!
    
    //MARK: ToolBar(Opened, Closed) ContraintConstant To SafeArea
    private let topConstant: (CGFloat, CGFloat) = ( 0.0, 50.0 )
    
    //MARK: - CoreData
    private var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    private var fetchedResultsController: NSFetchedResultsController<CropDatas>?
    private var isUpdated: Bool = false
    private var filterText: String?
    private var savedSortingType: [NSSortDescriptor] = GoToMarketConstant.cropBasicNSSortDecriptor
    
    //MARK: - UIRefreshControl
    private let refreshControl = UIRefreshControl()

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        setupNav()
        
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        
        fetchAndReloadData()
        
        countAndPostNotification(withAnimation: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isUpdated {
            
            checkAndUpdateApi()
            
            isUpdated = true
        }
    }

    private func setupTableView() {
        
        quotesTableView.dataSource = self
        quotesTableView.delegate = self
        
        //Setup UIRefreshControl
        if #available(iOS 10.0, *) {
            quotesTableView.refreshControl = refreshControl
        } else {
            quotesTableView.addSubview(refreshControl)
        }
        
        refreshControl.tintColor = GoToMarketColor.newOrange.color()
        refreshControl.addTarget(self, action: #selector(didPullTableView(_:)), for: .valueChanged)
        
        
        let nibFile = UINib(
            nibName: "QuotesTableViewCell",
            bundle: nil)
        
        quotesTableView.register(
            nibFile,
            forCellReuseIdentifier: String(describing: QuotesTableViewCell.self))
    }
    
    private func setupNav() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    private func updateUI() {
        
        quotesTableView.separatorStyle = .none
        
        weightTypeSegControl.selectedSegmentIndex = PriceStringProvider.shared.getSegmentedControlIndex()
        
        toolBarTopToSafeAreaConstraint.constant = topConstant.1
    }
    
    private func checkAndUpdateApi() {
        
        if LoadingTaskKeeper.shared.getMarket(ofKey: TaskKeys.crop) == nil {
            
            let settingVC = UIStoryboard.marketSetting().instantiateInitialViewController() as! MarketSettingViewController
            
            //TODO: Switch item type
            settingVC.itemTypeInput = .crop
            
            settingVC.hero.modalAnimationType = .fade
            
            present(settingVC, animated: true, completion: nil)
            
        } else {
        
            let loadingVC = UIStoryboard.loading().instantiateInitialViewController() as! LoadingViewController
            
            //TODO: Switch item type
            
            loadingVC.itemTypeInput = .crop
            
            loadingVC.hero.modalAnimationType = .fade
            
            present(loadingVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIRefreshControl method
    @objc private func didPullTableView(_ sender: Any) {
        
        checkAndUpdateApi()
        self.refreshControl.endRefreshing()
    }
    
    //MARK: - IBAction
    @IBAction func weightTypeSegControlDidChange(_ sender: UISegmentedControl) {
        
        PriceStringProvider.shared.showInKg = !PriceStringProvider.shared.showInKg
        
        quotesTableView.reloadData()
    }
    
    
    @IBAction func didTapToolBarButton(_ sender: UIBarButtonItem) {
        
        toolBarTopToSafeAreaConstraint.constant =
            toolBarTopToSafeAreaConstraint.constant == topConstant.0 ?
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
        
        savedSortingType = sortDescriptor
        fetchAndReloadData()
        let idexPath = IndexPath(row: 0, section: 0)
        quotesTableView.scrollToRow(at: idexPath, at: .top, animated: true)
    }
    
    func scrollButtonTapped(sender: UIButton, scrollToTop: Bool) {
        
        let indexPath = scrollToTop ?
            IndexPath(row: 0, section: 0) :
            IndexPath(row: quotesTableView.numberOfRows(inSection: 0) - 1, section: 0)

            quotesTableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
}


//MARK: - NSFetchedResultsControllerDelegate
extension QuotesViewController: NSFetchedResultsControllerDelegate {
    
    private func fetchAndReloadData() {
        
        if let context = container?.viewContext {
            
            context.reset()
            
            let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
            
            request.sortDescriptors = savedSortingType
            
            if let filter = filterText, filter != GoToMarketConstant.emptyString {
                
                request.predicate = NSPredicate(format: "(cropName CONTAINS %@) AND (newAveragePrice > 0)", filter)
            } else {
                
                request.predicate = NSPredicate(format: "newAveragePrice > 0")
            }
            
            fetchedResultsController = NSFetchedResultsController<CropDatas>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            quotesTableView.reloadData()
        }
    }
    
    
    private func countAndPostNotification(withAnimation bool: Bool) {
        
        if let count = fetchedResultsController?.fetchedObjects?.filter(
            { $0.note?.isInCart == true && $0.note?.cropData != nil && $0.note?.isFinished == false }).count {
            
            postCartNotification(count: count, playBounceAnimation: bool)
        }
    }
}

//MARK: - UITableViewDataSource
extension QuotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuotesTableViewCell.self), for: indexPath) as! QuotesTableViewCell
        
        guard let crop = fetchedResultsController?.object(at: indexPath) , let note = crop.note else { return UITableViewCell() }
        
        cell.itemNameLabel.text = crop.cropName
        
        cell.sellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromSellingPrice: note.sellingPrice)
        
        if crop.newAveragePrice == 0 {
            cell.priceIndicator = 1
        } else {
            cell.priceIndicator = crop.newAveragePrice / crop.lastAveragePrice
        }
        //SwipeCellKit
        cell.delegate = self
        
        //MARK: TODO
        cell.inBuyingChart = note.isInCart
        
        //Hero
        cell.contentView.hero.id = String(describing: indexPath)
        
        cell.hero.isEnabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        
        } else {
            return 0
        }
    }
}


//MARK: - UITableViewDelegate
extension QuotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GoToMarketConstant.quotesRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard
            let crop = fetchedResultsController?.object(at: indexPath),
            let cell = quotesTableView.cellForRow(at: indexPath) as? QuotesTableViewCell
            else { return }
        
        let detailVC = UIStoryboard.detail().instantiateInitialViewController()! as! DetailViewController
        
        detailVC.itemCodeInput = crop.cropCode
        
        detailVC.didTapBuyingCallBack = { [weak self] bool -> () in
            
            crop.note?.isInCart = bool
            
            try? crop.note?.setInCart(isInCart: bool, inContext: self?.container?.viewContext)
            
            cell.inBuyingChart = bool
        }
        
        //Hero
//        detailVC.hero.isEnabled = true
//        detailVC.titleHeroIdInput = String(describing: indexPath)
//        detailVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        
        detailVC.modalPresentationStyle = .custom
        
        present(detailVC, animated: true, completion: nil)
    }
}


//MARK: - SwipeCellKit
extension QuotesViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        guard
            orientation == .right,
            let crop = fetchedResultsController?.object(at: indexPath) ,
            let note = crop.note,
            let selectedCell = self.quotesTableView.cellForRow(at: indexPath) as? QuotesTableViewCell
            else { return nil }
        
        let selectAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
            
            note.isInCart = !note.isInCart
            
            selectedCell.inBuyingChart = note.isInCart
            
            try? note.setInCart(isInCart: note.isInCart, inContext: self?.container?.viewContext)
            
            self?.showingCartAnimation(
                isInChart: note.isInCart,
                fromCellFrame: selectedCell.frame,
                cellTableView: self?.quotesTableView,
                completion: {
                    
                    guard self?.viewIfLoaded?.window != nil else { return }
                    
                    self?.countAndPostNotification(withAnimation: true)
            })
        }
        
        selectAction.image = !selectedCell.inBuyingChart ?
            #imageLiteral(resourceName: "add_icon").resizeImage(newWidth: 35) :
            #imageLiteral(resourceName: "minus_icon").resizeImage(newWidth: 35)
        
//        selectAction.backgroundColor = !selectedCell.inBuyingChart ?
//            GoToMarketColor.newLightBlueGreen.color() :
//            GoToMarketColor.pitchRed.color()
        
        selectAction.backgroundColor = UIColor.clear
        
        return [selectAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
//        let selectedCell = self.quotesTableView.cellForRow(at: indexPath) as! QuotesTableViewCell
        
        var options = SwipeTableOptions()
        
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        options.buttonVerticalAlignment = .center
//        options.backgroundColor = !selectedCell.inBuyingChart ?
//            GoToMarketColor.newLightBlueGreen.color() :
//            GoToMarketColor.pitchRed.color()
        options.backgroundColor = UIColor.clear
        
        return options
    }
}


//MARK: - UISearchResultsUpdating
extension QuotesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text else { return }
        
        self.filterText = searchString
        
        fetchAndReloadData()
        
    }
    
}


//MARK: - UISearchBarDelegate
extension QuotesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        quotesTableView.allowsSelection = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        quotesTableView.allowsSelection = true
    }
    
}
