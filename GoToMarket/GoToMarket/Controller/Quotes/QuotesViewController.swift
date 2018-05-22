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
        
        cell.sellPriceLabel.text = PriceStringProvider.getSellPriceString(fromTruePrice: crop.newAveragePrice, andMultipler: note.customMutipler, inKg: showInKg)
        
        if crop.newAveragePrice == 0 {
            cell.priceIndicator = 1
        } else {
            cell.priceIndicator = crop.newAveragePrice / crop.lastAveragePrice
        }
        //SwipeCellKit
        cell.delegate = self
        
        //MARK: TODO
        cell.inBuyingChart = false
        
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
        
        //Hero
        detailVC.hero.isEnabled = true
        detailVC.titleHeroIdInput = String(describing: indexPath)
        detailVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        
        present(detailVC, animated: true, completion: nil)
        
    }
    
    
    //MARK: SwipeCellKit
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let selectedCell = self.quotesTableView.cellForRow(at: indexPath) as! QuotesTableViewCell
        
        let selectAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
            
            selectedCell.inBuyingChart = !selectedCell.inBuyingChart
            
            let animationView = UIImageView(image: #imageLiteral(resourceName: "shopping-cart-3"))
            
            let cellbounds = selectedCell.bounds
            
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            selectedCell.addSubview(animationView)
            
            animationView.frame = CGRect(x: screenWidth - 40, y: cellbounds.origin.y + 5, width: 35, height: 35)
            
            UIView.animate(withDuration: 0.5, animations: {

                animationView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

            })
            
            let fromPoint = animationView.center
            
            let endPoint = CGPoint(x: screenWidth / 2, y: screenHeight - 10)
            
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                print("finished")
                
            }
            self?.animate(view: animationView, fromPoint: fromPoint, toPoint: endPoint)
            CATransaction.commit()
            
            
            

        }
        
        selectAction.image = !selectedCell.inBuyingChart ?
                #imageLiteral(resourceName: "shopping-cart-3").resizeImage(newWidth: 35) : #imageLiteral(resourceName: "shopping-cart-white").resizeImage(newWidth: 35)
            
        selectAction.backgroundColor = !selectedCell.inBuyingChart ?
                GoToMarketColor.newLightBlueGreen.color() : GoToMarketColor.pitchRed.color()

        return [selectAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        let selectedCell = self.quotesTableView.cellForRow(at: indexPath) as! QuotesTableViewCell
        
        var options = SwipeTableOptions()
        
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        options.buttonVerticalAlignment = .center
        options.backgroundColor = !selectedCell.inBuyingChart ? GoToMarketColor.newLightBlueGreen.color() : GoToMarketColor.pitchRed.color()
        
        return options

    }
    
    //MARK: Animation
    func animate(view : UIView, fromPoint start : CGPoint, toPoint end: CGPoint) {
        // The animation
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        // Animation's path
        let path = UIBezierPath()
        
        // Move the "cursor" to the start
        path.move(to: start)
        
        // Calculate the control points
        let factor : CGFloat = 0.5
        
        let deltaX : CGFloat = end.x - start.x
        let deltaY : CGFloat = end.y - start.y
        
        let c1 = CGPoint(x: start.x + deltaX * factor, y: start.y)
        let c2 = CGPoint(x: end.x                    , y: end.y - deltaY * factor)
        
        // Draw a curve towards the end, using control points
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        
        // Use this path as the animation's path (casted to CGPath)
        animation.path = path.cgPath;
        
        // The other animations properties
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = 1
        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        // Apply it
        view.layer.zPosition = 0
        view.layer.add(animation, forKey:"trash")
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
        
        let nibFile = UINib(nibName: "QuotesTableViewCell", bundle: nil)
        
        quotesTableView.register(nibFile,
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

}
