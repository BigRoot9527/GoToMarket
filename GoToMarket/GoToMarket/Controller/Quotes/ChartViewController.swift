//
//  ChartViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/17.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Charts
import Hero

class ChartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let manager = CropManager()
    let dispatchGroup = DispatchGroup()
    let ChartViewFlowLayout = UICollectionViewFlowLayout()
    
    var historyDateArray: [[String]?] = [nil,nil]
    var histroyQuoteArray: [[Double]?] = [nil,nil]
    let loadingHistoryType: [HistoryPeriod] = [.fromLastMonth, .fromLastSeason]
    
    var itemCode: String? {
        didSet {
            loadHistoryData()
        }
    }
    
    
    
    @IBOutlet weak var chartCollectionView: UICollectionView!
    
    
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadingHistoryType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = chartCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ChartCollectionViewCell.self),
            for: indexPath)
            as! ChartCollectionViewCell
        
        guard
            let dateArray = historyDateArray[indexPath.row],
            let quoteArray = histroyQuoteArray[indexPath.row]
            else { return cell }
        //TODO: to return loading image
        
        cell.setChart(
            dataPoints: dateArray,
            values: quoteArray,
            period: loadingHistoryType[indexPath.row]
        )
        
        return cell
        
    }
    

    
    
    
    //LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        chartCollectionView.delegate = self
        chartCollectionView.dataSource = self
        setCollectionViewLayout()
        
    }
    
    private func setCollectionViewLayout() {
        let fullScreenSize = UIScreen.main.bounds.size
        ChartViewFlowLayout.itemSize = CGSize(width: fullScreenSize.width - 7, height: 210.0)
        ChartViewFlowLayout.minimumInteritemSpacing = (fullScreenSize.width) * 0 / 375
//        ChartViewFlowLayout.minimumLineSpacing = (fullScreenSize.height) * 5 / 667
        ChartViewFlowLayout.scrollDirection = .horizontal
        chartCollectionView.setCollectionViewLayout(ChartViewFlowLayout, animated: false)
        chartCollectionView.isDirectionalLockEnabled = true
        chartCollectionView.isPagingEnabled = true
        chartCollectionView.alwaysBounceVertical = false
        chartCollectionView.indicatorStyle = .black
    }
    
    private func registerCell() {
        
        let nibFile = UINib(nibName: "ChartCollectionViewCell", bundle: nil)
        
        chartCollectionView.register(nibFile,
                                    forCellWithReuseIdentifier: String(describing: ChartCollectionViewCell.self))
    }
    
    private func loadHistoryData() {
        guard let code = itemCode else { return }
        
        dispatchGroup.enter()
        manager.getHistoryCropArray(
            CropCode: code,
            HistoryPeriod: .fromLastMonth,
            success: { [weak self] quoteArray in
                
                self?.historyDateArray[0] = quoteArray.map{ $0.date }
                self?.histroyQuoteArray[0] = quoteArray.map{ $0.averagePrice }
                self?.dispatchGroup.leave()
                
        }){ [weak self] error in
            print("Error From ChartViewController: \(error)")
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        manager.getHistoryCropArray(
            CropCode: code,
            HistoryPeriod: .fromLastSeason,
            success: { [weak self] quoteArray in
                
                self?.historyDateArray[1] = quoteArray.map{ $0.date }
                self?.histroyQuoteArray[1] = quoteArray.map{ $0.averagePrice }
                self?.dispatchGroup.leave()
                
        }){ [weak self] error in
            print("Error From ChartViewController: \(error)")
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            
            self?.chartCollectionView.reloadData()
        }
    }
}
