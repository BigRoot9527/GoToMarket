//
//  DetailViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    var objectPassed: CropDatas?
    var showingWeightType: WeightType = .KG
    
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = detailTableView.dequeueReusableCell(withIdentifier: String(describing: DetailTableViewCell.self), for: indexPath) as! DetailTableViewCell
        
        guard let crop = objectPassed, let note = crop.note else { return UITableViewCell() }
        
//        cell.detailWikiImageView
//        cell.detailWikiLabel
        cell.detailNameLabel.text = crop.cropName
//        cell.inBuyingChart = note.
        
        cell.detailMarketLabel.text = crop.marketName
        cell.detailUpdateTimeLabel.text = crop.date
        cell.detailSellPriceLabel.text = PriceStringProvider.getSellPriceString(fromTruePrice: crop.averagePrice, andMultipler: note.customMutipler, inWeightType: showingWeightType)
        cell.detailRealPriceLabel.text = PriceStringProvider.getTruePriceString(fromTruePrice: crop.averagePrice, inWeightType: showingWeightType)
        cell.detailWeightTypeLabel.text = showingWeightType.rawValue
//        cell.detailHistoryPriceView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GoToMarketConstant.detailExpendRowHeight
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if detailTableView.contentOffset.y < -50 {
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.dataSource = self
        detailTableView.delegate = self
        registerCell()
        updateUI()
    }
    
    private func updateUI() {
        
    }
    
    private func registerCell() {
        let nibFile = UINib(nibName: "DetailTableViewCell", bundle: nil)
        detailTableView.register(nibFile,
                                 forCellReuseIdentifier: String(describing: DetailTableViewCell.self))
    }
    
    @IBAction func didTabCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
