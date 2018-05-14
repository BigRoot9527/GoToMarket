//
//  ExtensionOfQuoteViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/13.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

extension TestFoldingViewController {
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        testFoldingTableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: testFoldingTableView.insertSections([sectionIndex], with: .fade)
        case .delete: testFoldingTableView.deleteSections([sectionIndex], with: .fade)
        case .move: break
        case .update: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            testFoldingTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            testFoldingTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            testFoldingTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            testFoldingTableView.deleteRows(at: [indexPath!], with: .fade)
            testFoldingTableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        testFoldingTableView.endUpdates()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    

    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    
    
}
