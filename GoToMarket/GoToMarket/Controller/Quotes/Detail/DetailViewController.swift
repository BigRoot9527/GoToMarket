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
    
   
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailWikiImageView: UIImageView!
    //TODO: placeHolder and loading Image
    
    var objectPassed: CropDatas?
    let manager = WikiManager()
    let rowTypes: [DetailRowType] = [.title, .intro, .quotes, .history]
    var wikiText: String = "Wiki說明下載中...."
    var showInKg: Bool = true
    var introIndexPath: IndexPath?
    
    
    func buyingButtonTapped(sender: UIButton) {
        print("\(sender) Tapped!")
    }
    
    func changeWeightButtonTapped(sender: UIButton) {
        print("\(sender) Tapped!")
    }
    
    func priceInfoButtonTapped(sender: UIButton) {
        print("\(sender) Tapped!")
    }
    
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let showingType = rowTypes[indexPath.row]
        
        guard let crop = objectPassed, let note = crop.note else { return UITableViewCell() }
        //TODO: to return loading image
        
        switch showingType {
            
        case .title:
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailTitleTableViewCell.self),
                for: indexPath) as! DetailTitleTableViewCell
            
            cell.delegate = self
            
            cell.detailNameLabel.text = crop.cropName
//            cell.inBuyingChart = note.
            
            return cell
            
        case .intro:
            
            introIndexPath = indexPath
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailIntroTableViewCell.self),
                for: indexPath) as! DetailIntroTableViewCell
            
            cell.detailWikiLabel.text = wikiText
            
            return cell
            
        case .quotes:
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailQuotesTableViewCell.self),
                for: indexPath) as! DetailQuotesTableViewCell
            
            cell.delegate = self
            
            cell.detailMarketLabel.text = crop.marketName
            cell.detailUpdateTimeLabel.text = crop.date
            cell.detailSellPriceLabel.text = PriceStringProvider.getSellPriceString(
                fromTruePrice: crop.averagePrice,
                andMultipler: note.customMutipler,
                inKg: showInKg)
            cell.detailRealPriceLabel.text = PriceStringProvider.getTruePriceString(
                fromTruePrice: crop.averagePrice,
                inKg: showInKg)
            
            return cell

            
        case .history:
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailHistoryTableViewCell.self),
                for: indexPath) as! DetailHistoryTableViewCell
            
            addChartVC(toCell: cell, ofItemCode: crop.cropCode)
            
            return cell
        }
    }
    
    private func addChartVC(toCell cell: UITableViewCell, ofItemCode code: String) {
        
        guard
            let chartVC = storyboard?.instantiateViewController(withIdentifier: String(describing: ChartViewController.self)) as? ChartViewController,
            let historyCell = cell as? DetailHistoryTableViewCell else { return }
        
        addChildViewController(chartVC)
        
        chartVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        historyCell.detailHistoryPriceContentView.addSubview(chartVC.view)
        
        NSLayoutConstraint.activate([
            
            chartVC.view.topAnchor.constraint(equalTo: historyCell.detailHistoryPriceContentView.topAnchor),
            chartVC.view.leadingAnchor.constraint(equalTo: historyCell.detailHistoryPriceContentView.leadingAnchor),
            chartVC.view.bottomAnchor.constraint(equalTo: historyCell.detailHistoryPriceContentView.bottomAnchor),
            chartVC.view.trailingAnchor.constraint(equalTo: historyCell.detailHistoryPriceContentView.trailingAnchor)
            
            ])
        
        chartVC.didMove(toParentViewController: self)
        
        chartVC.itemCode = code
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowTypes[indexPath.row].heightForRow()
        
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
        registerCells()
        loadWikiData()
    }
    
    private func registerCells() {
        
        let titleNib = UINib(nibName: "DetailTitleTableViewCell", bundle: nil)
        detailTableView.register(titleNib,forCellReuseIdentifier: String(describing: DetailTitleTableViewCell.self))
        
        let introNib = UINib(nibName: "DetailIntroTableViewCell", bundle: nil)
        detailTableView.register(introNib,forCellReuseIdentifier: String(describing: DetailIntroTableViewCell.self))
        
        let quotesNib = UINib(nibName: "DetailQuotesTableViewCell", bundle: nil)
        detailTableView.register(quotesNib,forCellReuseIdentifier: String(describing: DetailQuotesTableViewCell.self))
        
        let historyNib = UINib(nibName: "DetailHistoryTableViewCell", bundle: nil)
        detailTableView.register(historyNib,forCellReuseIdentifier: String(describing: DetailHistoryTableViewCell.self))
        
    }
    
    private func loadWikiData() {
        guard let itemData = objectPassed else { return }
        
        manager.getWikiImageUrl(
            
            fromItemName: itemData.cropName,
            success: { [weak self] (url) in
                
            let imageUrl = url ?? GoToMarketConstant.marketPlaceholderPictureUrl
            self?.detailWikiImageView.sd_setImage(with: imageUrl)

        }) { (error) in
            
            print(error)
            
        }
        
        manager.getWikiText(fromItemName: itemData.cropName, success: { [weak self] (text) in
            
            let outputText = text ?? "查無Wiki資料"
            
            self?.wikiText = outputText
            
            guard let index = self?.introIndexPath else { return }
            
            self?.detailTableView.reloadRows(at: [index], with: .fade)
            
        }) { [weak self] (error) in
            
            print(error)
            
        }
        
        
    }

    
    @IBAction func didTabCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
