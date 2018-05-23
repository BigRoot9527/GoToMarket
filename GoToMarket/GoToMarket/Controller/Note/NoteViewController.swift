//
//  NoteViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/23.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

private enum noteCellStatus {
    
    case open
    
    case close
    
    func height() -> CGFloat {
        switch self {
        case .open:
            return 210.0
        case .close:
            return 110.0
        }
    }
}


class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var noteTableView: UITableView!
    
    private var noteCellState: [noteCellStatus]? {
        didSet {
            print("been set!")
        }
    }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { fetchAndReloadData() } }
    var fetchedResultsController: NSFetchedResultsController<UserNotes>?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.estimatedRowHeight = noteCellStatus.close.height()
        registerCell()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAndReloadData()
    }

    //MARK: CoreData
    private func fetchAndReloadData() {
        
        if let context = container?.viewContext {
            
            let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
            
            request.sortDescriptors = [NSSortDescriptor(key: "isFinished", ascending: true)]
            
            request.predicate = NSPredicate(format: "isInCart = true")
            
            fetchedResultsController = NSFetchedResultsController<UserNotes>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            fetchedResultsController?.delegate = self
            
            try? fetchedResultsController?.performFetch()
            
            noteTableView.reloadData()
        }
    }

    
    private func registerCell() {
        
        let nibContent = UINib(nibName: "NoteTableViewCell", bundle: nil)
        
        noteTableView.register(
            nibContent,
            forCellReuseIdentifier: String(describing: NoteTableViewCell.self)
        )
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            
            let count = sections[section].numberOfObjects
            
            if noteCellState == nil {
                
                noteCellState = (0 ..< count).map{ _ in .close }
                
            }
            
            print("count = \(count)")
            
            return count
            
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: NoteTableViewCell.self),
            for: indexPath) as! NoteTableViewCell
        
        setupCell(atIndexpath: indexPath, cellBeforeInit: cell)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let state = noteCellState else {
            
            return 10.0
        }
        
        print(indexPath.row)
        
        return state[indexPath.row].height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard
            let cell = self.noteTableView.cellForRow(at: indexPath) as? NoteTableViewCell,
            var state = noteCellState else { return }
        
        if cell.isAnimating() {
            
            return
        }
        
        var duration = 0.0
        
        if state[indexPath.row] == .close { // open cell
            
            state[indexPath.row] = .open
            
            self.noteCellState = state
            
            setupCell(atIndexpath: indexPath, cellBeforeInit: nil)
            
            cell.unfold(true, animated: true, completion: nil)
            
            duration = 0.3
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                animations: {
                    
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    
            }, completion: nil)
            
        } else {// close cell
            
            state[indexPath.row] = .close
            
            self.noteCellState = state
            
            setupCell(atIndexpath: indexPath, cellBeforeInit: nil)
            
            cell.unfold(false, animated: true, completion: nil)
            
            duration = 0.3
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                animations: {
                    
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    
            }, completion: nil)
        }
        
        print("didSelect indexpath = \(indexPath)")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard
            let showingCell = cell as? NoteTableViewCell,
            let state = noteCellState
            else { return }

        switch state[indexPath.row] {

        case .close:
            //                        break
            showingCell.unfold(false, animated: false, completion: nil)

        case .open:
            //            showingCell.openAnimation{}
            showingCell.unfold(true, animated: false, completion: nil)
        }
    }
    
    
    private func setupCell(atIndexpath indexPath: IndexPath, cellBeforeInit newCell: NoteTableViewCell?) {
        
        guard
            let state = noteCellState,
            let note = fetchedResultsController?.object(at: indexPath),
            let cell = newCell ?? self.noteTableView.cellForRow(at: indexPath) as? NoteTableViewCell
            else { return }

        switch state[indexPath.row] {
            
        case .close:
            
            print("row: \(indexPath.row) = close")
            cell.topBuyingAmountLabel.text = String(note.buyingAmount)
            cell.topFinishButton.isSelected = note.isFinished
            //TODO
            cell.topWeightTypeLabel.text = "(每公斤)"
//            cell.unfold(false, animated: false, completion: nil)
            
            if let cropData = note.cropData {
                
                cell.topCellPriceLabel.text = String(cropData.newAveragePrice * note.customMutipler)
                cell.topItemNameLabel.text = cropData.cropName
            }
            
            
        case .open:
            
            cell.bottomFinishButton.isSelected = note.isFinished
            //TODO
            cell.bottomWeightTypeLabel.text = "(每公斤)"
            cell.bottomBuyingAmountTextField.text = String(note.buyingAmount)
//            cell.unfold(true, animated: false, completion: nil)
            
            if let cropData = note.cropData {
                
                cell.bottomItemNameLabel.text = cropData.cropName
                cell.bottomSellPriceLabel.text = String(cropData.newAveragePrice * note.customMutipler)
                cell.bottomNewRealPriceLabel.text = String(cropData.newAveragePrice)
                cell.bottomLastRealPriceLabel.text = String(cropData.lastAveragePrice)
            }
        }
    }
}
