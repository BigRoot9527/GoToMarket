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


class QuotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate, SwipeTableViewCellDelegate, UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchString = searchController.searchBar.text else { return }
        
        fetchAndReloadData(filterText: searchString)
        
    }
    


    //MARK: IBOutlet
    @IBOutlet weak var quotesTableView: UITableView!
    @IBOutlet weak var weightTypeNavBarButton: UIBarButtonItem!
    
    
    //MARK: CoreData
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    var fetchedResultsController: NSFetchedResultsController<CropDatas>?
    var showInKg: Bool = true
    var isUpdated: Bool = false
    
    private func fetchAndReloadData(filterText: String?) {
        
        if let context = container?.viewContext {
            
            context.reset()
            
            let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
            
            request.sortDescriptors = [NSSortDescriptor(key: "newAveragePrice", ascending: true)]
            
            if
                let filter = filterText,
                filter != GoToMarketConstant.emptyString
            {
                request.predicate = NSPredicate(format: "cropName CONTAINS %@", filter)
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
    
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuotesTableViewCell.self), for: indexPath) as! QuotesTableViewCell
        
        guard let crop = fetchedResultsController?.object(at: indexPath) , let note = crop.note else { return UITableViewCell() }
        
        cell.itemNameLabel.text = crop.cropName
        
        cell.sellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromTruePrice: crop.newAveragePrice, andMultipler: note.customMutipler)
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GoToMarketConstant.quotesRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let crop = fetchedResultsController?.object(at: indexPath) else { return }
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
        
        detailVC.objectInput = crop
        
        detailVC.didTapBuyingCallBack = { [weak self] bool -> () in
            
            crop.note?.isInCart = bool
            
            try? crop.note?.setInCart(isInCart: bool, inContext: self?.container?.viewContext)
        }
        
        //Hero
        detailVC.hero.isEnabled = true
        detailVC.titleHeroIdInput = String(describing: indexPath)
        detailVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        
        present(detailVC, animated: true, completion: nil)
    }
    
    
    //MARK: SwipeCellKit
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        guard
            orientation == .right,
            let crop = fetchedResultsController?.object(at: indexPath) ,
            let note = crop.note,
            let selectedCell = self.quotesTableView.cellForRow(at: indexPath) as? QuotesTableViewCell
            else { return nil }
        
        let selectAction = SwipeAction(
        style: .default,
        title: nil)
        { [weak self] action, indexPath in
            
            note.isInCart = !note.isInCart
            
            selectedCell.inBuyingChart = note.isInCart
            
            try? note.setInCart(isInCart: note.isInCart, inContext: self?.container?.viewContext)

            self?.showingCartAnimation(
                isInChart: note.isInCart,
                fromCellFrame: selectedCell.frame,
                cellTableView: self?.quotesTableView,
                completion: {
                    
                    guard
                        let count = self?.fetchedResultsController?.fetchedObjects?.filter(
                        { $0.note?.isInCart == true && $0.note?.cropData != nil }).count
                        else { return }
                    
                    self?.postCartNotification(count: count)
            })
        }
        
        selectAction.image = !selectedCell.inBuyingChart ?
            #imageLiteral(resourceName: "add_icon").resizeImage(newWidth: 35) :
            #imageLiteral(resourceName: "minus_icon").resizeImage(newWidth: 35)
            
        selectAction.backgroundColor = !selectedCell.inBuyingChart ?
            GoToMarketColor.newLightBlueGreen.color() :
            GoToMarketColor.pitchRed.color()

        return [selectAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        let selectedCell = self.quotesTableView.cellForRow(at: indexPath) as! QuotesTableViewCell
        
        var options = SwipeTableOptions()
        
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        options.buttonVerticalAlignment = .center
        options.backgroundColor = !selectedCell.inBuyingChart ?
            GoToMarketColor.newLightBlueGreen.color() :
            GoToMarketColor.pitchRed.color()
        
        return options
    }
    

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        setupTableView()
        
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        
        fetchAndReloadData(filterText: nil)
        
        if let count = fetchedResultsController?.fetchedObjects?.filter(
            { $0.note?.isInCart == true && $0.note?.cropData != nil }).count {
            
            postCartNotification(count: count)
        }
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
        
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    private func updateUI() {
        
        quotesTableView.separatorStyle = .none
        weightTypeNavBarButton.title = PriceStringProvider.shared.getWeightTypeButtonString()
    }
    
    private func checkAndUpdateApi() {
        
        if LoadingTaskKeeper.shared.getMarket(ofKey: TaskKeys.crop) == nil {
            
            let settingVC = UIStoryboard.marketSetting().instantiateInitialViewController() as! MarketSettingViewController
            
            //TODO: Switch item type
            settingVC.itemTypeInput = TaskKeys.crop
            
            settingVC.hero.modalAnimationType = .fade
            
            present(settingVC, animated: true, completion: nil)
            
        } else {
        
            let loadingVC = UIStoryboard.loading().instantiateInitialViewController() as! LoadingViewController
            
            //TODO: Switch item type
            loadingVC.itemTypeInput = TaskKeys.crop
            
            loadingVC.hero.modalAnimationType = .fade
            
            present(loadingVC, animated: true, completion: nil)
        }
    }
    
    //MARK: IBAction
    
    @IBAction func didTapWeightTypeNavBarButton(_ sender: UIBarButtonItem) {
        
        PriceStringProvider.shared.showInKg = !PriceStringProvider.shared.showInKg
        
        sender.title = PriceStringProvider.shared.getWeightTypeButtonString()
        
        quotesTableView.reloadData()
    }
    
}
