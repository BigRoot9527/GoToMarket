//
//  QuotesViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/13.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

private enum cellStatus {
    
    case open
    
    case close

    func height() -> CGFloat {
        switch self {
        case .open:
            return 480.0
        case .close:
            return 80.0
        }
    }
}

class TestFoldingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var testFoldingTableView: UITableView!
    private var cellStates: [cellStatus]? {
        didSet {
            print("been set!")
        }
    }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
 
    var fetchedResultsController: NSFetchedResultsController<CropDatas>?
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestFoldingTableViewCell", for: indexPath) as! TestFoldingTableViewCell
        if let crop = fetchedResultsController?.object(at: indexPath),
            let state = cellStates {
            
            switch state[indexPath.row] {
                
            case .close:
                print("row: \(indexPath.row) = close")
                cell.itemNameLabel.text = crop.cropName
                cell.itemNewPrice.text = String(crop.newAveragePrice)
//                cell.titleMarkButton
                
            case .open:
                print("row: \(indexPath.row) = open")
//                cell.itemNameLabel.text = crop.cropName
//                cell.itemNewPrice.text = String(crop.averagePrice)
//                cell.detailIntroLabel
//                cell.detailHistoryContainerView
//                cell.detailIntroScrollView
//                cell.detailItemImageView
//                cell.detailMarkButton
                cell.detailItemNameLabel.text = crop.cropName
                cell.detailItemNewPrice.text = String(crop.newAveragePrice)
                cell.detailUpdateTimeLabel.text = crop.date
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            let count = sections[section].numberOfObjects
            if cellStates == nil {
                cellStates = (0 ..< count).map{ _ in .close }
            }
            print("count = \(count)")
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let state = cellStates else { return 10.0 }
        return state[indexPath.row].height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = self.testFoldingTableView.cellForRow(at: indexPath) as? TestFoldingTableViewCell, var state = cellStates else { return }
        var duration = 0.0
        if state[indexPath.row] == .close { // open cell
            state[indexPath.row] = .open
            self.cellStates = state
            updateCell(atIndexpath: indexPath)
            cell.openAnimation {}
            duration = 0.5
        } else {// close cell
            state[indexPath.row] = .close
            self.cellStates = state
            updateCell(atIndexpath: indexPath)
            cell.closeAnimation {}
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    private func updateCell(atIndexpath indexPath: IndexPath) {
        guard let cell = self.testFoldingTableView.cellForRow(at: indexPath) as? TestFoldingTableViewCell, let state = cellStates, let crop = fetchedResultsController?.object(at: indexPath) else { return }
        switch state[indexPath.row] {
        case .close:
            cell.itemNameLabel.text = crop.cropName
            cell.itemNewPrice.text = String(crop.newAveragePrice)
//            cell.titleMarkButton
        case .open:
//            cell.itemNameLabel.text = crop.cropName
//            cell.itemNewPrice.text = String(crop.averagePrice)
//            cell.detailIntroLabel
//            cell.detailHistoryContainerView
//            cell.detailIntroScrollView
//            cell.detailItemImageView
//            cell.detailMarkButton
            cell.detailItemNameLabel.text = crop.cropName
            cell.detailItemNewPrice.text = String(crop.newAveragePrice)
            cell.detailUpdateTimeLabel.text = crop.date
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let showingCell = cell as? TestFoldingTableViewCell,
            let state = cellStates else { return }
        
        switch state[indexPath.row] {
            
        case .close:
//            break
            showingCell.unfold(false, animated: false, completion: nil)
            
        case .open:
//            showingCell.openAnimation{}
            showingCell.unfold(true, animated: false, completion: nil)
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        testFoldingTableView.delegate = self
        testFoldingTableView.dataSource = self
        registerCell()
        updateUI()
    }
    
    private func updateUI() {
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
            testFoldingTableView.reloadData()
        }
    }
    
    private func registerCell() {
        let nibContent = UINib(nibName: "TestFoldingTableViewCell", bundle: nil)
        testFoldingTableView.register(nibContent, forCellReuseIdentifier: "TestFoldingTableViewCell")
    }
}
