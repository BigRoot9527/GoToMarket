//
//  NoteViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/23.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var toolMenuBarButton: UIBarButtonItem!
    @IBOutlet weak var weightTypeSegControl: UISegmentedControl!
    @IBOutlet weak var toolBarTopToSafeAreaConstraint: NSLayoutConstraint!
    
    //MARK: ToolBar(Opened, Closed) ContraintConstant To SafeArea
    let topConstant: (CGFloat, CGFloat) = ( 0.0, 50.0 )

    //MARK: - ChangeCellView
    private let openedCellHeight: CGFloat = 210.0
    private let closedCellHeight: CGFloat = 110.0
    
    private var openedCellIndex: IndexPath? {
        didSet {
            setupCell(index: oldValue, toOpen: false)
            setupCell(index: openedCellIndex, toOpen: true)
        }
    }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var fetchedResultsController: NSFetchedResultsController<UserNotes>?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
        noteTableView.reloadData()
        updateUI()
    }
    
    private func setupTableView() {
        
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.estimatedRowHeight = closedCellHeight
        noteTableView.rowHeight = UITableViewAutomaticDimension
        registerCell()
    }
    
    private func setupNav() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func registerCell() {
        
        let nibContent = UINib(nibName: "NoteTableViewCell", bundle: nil)
        
        noteTableView.register(
            nibContent,
            forCellReuseIdentifier: String(describing: NoteTableViewCell.self)
        )
    }
    
    private func updateUI() {
        
        weightTypeSegControl.selectedSegmentIndex = PriceStringProvider.shared.getSegmentedControlIndex()
        
        toolBarTopToSafeAreaConstraint.constant = topConstant.1
    }
    
    //MARK: - Open-Close Switch
    private func setupCell(index: IndexPath?, toOpen: Bool) {
        
        guard let openIndex = index , let cell = noteTableView.cellForRow(at: openIndex) as? NoteTableViewCell else { return } 
        
        cell.isOpened = toOpen
    }
    
    //MARK: - IBAction
    @IBAction func didTapToolMenuBarButton(_ sender: UIBarButtonItem) {
        
        toolBarTopToSafeAreaConstraint.constant = toolBarTopToSafeAreaConstraint.constant == topConstant.0 ? topConstant.1 : topConstant.0
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction func weightTypeSegControlDidChange(_ sender: UISegmentedControl) {
        
        
        PriceStringProvider.shared.showInKg = !PriceStringProvider.shared.showInKg
        noteTableView.reloadData()
    }
}


//MARK: - NSFetchedResultsControllerDelegate
extension NoteViewController: NSFetchedResultsControllerDelegate {
    
    private func fetchData(sortDescriptors: [NSSortDescriptor] = [GoToMarketConstant.noteBasicNSSortDecriptor]) {
        
        if let context = container?.viewContext {
            
            context.reset()
            
            let request: NSFetchRequest<UserNotes> = UserNotes.fetchRequest()
            
            request.sortDescriptors = sortDescriptors
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
}


//MARK: - TableView DataSource
extension NoteViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            
            let count = sections[section].numberOfObjects

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
            sellingPrice: note.sellingPrice,
            truePrice: cropData.newAveragePrice,
            lastTruePrice: cropData.lastAveragePrice,
            buyingAmount: note.buyingAmount,
            buttonsDelegate: self,
            bottomTextFieldDelegate: self,
            bottomTextFieldTag: indexPath
        )
        
        //Hero
        cell.bottomPriceInfoButton.imageView?.hero.isEnabled = false
        cell.bottomPriceInfoButton.imageView?.hero.id = nil
        
        return cell
    }
    
}

//MARK: - TableView Delegate
extension NoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == openedCellIndex {
            
            return openedCellHeight
            
        } else {
            
            return closedCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var reloadIndexArray: [IndexPath] = []
        
        if let oldOpendCellIndex = openedCellIndex {
            
            reloadIndexArray.append(oldOpendCellIndex)
        }
        
        openedCellIndex = indexPath == openedCellIndex ? nil : indexPath
    
        reloadIndexArray.append(indexPath)
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        noteTableView.reloadRows(at: reloadIndexArray, with: .fade)
        
        print("reload:  \(reloadIndexArray)")
    }
    
}

