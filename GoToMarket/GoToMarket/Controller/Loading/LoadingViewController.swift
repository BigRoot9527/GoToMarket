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

    // MARK: Input
    var itemTypeInput: TaskKeys?
    var marketInput: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        showInitAnimationAndLabel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        doingCheckingList()
    }

    // MARK: LoadingTasks
    private func doingCheckingList() {

        guard let type = itemTypeInput else { return }

        //check marketPassed > reset
        if let iuputMarket =  marketInput {

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

            askForMarket()
        }
    }

    private func doingReset(toMarket market: String) {

        let cropMarket = CropMarkets(rawValue: market)

        manager.saveCropDataBase(
            fromMarket: cropMarket,
            success: { [weak self] _ in

                self?.showDoneAnimationAndLabel(
                    isSuccess: true,
                    labelText: GoToMarketConstant.finishLoadingText,
                    completion: {

                        self?.dismiss(animated: true, completion: nil)

                        self?.postCartNotification(count: 0, playBounceAnimation: false)
                })

        }, failure: { [weak self] _ in

            self?.showDoneAnimationAndLabel(
                isSuccess: false,
                labelText: GoToMarketConstant.failLoadingText,
                completion: {
                    self?.showNotice(
                        noticeTitle: "噢不～ 出了點問題！",
                        noticeMessage: "抱歉，下載資料失敗 Q_Q \n請檢查網路狀態或稍後再試。",
                        confirmButtonName: "確定",
                        confirmCallBack: {
                            self?.dismiss(animated: true, completion: nil)
                    })
            })
        })
    }

    private func doingUpdate() {

        manager.saveCropDataBase(
            fromMarket: nil,
            success: { [weak self] _ in

                self?.showDoneAnimationAndLabel(
                    isSuccess: true,
                    labelText: GoToMarketConstant.finishUpdatingText,
                    completion: {
                        self?.dismiss(animated: true, completion: nil)
                })

        }, failure: { [weak self] _ in

            self?.showDoneAnimationAndLabel(
                isSuccess: false,
                labelText: GoToMarketConstant.failUpdatingText,
                completion: {

                    self?.showNotice(
                        noticeTitle: "噢不～ 出了點問題！",
                        noticeMessage: "抱歉，資料更新失敗 Q_Q \n請檢查網路狀態或稍後再試。",
                        confirmButtonName: "確定",
                        confirmCallBack: {
                            self?.dismiss(animated: true, completion: nil)
                    })
            })
        })
    }

    private func askForMarket() {

        weak var presentingVC = self.presentingViewController

        self.hero.modalAnimationType = .fade

        self.dismiss(animated: true) { [weak self] in

            guard
                let settingMarketVC = UIStoryboard.marketSetting().instantiateInitialViewController() as? MarketSettingViewController
                else { return }

            settingMarketVC.itemTypeInput = self?.itemTypeInput

            presentingVC?.present(settingMarketVC, animated: true, completion: nil)

        }

    }

    // MARK: Animations
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

        finishView.play { _ in

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
