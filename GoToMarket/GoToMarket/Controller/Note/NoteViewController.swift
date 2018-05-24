//
//  NoteViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/23.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate,NoteTableViewCellDelegate {
    
    @IBOutlet weak var noteTableView: UITableView!
    
    //MARK: ChangeCellView
    private let openedCellHeight: CGFloat = 210.0
    private let closedCellHeight: CGFloat = 110.0
    
    private var openedCellIndex: IndexPath? {
        didSet {
            setupCell(index: oldValue, toOpen: false)
            setupCell(index: openedCellIndex, toOpen: true)
        }
    }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer  {
            didSet {
                fetchData()
                noteTableView.reloadData()
        }
        
    }
    
    var fetchedResultsController: NSFetchedResultsController<UserNotes>?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.estimatedRowHeight = closedCellHeight
        noteTableView.rowHeight = UITableViewAutomaticDimension
        registerCell()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        noteTableView.reloadData()
        
        
    }

    //MARK: CoreData
    private func fetchData() {
        
        if let context = container?.viewContext {
            
            let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
            
            request.sortDescriptors = [NSSortDescriptor(key: "isFinished", ascending: true)]
            
            request.predicate = NSPredicate(format: "(isInCart = true) AND (cropData != nil)")
            
            fetchedResultsController = NSFetchedResultsController<UserNotes>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            
            fetchedResultsController?.delegate = self
            
            try? fetchedResultsController?.performFetch()
            
        }
    }

    
    private func registerCell() {
        
        let nibContent = UINib(nibName: "NoteTableViewCell", bundle: nil)
        
        noteTableView.register(
            nibContent,
            forCellReuseIdentifier: String(describing: NoteTableViewCell.self)
        )
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            
            let count = sections[section].numberOfObjects
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
        guard
            let note = fetchedResultsController?.object(at: indexPath),
            let cropData = note.cropData
            else { return UITableViewCell() }
        
        cell.setupCellView(
            showingOpened: indexPath == openedCellIndex,
            buttonShowFinished: note.isFinished,
            itemName: cropData.cropName,
            truePrice: cropData.newAveragePrice,
            multipler: note.customMutipler,
            lastTruePrice: cropData.lastAveragePrice,
            buyingAmount: note.buyingAmount,
            buttonsDelegate: self,
            bottomTextFieldDelegate: self
        )
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print("index.row = \(indexPath.row)")
        
        if indexPath == openedCellIndex {
            
            return openedCellHeight
            
        } else {
            
            return closedCellHeight
        }
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openedCellIndex = indexPath == openedCellIndex ? nil : indexPath
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    //MARK: Open-Close Switch
    private func setupCell(index: IndexPath?, toOpen: Bool) {
        
        guard let openIndex = index , let cell = noteTableView.cellForRow(at: openIndex) as? NoteTableViewCell else { return } 
        
        cell.isOpened = toOpen
    }

    
    //MARK: TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            
            return true
        }
        
        if let intValue = Int(newText) {
            
            switch intValue {
            case ..<999:
                return true
            case 999...:
                textField.text = "999"
                return false
            default:
                return false
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "0" {
            textField.text = ""
        }
        
        noteTableView.isScrollEnabled = false
        noteTableView.allowsSelection = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        noteTableView.isScrollEnabled = true
        noteTableView.allowsSelection = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: NoteTableViewCellDelegates
    func didTapFinishedButton(sender: UIButton, fromCell: NoteTableViewCell) {
        
        guard
            let tappedIndexPath = noteTableView.indexPath(for: fromCell),
            let note = fetchedResultsController?.object(at: tappedIndexPath)
            else { return }
        
        sender.isSelected = !sender.isSelected
        
        note.isFinished = sender.isSelected
        
        try? self.container?.viewContext.save()
    }
    
    func didTapDeleteButton(sender: UIButton, fromCell: NoteTableViewCell) {
        
        guard
            let tappedIndexPath = noteTableView.indexPath(for: fromCell),
            let note = fetchedResultsController?.object(at: tappedIndexPath)
            else { return }
        
        note.isInCart = false
        
        try? self.container?.viewContext.save()
        
        fetchData()
        
        noteTableView.deleteRows(at: [tappedIndexPath], with: .fade)
        
    }
    
    func didTapStepper(sender: UIStepper, fromCell: NoteTableViewCell) {
        print("QQ")
    }
    
    func didTapPriceInfoButton(sender: UIButton, fromCell: NoteTableViewCell) {
        print("QQ")
    }
    
    
    //MARK: Animation&Notification
    

    
    
    
}
