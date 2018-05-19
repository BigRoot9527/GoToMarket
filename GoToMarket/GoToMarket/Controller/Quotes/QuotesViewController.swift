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

class QuotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {
    

    //MARK: IBOutlet
    @IBOutlet weak var quotesTableView: UITableView!
    
    
    //MARK: CoreData
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    var fetchedResultsController: NSFetchedResultsController<CropDatas>?
    var showInKg: Bool = true
    
    private func fetchData() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "averagePrice", ascending: true)]
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
        
        cell.sellPriceLabel.text = PriceStringProvider.getSellPriceString(fromTruePrice: crop.averagePrice, andMultipler: note.customMutipler, inKg: showInKg)
        
        //MARK: TODO
        cell.inBuyingChart = true
        
        cell.contentView.hero.id = nil
        
        cell.hero.isEnabled = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GoToMarketConstant.quotesRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let crop = fetchedResultsController?.object(at: indexPath) else { return }
        
        quotesTableView.cellForRow(at: indexPath)?.hero.isEnabled = true
        
        quotesTableView.cellForRow(at: indexPath)?.contentView.hero.id = "titleCellView"
    
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
        
        detailVC.objectPassed = crop
        
        detailVC.hero.isEnabled = true
        
        detailVC.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
        
        present(detailVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        quotesTableView.cellForRow(at: indexPath)?.hero.isEnabled = false
        
        quotesTableView.cellForRow(at: indexPath)?.hero.id = nil
        
    }
    
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        quotesTableView.dataSource = self
        quotesTableView.delegate = self
        self.hero.isEnabled = true
        registerCell()
        fetchData()
        updateUI()
//        quotesTableView.hero.modifiers = [HeroModifier.whenPresenting(.fade)]
    }
    
    private func updateUI() {
        
    }
    
    private func registerCell() {
        let nibFile = UINib(nibName: "QuotesTableViewCell", bundle: nil)
        quotesTableView.register(nibFile,
                                 forCellReuseIdentifier: String(describing: QuotesTableViewCell.self))
    }

}
