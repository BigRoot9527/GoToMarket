//
//  ChartViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/17.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var itemCode: String?
    let manager = CropManager()
    
    

    @IBOutlet weak var chartCollectionView: UICollectionView!
    
    
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    

    
    
    
    //LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        chartCollectionView.delegate = self
        chartCollectionView.dataSource = self
        registerCell()
        loadHistoryData()
    }
    
    private func registerCell() {
        
        let nibFile = UINib(nibName: "ChartCollectionViewCell", bundle: nil)
        
        chartCollectionView.register(nibFile, forCellWithReuseIdentifier: String(describing: ChartCollectionViewCell.self))
    }
    
    private func loadHistoryData() {
        
    }
    
}
