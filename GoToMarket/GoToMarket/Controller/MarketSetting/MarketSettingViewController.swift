//
//  MarketSettingViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/19.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
import TransitionButton
import UIKit

class MarketSettingViewController: UIViewController, MarketsTableViewControllerDelegate {
    
    @IBOutlet weak var itemTypeImageView: UIImageView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var enterButton: TransitionButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var marketsView: UIView!
    
    var childMarketsTVC: MarketsTableViewController?
    var itemTypePassed: TaskKeys?
    var willLoadMarketPassed: String?
    var isFirstTime: Bool = true
    var passingLoadedMarket: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfIsFirstLoading()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        
        passDataToChild()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
            
        case let marketsTVC as MarketsTableViewController:
            
            childMarketsTVC = marketsTVC
     
        default:
            
            break
        }
    }
    
    private func passDataToChild() {
        
        childMarketsTVC?.itemTypePassed = self.itemTypePassed
        
        childMarketsTVC?.loadedMarketPassed = self.passingLoadedMarket
    }
    
    private func checkIfIsFirstLoading() {
        
        guard let key = itemTypePassed else { return }
        
        if let marketName = LoadingTaskKeeper.shared.getMarket(ofKey: key) {
            
            isFirstTime = false
            
            passingLoadedMarket = marketName
        }
    }
    
    private func setupUI() {
        
        enterButton.setTitle(GoToMarketConstant.plzMakeChoiceText, for: .normal)
        
        enterButton.isEnabled = false
        
        if isFirstTime {
            
            cancelButton.isEnabled = false
            
        } else {
            
            cancelButton.isEnabled = true
        }
        
        guard let typeName = itemTypePassed?.getTaskItemTypeName() else { return }
        
        noticeLabel.textColor = UIColor.black
        
        noticeLabel.text =
            GoToMarketConstant.plzMakeChoiceText
            + typeName
            + GoToMarketConstant.informationSourceText
    }
    
    func didSelectMarket(sender: UITableView, marketText: String?) {
        
        willLoadMarketPassed = marketText
        
        enterButton.setTitle(GoToMarketConstant.allowEnterButtonTitle, for: .normal)
        
        enterButton.isEnabled = true
    }
    
    @IBAction func didTapEnterButton(_ sender: UIButton) {
        
        guard let willLoadMarket = willLoadMarketPassed else { return }
        
        if isFirstTime {
            
            startLoadData(ofMarket: willLoadMarket)
            
        } else {
            
            makeComfirm()
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func startLoadData(ofMarket marketString: String) {
        
        noticeLabel.textColor = UIColor.black
        
        noticeLabel.text = GoToMarketConstant.loadingText
        
        cancelButton.isEnabled = false
        
        cancelButton.isEnabled = false
        
        enterButton.startAnimation()
        
        //TODO: Make other itemType manager & marketEnum swichable
        let manager = CropManager()
        
        let market = CropMarkets(rawValue: marketString)
        
        manager.getCropDataBase(fromMarket: market, success: { [weak self] isSucceeded in
            
            self?.enterButton.stopAnimation(animationStyle: .expand, completion: {
                
                self?.dismiss(animated: true, completion: nil)
            })
        }) { [weak self] error in
            
            self?.noticeLabel.text = error.localizedDescription
            
            self?.enterButton.stopAnimation(
                animationStyle: .shake,
                revertAfterDelay: 1000,
                completion: {
                
                    self?.setupUI()
            })

        }
        
    }
    
}