//MARK: - UITextFieldDelegate
extension NoteViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty { return true }
        
        if Int(newText) != nil { return true }
        
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
        
        let index = IndexPath(row: textField.tag, section: 0)
        
        guard let note = fetchedResultsController?.object(at: index) else { return }
        
        let text = textField.text ?? "0"
        note.buyingAmount = Int16(text) ?? 0
        
        try? self.container?.viewContext.save()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - NoteToolBarViewControllertDelegate
extension NoteViewController: NoteToolBarViewControllertDelegate {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NoteToolBarVCSegue" {
            
            if let toolBarVC = segue.destination as? NoteToolBarViewController {
                
                toolBarVC.delegate = self
            }
        }
    }
    
    func sortButtonsTapped(sender: UIViewController, sortDescriptor: [NSSortDescriptor]) {
        
        guard let noteCount = fetchedResultsController?.fetchedObjects?.count, noteCount > 0
            else { return }
        
        fetchData(sortDescriptors: sortDescriptor)
        noteTableView.reloadData()
        let idexPath = IndexPath(row: 0, section: 0)
        noteTableView.scrollToRow(at: idexPath, at: .top, animated: true)
    }
    
    func deleteAllButtonTapped(sender: UIButton) {
        
        guard let noteCount = fetchedResultsController?.fetchedObjects?.count, noteCount > 0
            else { return }
        
        for _ in 0...noteCount - 1 {
            
            let firstIndex = IndexPath(row: 0, section: 0)
            
            deleteNote(fromIndexpath: firstIndex)
        }
    }
    
    func cleanAllButtonTapped(sender: UIButton) {
        
        guard
            let noteArray = fetchedResultsController?.fetchedObjects,
            noteArray.count > 0 else { return }
        
        for note in noteArray {
            
            note.isFinished = NoteConstant.initialIsFinished
            note.buyingAmount = NoteConstant.initialBuyingAmount
        }
        
        try? self.container?.viewContext.save()
        
        fetchData()
        noteTableView.reloadData()
    }
}


//MARK: - NoteTableViewCellDelegates
extension NoteViewController: NoteTableViewCellDelegate {
    
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
        
        guard let tappedIndexPath = noteTableView.indexPath(for: fromCell) else { return }
        
        deleteNote(fromIndexpath: tappedIndexPath)
    }
    
    func didTapStepper(sender: UIStepper, fromCell: NoteTableViewCell) {
        
        fromCell.bottomBuyingAmountTextField.text = "\(Int(sender.value))"
        
        let textFieldString = fromCell.bottomBuyingAmountTextField.text ?? "0"
        
        sender.value = Double(textFieldString) ?? 0.0
        
        guard
            let tappedIndexPath = noteTableView.indexPath(for: fromCell),
            let note = fetchedResultsController?.object(at: tappedIndexPath)
            else { return }
        
        note.buyingAmount = Int16(sender.value)
        
        try? self.container?.viewContext.save()
    }
    
    func didTapPriceInfoButton(sender: UIButton, fromCell: NoteTableViewCell) {
        
        guard
            let tappedIndexPath = noteTableView.indexPath(for: fromCell),
            let note = fetchedResultsController?.object(at: tappedIndexPath)
            else { return }
        
        let calculateVC = UIStoryboard.calculate().instantiateInitialViewController() as! CalculateViewController
        
        calculateVC.itemCodeInput = note.itemCode
        calculateVC.dismissCallBack = { [weak self] in
            
            self?.fetchData()
            self?.noteTableView.reloadData()
        }

        fromCell.bottomPriceInfoButton.imageView?.hero.isEnabled = true
        fromCell.bottomPriceInfoButton.imageView?.hero.id = "infoImage"
        calculateVC.hero.isEnabled = true
        calculateVC.hero.modalAnimationType = .fade
        
        calculateVC.modalPresentationStyle = .overFullScreen
        
        present(calculateVC, animated: true, completion: nil)
    }
    
    private func deleteNote(fromIndexpath index: IndexPath) {
        
        guard
            let note = fetchedResultsController?.object(at: index)
            else { return }
        
        try? note.setInCart(isInCart: false, inContext: self.container?.viewContext)
        
        fetchData()
        
        noteTableView.deleteRows(at: [index], with: .fade)
        
        openedCellIndex = nil
        
        noteTableView.reloadData()
        
        guard let count = fetchedResultsController?.fetchedObjects?.count else { return }
        
        showingCartAnimation( isInChart: false, fromCellFrame: nil, cellTableView: nil) { [weak self] in
            
            self?.postCartNotification(count: count)
        }
    }
}

