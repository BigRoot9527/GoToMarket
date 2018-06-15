//
//  MarketSettingViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/19.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
import UIKit
import FirebaseAnalytics

class MarketSettingViewController: UIViewController {

    @IBOutlet weak var itemTypeImageView: UIImageView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var marketsPickerView: UIPickerView!

    var childMarketsTVC: MarketsTableViewController?
    var isFirstTime: Bool = true
    var pickerMarketArray: [String]?

    // MARK: Input
    var itemTypeInput: TaskKeys?

    // MARK: Input from pickerView & Output
    var willLoadMarketOutput: String?

    // MARK: Output to pickerView
    var defaulMarket: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfIsFirstLoading()
        setupUI()
        getPickerMarketArray()
        marketsPickerView.dataSource = self
        marketsPickerView.delegate = self

    }

    private func checkIfIsFirstLoading() {

        guard let key = itemTypeInput else { return }

        if let marketName = LoadingTaskKeeper.shared.getMarket(ofKey: key) {

            isFirstTime = false

            defaulMarket = marketName
        }
    }

    private func setupUI() {

        enterButton.setTitle(GoToMarketConstant.plzMakeChoiceText, for: .normal)

        enterButton.isEnabled = false
        cancelButton.isEnabled = isFirstTime ? false : true

        guard let typeName = itemTypeInput?.getTaskItemTypeName() else { return }

        noticeLabel.textColor = UIColor.black

        noticeLabel.text =
            GoToMarketConstant.plzMakeChoiceText
            + typeName
            + GoToMarketConstant.informationSourceText
    }

    private func getPickerMarketArray() {

        //Not first time
        if let willBeTopMarket = defaulMarket {

            guard
                var originMarketArray = itemTypeInput?.getMarketsOfItem(),
                let index = originMarketArray.index(of: willBeTopMarket)
                else { return }

            let removedString = originMarketArray.remove(at: index)

            originMarketArray.insert(removedString, at: 0)

            pickerMarketArray = originMarketArray

        } else {
            //First time
            guard var originMarketArray = itemTypeInput?.getMarketsOfItem() else { return }

            originMarketArray.insert(GoToMarketConstant.plzChooseAMarketWarning, at: 0)

            pickerMarketArray = originMarketArray

        }

    }

    @IBAction func didTapEnterButton(_ sender: UIButton) {

        guard let willLoadMarket = willLoadMarketOutput else { return }

        if isFirstTime {

            initLoadingVC(ofMarket: willLoadMarket)

        } else {

            makeComfirm(ofMarket: willLoadMarket)
        }
    }

    @IBAction func didTapCancelButton(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }

    private func initLoadingVC(ofMarket marketString: String) {

        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "Loading Market Choise",
            AnalyticsParameterItemName: marketString,
            AnalyticsParameterContentType: "cont"
            ])

        weak var presentingVC = self.presentingViewController

        self.hero.modalAnimationType = .fade

        self.dismiss(animated: true) { [weak self] in

            guard let loadingVC = UIStoryboard.loading().instantiateInitialViewController() as? LoadingViewController else { return }

            loadingVC.itemTypeInput = self?.itemTypeInput

            loadingVC.marketInput = self?.willLoadMarketOutput

            loadingVC.hero.isEnabled = true

            presentingVC?.present(loadingVC, animated: true, completion: nil)
        }
    }

    private func makeComfirm(ofMarket marketString: String) {

        showAlert(
            alertTitle: "更換市場為\(marketString)",
            alertMessage: "若更換市場，所有『待購清單』及已儲存的『實際購買價』將被刪除並重設回預設值，確定要這麼做嗎？",
            destructiveButtonName: "更換並重設",
            cancelButtonName: "取消",
            destructiveCallBack: { [weak self] in
                self?.initLoadingVC(ofMarket: marketString)
            },
            cancelCallBack: { return })
    }
}

// MARK: - UIPickerViewDataSource
extension MarketSettingViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        guard let customArray = pickerMarketArray else {
            return 1
        }
        return customArray.count
    }
}

// MARK: - UIPickerViewDelegate
extension MarketSettingViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        guard let customArray = pickerMarketArray else {
            return nil
        }

        var market = customArray[row]

        if market == defaulMarket {

            market += GoToMarketConstant.alreadyLoadedMarket
        }

        return market
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        guard let customArray = pickerMarketArray else { return }

        var market = customArray[row]

        //Has Default
        if market == defaulMarket {

            market += GoToMarketConstant.alreadyLoadedMarket

            enterButton.setTitle(GoToMarketConstant.plzMakeChoiceText, for: .normal)

            enterButton.isEnabled = false

        //First time placeholder
        } else if market == GoToMarketConstant.plzChooseAMarketWarning {

            enterButton.setTitle(GoToMarketConstant.plzMakeChoiceText, for: .normal)

            enterButton.isEnabled = false

        } else {

            willLoadMarketOutput = market

            enterButton.setTitle(GoToMarketConstant.allowEnterButtonTitle, for: .normal)

            enterButton.isEnabled = true

        }

        noticeLabel.text = market

    }
}
