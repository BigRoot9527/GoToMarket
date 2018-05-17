//
//  DetailViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/15.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailTableViewCellDelegate {
    
    
    func dropDownButtonTapped(sender: UIButton, isExpended: Bool) {
        print("\(sender) Tapped!, isExpended = \(isExpended)")
    }
    
    func priceInfoButtonTapped(sender: UIButton) {
        print("\(sender) Tapped!")
    }
    
    func buyingButtonTapped(sender: UIButton, inChart: Bool) {
        print("\(sender) Tapped!, inBuying = \(inChart)")
    }
    
    func changeWeightButtonTapped(sender: UIButton, showingInKg: Bool) {
        print("\(sender) Tapped!, showingInKg = \(showingInKg)")
    }
    
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    
    var objectPassed: CropDatas?
    var showingWeightType: WeightType = .KG
    let manager = WikiManager()
    let dispatchGroup = DispatchGroup()
    var wikiText: String?
    var wikiImageUrl: URL?
    
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = detailTableView.dequeueReusableCell(withIdentifier: String(describing: DetailTableViewCell.self), for: indexPath) as! DetailTableViewCell
        
        guard let crop = objectPassed, let note = crop.note else { return UITableViewCell() }
        
        cell.delegate = self
        
        cell.detailWikiImageView.sd_setImage(with: wikiImageUrl)
        
        if let text = wikiText {
            cell.detailWikiLabel.text = text
            cell.wikiTextState = .folded
        } else {
            cell.wikiTextState = .none
        }
        
        cell.detailNameLabel.text = crop.cropName
//        cell.inBuyingChart = note.
        
        cell.detailMarketLabel.text = crop.marketName
        cell.detailUpdateTimeLabel.text = crop.date
        cell.detailSellPriceLabel.text = PriceStringProvider.getSellPriceString(
            fromTruePrice: crop.averagePrice,
            andMultipler: note.customMutipler,
            inWeightType: showingWeightType)
        cell.detailRealPriceLabel.text = PriceStringProvider.getTruePriceString(
            fromTruePrice: crop.averagePrice,
            inWeightType: showingWeightType)
        cell.detailWeightTypeLabel.text = showingWeightType.rawValue
//        cell.detailHistoryPriceView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //TODO
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
        loadWikiData()
        updateUI()
    }
    
    private func registerCell() {
        let nibFile = UINib(nibName: "DetailTableViewCell", bundle: nil)
        detailTableView.register(nibFile,
                                 forCellReuseIdentifier: String(describing: DetailTableViewCell.self))
    }
    
    private func loadWikiData() {
        guard let itemData = objectPassed else { return }
        
        dispatchGroup.enter()
        manager.getWikiImageUrl(
            fromItemName: itemData.cropName,
            success: { [weak self] (url) in
            
            self?.wikiImageUrl = url
            
            self?.dispatchGroup.leave()
            
        }) { [weak self] (error) in
            
            print(error)
            
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        manager.getWikiText(fromItemName: itemData.cropName, success: { [weak self] (text) in
            
            self?.wikiText = text
            
            self?.dispatchGroup.leave()
            
        }) { [weak self] (error) in
            
            print(error)
            
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.detailTableView.reloadData()
        }
        
        
    }
    
    private func updateUI() {
        
    }
    

    
    @IBAction func didTabCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
