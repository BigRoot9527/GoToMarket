//
//  LoadingViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/20.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var animationContainerView: UIView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    private let manager = CropManager()
    var showingAnimation: LOTAnimationView?
    
    //MARK: Input
    var itemType: TaskKeys?
    var marketPassed: String?
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        showInitAnimationAndLabel()
        
        doingCheckingList()

    }

    
    //MARK: LoadingTasks
    private func doingCheckingList() {
        
        guard let type = itemType else { return }
        
        //check marketPassed > reset
        if let iuputMarket =  marketPassed {
            
            infoLabel.text =
            GoToMarketConstant.nowLoadingText
            + GoToMarketConstant.itemTypeNameForCrops
            + GoToMarketConstant.dataSourceText
            
            doingReset(toMarket: iuputMarket)
            
            //check defaltMarket > update
        } else if LoadingTaskKeeper.shared.getMarket(ofKey: type) != nil {
            
            infoLabel.text =
                GoToMarketConstant.nowUpdatingText
                + GoToMarketConstant.itemTypeNameForCrops
                + GoToMarketConstant.dataSourceText
            
            doingUpdate()
            
            //all nil > firstSet
        } else {
            
            
            askForFirstSet()
        }
        
    }
    
    private func doingReset(toMarket market: String) {
        
        let cropMarket = CropMarkets(rawValue: market)
        
        manager.getCropDataBase(
            fromMarket: cropMarket,
            success: { [weak self] bool in
                
                self?.showDoneAnimationAndLabel(
                    isSuccess: true,
                    labelText: GoToMarketConstant.finishLoadingText,
                    completion: {
                        self?.dismiss(animated: true, completion: nil)
                })
                
        }) { [weak self] error in
            
            self?.showDoneAnimationAndLabel(
                isSuccess: false,
                labelText: GoToMarketConstant.failLoadingText,
                completion: {
                    self?.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    private func doingUpdate() {
        
        manager.getCropDataBase(
            fromMarket: nil,
            success: { [weak self] bool in
                
                self?.showDoneAnimationAndLabel(
                    isSuccess: true,
                    labelText: GoToMarketConstant.finishUpdatingText,
                    completion: {
                        self?.dismiss(animated: true, completion: nil)
                })
                
        }) { [weak self] error in
            
            self?.showDoneAnimationAndLabel(
                isSuccess: false,
                labelText: GoToMarketConstant.failUpdatingText,
                completion: {
                    self?.dismiss(animated: true, completion: nil)
            })
                                    
                                    
        }
    }
    
    
    private func askForFirstSet() {
        
        weak var presentingVC = self.presentingViewController
        
        self.dismiss(animated: true) {
            
            let settingMarketVC = UIStoryboard.marketSetting().instantiateInitialViewController()!
            
            presentingVC?.present(settingMarketVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    //MARK: Animations
    private func showInitAnimationAndLabel() {
        
        let loadingView = setupAnimationView(forName: AnimationConstant.loadingName)
        
        showingAnimation = loadingView
        
        loadingView.loopAnimation = true
        
        loadingView.play()
        
        infoLabel.text =
            GoToMarketConstant.nowInitText
            + GoToMarketConstant.itemTypeNameForCrops
            + GoToMarketConstant.dataSourceText
        
    }
    
    private func showDoneAnimationAndLabel(
        isSuccess: Bool,
        labelText text: String,
        completion: @escaping () -> Void) {
        
        if let presentingView = showingAnimation {

            presentingView.removeFromSuperview()
        }
        
        var animationName: String
        
        if isSuccess {
            animationName = AnimationConstant.successName
        } else {
            animationName = AnimationConstant.warningName
        }
        
        let finishView = setupAnimationView(forName: animationName)
        
        showingAnimation = finishView
        
        infoLabel.text = text
        
        finishView.play { bool in
            
            completion()
        }
    }
    
    
    private func setupAnimationView(forName name: String) -> LOTAnimationView {
        
        let animationView = LOTAnimationView(name: name)
        
        animationView.frame = animationContainerView.bounds
        
        animationView.contentMode = .scaleAspectFill
        
        animationContainerView.addSubview(animationView)
        
        return animationView
        
    }


}
