//
//  MarketSettingViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/19.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
import UIKit

class MarketSettingViewController: UIViewController, MarketsTableViewControllerDelegate {
    
    @IBOutlet weak var itemTypeImageView: UIImageView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var marketsView: UIView!
    
    var childMarketsTVC: MarketsTableViewController?
    var isFirstTime: Bool = true
    
    //MARK: Input&Output
    var itemTypePassed: TaskKeys?
    var willLoadMarketPassed: String?
    
    //MARK: Output
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
            
            initLoadingVC(ofMarket: willLoadMarket)
            
        } else {
            
            makeComfirm(ofMarket: willLoadMarket)
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func initLoadingVC(ofMarket marketString: String) {
        
        weak var presentingVC = self.presentingViewController
        
        self.dismiss(animated: true) { [weak self] in
            
            let loadingVC = UIStoryboard.loading().instantiateInitialViewController() as! LoadingViewController
            
            loadingVC.itemType = self?.itemTypePassed
            
            loadingVC.marketPassed = self?.willLoadMarketPassed
            
            presentingVC?.present(loadingVC, animated: true, completion: nil)
            
        }
        
    }
    
    private func makeComfirm(ofMarket marketString: String) {
        
        
        //TODO: present comfirm VC
        
        //if yes
        initLoadingVC(ofMarket: marketString)
        
        
    }
    
}
