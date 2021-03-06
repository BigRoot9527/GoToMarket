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

class ChartCollectionViewController: UIViewController {

    let manager = CropManager()
    let dispatchGroup = DispatchGroup()

    var historyDateArray: [[String]?] = [nil, nil]
    var histroyQuoteArray: [[Double]?] = [nil, nil]
    let loadingHistoryType: [HistoryPeriod] = [.fromLastMonth, .fromLastSeason]

    //Input
    var itemCode: String? {
        didSet {
            loadHistoryData()
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak var chartCollectionView: UICollectionView!
    @IBOutlet weak var chartPageControl: UIPageControl!

    //LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        chartCollectionView.delegate = self
        chartCollectionView.dataSource = self
        setCollectionViewLayout()
        setupUI()
    }

    private func setCollectionViewLayout() {

        let chartViewFlowLayout = UICollectionViewFlowLayout()

        let fullScreenSize = UIScreen.main.bounds.size
        chartViewFlowLayout.itemSize = CGSize(width: fullScreenSize.width - 10, height: 210.0)
        chartViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        chartViewFlowLayout.minimumInteritemSpacing = (fullScreenSize.width) * 0 / 375
        chartViewFlowLayout.scrollDirection = .horizontal
        chartCollectionView.setCollectionViewLayout(chartViewFlowLayout, animated: false)
        chartCollectionView.isDirectionalLockEnabled = true
        chartCollectionView.isPagingEnabled = true
        chartCollectionView.alwaysBounceVertical = false
        chartCollectionView.indicatorStyle = .black
        chartCollectionView.backgroundColor = UIColor(named: "NormalCellBackground_color")
    }

    private func registerCell() {

        let nibFile = UINib(nibName: "ChartCollectionViewCell", bundle: nil)

        chartCollectionView.register(nibFile,
                                    forCellWithReuseIdentifier: String(describing: ChartCollectionViewCell.self))
    }

    private func setupUI() {
        chartPageControl.currentPage = 0
        chartPageControl.numberOfPages = 2
        chartPageControl.pageIndicatorTintColor = UIColor.gray
    }

    private func loadHistoryData() {
        guard let code = itemCode else { return }

        dispatchGroup.enter()
        manager.getHistoryCropArray(
            cropCode: code,
            HistoryPeriod: .fromLastMonth,
            success: { [weak self] quoteArray in

                self?.historyDateArray[0] = quoteArray.map { $0.date }
                self?.histroyQuoteArray[0] = quoteArray.map { $0.averagePrice }
                self?.dispatchGroup.leave()

        }, failure: { [weak self] error in
            print("Error From ChartViewController: \(error)")
            self?.dispatchGroup.leave()
        })

        dispatchGroup.enter()
        manager.getHistoryCropArray(
            cropCode: code,
            HistoryPeriod: .fromLastSeason,
            success: { [weak self] quoteArray in

                self?.historyDateArray[1] = quoteArray.map { $0.date }
                self?.histroyQuoteArray[1] = quoteArray.map { $0.averagePrice }
                self?.dispatchGroup.leave()

        }, failure: { [weak self] error in
            print("Error From ChartViewController: \(error)")
            self?.dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) { [weak self] in

            self?.chartCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ChartCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadingHistoryType.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {

        let cell = chartCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ChartCollectionViewCell.self),
            for: indexPath)

        guard let chartCVCell = cell as? ChartCollectionViewCell else { return cell }

        guard
            let dateArray = historyDateArray[indexPath.row],
            let quoteArray = histroyQuoteArray[indexPath.row]
            else { return chartCVCell }
        //TODO: to return loading image

        chartCVCell.setChart(
            dataPoints: dateArray,
            values: quoteArray,
            period: loadingHistoryType[indexPath.row]
        )

        return chartCVCell
    }
}

// MARK: - UICollectionViewDelegate
extension ChartCollectionViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = Int(scrollView.contentOffset.x / chartCollectionView.frame.width )
        chartPageControl.currentPage = count
    }
}
