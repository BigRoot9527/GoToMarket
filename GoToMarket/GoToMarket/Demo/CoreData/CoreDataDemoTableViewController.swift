////
////  QuotesTableViewController.swift
////  GoToMarket
////
////  Created by 許庭瑋 on 2018/5/3.
////  Copyright © 2018年 許庭瑋. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class CoreDataDemoTableViewController: FetchedResultsTableViewController {
//
//    var container: NSPersistentContainer? =
//        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
//    var fetchedResultsController: NSFetchedResultsController<CropDatas>?
//
//    private func updateUI() {
//        if let context = container?.viewContext {
//            let request: NSFetchRequest<CropDatas> = CropDatas.fetchRequest()
//            request.sortDescriptors = [NSSortDescriptor(key: "averagePrice", ascending: true)]
//            //request.predicate = NSPredicate(format:)
//            fetchedResultsController = NSFetchedResultsController<CropDatas>(
//                fetchRequest: request,
//                managedObjectContext: context,
//                sectionNameKeyPath: nil,
//                cacheName: nil
//            )
//            fetchedResultsController?.delegate = self
//            try? fetchedResultsController?.performFetch()
//            tableView.reloadData()
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        updateUI()
//
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! CustomTableViewCell
//        if let crop = fetchedResultsController?.object(at: indexPath) {
//            cell.titleLabel.text = crop.cropName
//            cell.subTitleLabel.text = String(crop.averagePrice)
//            cell.marketLabel.text = crop.marketName
//            cell.dateLabel.text = crop.date
//
//        }
//        return cell
//    }
//
//
//}
