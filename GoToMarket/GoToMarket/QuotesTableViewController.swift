//
//  QuotesTableViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/3.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

class QuotesTableViewController: FetchedResultsTableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    var fetchedResultsController: NSFetchedResultsController<CropNew>?
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<CropNew> = CropNew.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "averagePrice", ascending: true)]
            //request.predicate = NSPredicate(format:)
            fetchedResultsController = NSFetchedResultsController<CropNew>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if let crop = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = crop.cropName
            cell.detailTextLabel?.text = String(crop.averagePrice)
        }
        return cell
    }
    

}
