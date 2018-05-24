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


class QuotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate, SwipeTableViewCellDelegate {


    //MARK: IBOutlet
    @IBOutlet weak var quotesTableView: UITableView!
    
    
    //MARK: CoreData
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    var fetchedResultsController: NSFetchedResultsController<CropDatas>?
    var showInKg: Bool = true
    var isUpdated: Bool = false
    
    private func fetchAndReloadData() {
        if let context = container?.viewContext {
            context.reset()
            let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "newAveragePrice", ascending: true)]
            //request.predicate = NSPredicate(format:)
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
            
            try? self?.container?.viewContext.save()
            
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
            
            try? self?.container?.viewContext.save()

            self?.showingCartAnimation(
                isInChart: note.isInCart,
                fromCellFrame: selectedCell.frame,
                completion: {
                    
                    self?.postCartNotification()
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
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            fetchAndReloadData()
        
            postCartNotification()
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
    
    
    private func updateUI() {
        
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
    
    
    //MARK: Animation
    
    private func showingCartAnimation(
        isInChart:Bool,
        fromCellFrame cellFrame: CGRect,
        completion: @escaping () -> Void ) {
        
        let screenSize = UIScreen.main.bounds
        let rootViewPoint = CGPoint(x: screenSize.width / 2, y: screenSize.height)
        
        let convertedRect = self.view.convert(cellFrame, from: quotesTableView)
//        let convertedPoint = self.view.convert(originpoint, from: nil)
        
        let animationView = UIImageView(image: #imageLiteral(resourceName: "cauliflower_icon"))
        self.view.addSubview(animationView)
        
        animationView.frame = !isInChart ?
            CGRect(x: rootViewPoint.x - 40 , y: rootViewPoint.y, width: 35, height: 35) :
            CGRect(x: 10, y: convertedRect.origin.y + 5, width: 35, height: 35)
        
        let fromPoint = animationView.center
        
        let endPoint = !isInChart ?
            CGPoint(x: -20, y: rootViewPoint.y - 100 ) :
            CGPoint(x: rootViewPoint.x, y: rootViewPoint.y)
        
        let fator: CGFloat = !isInChart ? -1 : 0.5
        
        UIView.animate(withDuration: 0.3, animations: {
            
            animationView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
        })
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            animationView.removeFromSuperview()
            
            completion()

        }
        animationView.animatePath(
            fromPoint: fromPoint,
            toPoint:   endPoint,
            duration:  0.8,
            factor:    fator)
        
        CATransaction.commit()
    }
    
    
    //MARK:Notification
    private func postCartNotification() {
        
        guard let count = fetchedResultsController?.fetchedObjects?.filter(
            { $0.note?.isInCart == true && $0.note?.cropData != nil }).count else { return }
        
        NotificationCenter.default.post(
            name: GoToMarketConstant.cartNotificationName,
            object: self,
            userInfo: ["CartCount": count])

    }
}
