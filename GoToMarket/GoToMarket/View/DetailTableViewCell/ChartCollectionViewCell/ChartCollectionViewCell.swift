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
    @IBOutlet weak var dataPeriodLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        chartView.noDataTextColor = UIColor(named: GotoMarketColors.ChartLine) ?? UIColor.black
        chartView.noDataText = GoToMarketConstant.loadingChartLabelText
    }

    func setChart(dataPoints: [String], values: [Double], period: HistoryPeriod) {

        let average = values.average
        var dataEntries: [ChartDataEntry] = []

        for counter in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(counter), y: values[counter])
            dataEntries.append(dataEntry)
        }

        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: period.getLineChartLabelText())
        lineChartDataSet.setColor(UIColor(named: GotoMarketColors.ChartLine) ?? UIColor.black)
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.lineWidth = 3.0

        let averageLine = ChartLimitLine(limit: average)
        averageLine.lineWidth = 1.5
        averageLine.lineDashLengths = [5, 5]
        averageLine.lineColor = UIColor(named: GotoMarketColors.ChartAverage) ?? UIColor.red

        var dataSets = [IChartDataSet]()
        dataSets.append(lineChartDataSet)

        let lineChartData = LineChartData(dataSets: dataSets)

        chartView.data = lineChartData
        chartView.leftAxis.addLimitLine(averageLine)

        let xAxis = chartView.xAxis
        xAxis.drawLabelsEnabled = false
        xAxis.drawGridLinesEnabled = false

        let fromDate = dataPoints.first ?? GoToMarketConstant.emptyString
        let toDate = dataPoints.last ?? GoToMarketConstant.emptyString

        let label = GoToMarketConstant.lineCharLimitLineNamePrefix
            + String(format: "%.2f", average)
            + GoToMarketConstant.lineCharLimitLineNamePostfix

        chartView.chartDescription = nil

        dataPeriodLabel.text = GoToMarketConstant.lineChartDescriptionString + fromDate + " ～ " + toDate
        averagePriceLabel.text = label
        averagePriceLabel.textColor = UIColor(named: GotoMarketColors.ChartAverage) ?? UIColor.red
    }
}
