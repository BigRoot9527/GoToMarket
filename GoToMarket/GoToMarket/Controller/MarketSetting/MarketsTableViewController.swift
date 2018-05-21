//
//  MarketsTableViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/19.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol MarketsTableViewControllerDelegate: class {
    
    func didSelectMarket(sender: UITableView, marketText: String?) -> Void
    
}

class MarketsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var marketsTableView: UITableView!
    
    weak var delegate: MarketsTableViewControllerDelegate?
    
    var itemTypePassed: TaskKeys? {
        
        didSet {
            
            if loadedMarketPassed != nil {
                
                marketsTableView.reloadData()
            }
        }
    }

    var loadedMarketPassed: String? {
        
        didSet {
            
            if itemTypePassed != nil {
                
                marketsTableView.reloadData()
            }
        }
    }
    
    var marketsArray: [String] {
        let array = itemTypePassed?.getMarketsOfItem() ?? [ GoToMarketConstant.noMarketsDataText ]
        return array
    }
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketCell", for: indexPath)
        
        if
            let oldMarket = loadedMarketPassed,
            marketsArray[indexPath.row] == oldMarket {
            
            cell.textLabel?.text = marketsArray[indexPath.row] + GoToMarketConstant.alreadyLoadedMarket
        
        } else {
            
            cell.textLabel?.text = marketsArray[indexPath.row]
        
        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //not allow user to select the Market already loaded
        let cellMarketText = marketsTableView.cellForRow(at: indexPath)?.textLabel?.text
        
        let inputMarketText = marketsArray[indexPath.row]
        
        if cellMarketText == inputMarketText {
            
            delegate?.didSelectMarket(sender: marketsTableView, marketText: cellMarketText)
            
        } else {
            
            marketsTableView.cellForRow(at: indexPath)?.isSelected = false
            
        }
        
    }
    
    
}
