//
//  CollectionViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/17.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Charts

class ChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartView.noDataTextColor = GoToMarketColor.newDarkBlueGreen.color()
        chartView.noDataText = "～資料下載中～"
    }
    
    
    func setChart(dataPoints: [String], values: [Double], period: HistoryPeriod) {
        
        let average = values.average
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(
            values: dataEntries,
            label: period.getLineChartLabelText())
        
        lineChartDataSet.setColor(GoToMarketColor.newLightBlueGreen.color())
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.lineWidth = 3.0
        
        let label = GoToMarketConstant.lineCharLimitLineNamePrefix
            + String(format:"%.2f", average)
            + GoToMarketConstant.lineCharLimitLineNamePostfix
        let averageLine = ChartLimitLine(limit: average, label: label)
        averageLine.lineWidth = 1.5
        averageLine.lineDashLengths = [5,5]
        averageLine.labelPosition = .rightTop
        averageLine.valueFont = .systemFont(ofSize: 12)
        averageLine.valueTextColor = GoToMarketColor.newOrange.color()
        averageLine.lineColor = GoToMarketColor.newOrange.color()

        var dataSets = [IChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        let lineChartData = LineChartData(dataSets: dataSets)
        
        chartView.data = lineChartData
        chartView.leftAxis.addLimitLine(averageLine)
        
        let xAxis = chartView.xAxis
        xAxis.drawLabelsEnabled = false
//        xAxis.drawAxisLineEnabled = false
//        xAxis.drawGridLinesEnabled = false
        
        let fromDate = dataPoints.first ?? ""
        let toDate = dataPoints.last ?? ""
        chartView.chartDescription?.text =
            GoToMarketConstant.lineChartDescriptionString + fromDate + " ～ " + toDate
    }
}
