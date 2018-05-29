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
import SwiftMessages

class DetailViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailWikiImageView: UIImageView!
    //TODO: placeHolder and loading Image
    
    //Input
    var itemCodeInput: String?
    var titleHeroIdInput: String?
    var didTapBuyingCallBack: ((Bool) -> Void)?
    
    private let wikiManager = WikiManager()
    private let cropManager = CropManager()
    private var fetchedItem: CropDatas?
    private let rowTypes: [DetailRowType] = [.title, .intro, .empty, .history, .empty, .quotes ]
    private var wikiText: String = "Wiki 說明載入中...."
    private var showInKg: Bool = true
    private var introIndexPath: IndexPath?
    private var quoteIndexPath: IndexPath?
    
    //SwiftMessage
    private let incartNoticeView = MessageView.viewFromNib(layout: .cardView)
    private var messageConfig = SwiftMessages.Config()
    private var isAddingCart: Bool? {
        
        didSet {
            guard let bool = isAddingCart else { return }
            incartMessageText = bool ? "已加入待購清單"  : "已從清單中移除"
            incartImage = bool ? #imageLiteral(resourceName: "buy_icon") : #imageLiteral(resourceName: "delete_icon")
            setChangingProps()
        }
    }
    private var incartMessageText: String = ""
    private var incartImage: UIImage = UIImage()
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        registerCells()
        fetchItem()
        loadWikiData()
        setupIncartNoticeView()
        
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
    
    private func fetchItem() {
        guard
            let code = itemCodeInput,
            let itemData = cropManager.getCropData(formItemCode: code)
            else { return }
        
        self.fetchedItem = itemData
    }
    
    private func loadWikiData() {
        guard let itemData = fetchedItem else { return }
        
        wikiManager.getWikiImageUrl(
            fromItemName: itemData.cropName,
            success: { [weak self] (url) in
                
                let imageUrl = url ?? GoToMarketConstant.marketPlaceholderPictureUrl
                
                self?.detailWikiImageView.sd_setImage(with: imageUrl)
                
        }) { (error) in
            
            print(error)
            
        }
        
        wikiManager.getWikiText(fromItemName: itemData.cropName, success: { [weak self] (text) in
            
            var outputText = text ?? "查無 Wiki 資料"
            
            //TODO: get Real WIKI api and get correct corn text
            if itemData.cropName.trimed() == "玉米" {
                
                outputText = "玉米（學名：Zea mays）是一年生禾本科草本植物，是全世界總產量最高的重要糧食作物。同時也可以當作飼料使用，還有在生物科技產業作為乙醇燃料的原材料。而且玉米更在各個化工領域被大量利用著，做成塑膠等等不同的物品。"
            }
            //
            
            self?.wikiText = outputText
            
            guard let index = self?.introIndexPath else { return }
            
            self?.detailTableView.reloadRows(at: [index], with: .fade)
            
        }) { (error) in
            
            print(error)
        }
    }
    
    //MARK: - SwiftMessage
    private func setupIncartNoticeView() {
        
        incartNoticeView.configureTheme(.info, iconStyle: .default)
        incartNoticeView.configureBackgroundView(width: 220)
        incartNoticeView.configureIcon(withSize: CGSize(width: 40, height: 40), contentMode: .scaleAspectFit)
        incartNoticeView.button?.isHidden = true
        incartNoticeView.titleLabel?.isHidden = true
        incartNoticeView.alpha = 0.85
 
        messageConfig.duration = .seconds(seconds: 1)
        messageConfig.presentationStyle = .bottom
        messageConfig.ignoreDuplicates = false
    
        setChangingProps()
    }
    
    private func setChangingProps() {
        
        incartNoticeView.configureContent(body: incartMessageText)
        incartNoticeView.configureTheme(backgroundColor: UIColor.gray, foregroundColor: UIColor.white, iconImage: incartImage, iconText: nil)
    }
    
    
    //MARK: - IBAction
    @IBAction func didTabCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let showingType = rowTypes[indexPath.row]
        
        guard let crop = fetchedItem, let note = crop.note else { return UITableViewCell() }
        //TODO: to return loading image
        
        switch showingType {
            
        case .title:
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(
                    describing: DetailTitleTableViewCell.self),
                for: indexPath)
                as! DetailTitleTableViewCell
            
            if let heroID = titleHeroIdInput {
                
                cell.contentView.hero.id = heroID
            }
            
            cell.delegate = self
            
            cell.detailNameLabel.text = crop.cropName
            
            cell.isInCartInput = crop.note?.isInCart
            
            isAddingCart = crop.note?.isInCart
            
            return cell
            
        case .intro:
            
            introIndexPath = indexPath
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailIntroTableViewCell.self),
                for: indexPath) as! DetailIntroTableViewCell
            
            cell.detailWikiLabel.text = wikiText
            
            return cell
            
        case .quotes:
            
            quoteIndexPath = indexPath
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailQuotesTableViewCell.self),
                for: indexPath) as! DetailQuotesTableViewCell
            
            cell.delegate = self
            
            cell.detailMarketLabel.text = crop.marketName
            cell.detailUpdateTimeLabel.text = crop.date
            cell.weightTypeSegControl.selectedSegmentIndex = PriceStringProvider.shared.getSegmentedControlIndex()
            cell.detailSellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromSellingPrice: note.sellingPrice)
            cell.detailRealPriceLabel.text = PriceStringProvider.shared.getTruePriceString(
                fromTruePrice: crop.newAveragePrice)
            
            return cell
            
            
        case .history:
            
            let cell = detailTableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailHistoryTableViewCell.self),
                for: indexPath) as! DetailHistoryTableViewCell
            
            addChartVC(toCell: cell, ofItemCode: crop.cropCode)
            
            return cell
        case .empty:
            
            let cell = UITableViewCell()
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    private func addChartVC(toCell cell: UITableViewCell, ofItemCode code: String) {
        
        guard
            let chartVC = storyboard?.instantiateViewController(withIdentifier: String(describing: ChartCollectionViewController.self)) as? ChartCollectionViewController,
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
        //TODO: not to always been reuse and reload the api data
    }
}

//MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowTypes[indexPath.row].heightForRow()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if detailTableView.contentOffset.y < -50 {
            
            dismiss(animated: true, completion: nil)
        }
    }
}


//MARK: - DetailTableViewCellDelegate
extension DetailViewController: DetailTableViewCellDelegate {
    
    func buyingButtonTapped(sender: UIButton) {
        guard let callBack = didTapBuyingCallBack else { return }
        callBack(sender.isSelected)
        
        //SwiftMessage
        isAddingCart = sender.isSelected
        SwiftMessages.hideAll()
        SwiftMessages.show(config: messageConfig, view: incartNoticeView)
        
    }
    
    func changeWeightButtonTapped(sender: UISegmentedControl, fromCell: DetailQuotesTableViewCell) {
        
        PriceStringProvider.shared.showInKg = !PriceStringProvider.shared.showInKg
        
        guard
            let cropData = fetchedItem,
            let note = cropData.note else { return }
        
        fromCell.detailSellPriceLabel.text = PriceStringProvider.shared.getSellPriceString(fromSellingPrice: note.sellingPrice)
        
        fromCell.detailRealPriceLabel.text = PriceStringProvider.shared.getTruePriceString(fromTruePrice: cropData.newAveragePrice)
        
        fromCell.weightTypeSegControl.selectedSegmentIndex = PriceStringProvider.shared.getSegmentedControlIndex()
    }
    
    func priceInfoButtonTapped(sender: UIButton) {
        
        guard let cropData = fetchedItem else { return }
        
        let calculateVC = UIStoryboard.calculate().instantiateInitialViewController() as! CalculateViewController
        
        calculateVC.itemCodeInput = cropData.cropCode
        calculateVC.dismissCallBack = { [weak self] in
            
            self?.fetchItem()
            self?.detailTableView.reloadData()
            
        }
        
        calculateVC.hero.isEnabled = true
        calculateVC.hero.modalAnimationType = .fade
        
        calculateVC.modalPresentationStyle = .overFullScreen
        
        present(calculateVC, animated: true, completion: nil)
    }
}
