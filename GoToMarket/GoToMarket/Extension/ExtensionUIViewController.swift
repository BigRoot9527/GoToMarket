//
//  ExtensionUIViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/24.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - Animation
    func showingCartAnimation(
        isInChart: Bool,
        fromCellFrame cellFrame: CGRect?,
        cellTableView table: UITableView?,
        completion: @escaping () -> Void ) {

        guard let tabController = tabBarController else { return }

        let centerTabView = tabController.orderedTabBarItemViews()[1]

        let rootViewTabPoint = self.view.convert(
            CGPoint(x: centerTabView.frame.width / 2, y: centerTabView.frame.height / 2 ),
            from: centerTabView )

        let animationView = UIImageView(image: #imageLiteral(resourceName: "cauliflower_icon"))

        var animationFrame: CGRect
        var endPoint: CGPoint
        var factor: CGFloat

        if !isInChart {

            animationFrame = CGRect(x: rootViewTabPoint.x - 40, y: rootViewTabPoint.y + 100, width: 50, height: 50)

            endPoint = CGPoint(x: -20, y: rootViewTabPoint.y - 100 )

            factor = -1

        } else {

            guard
                let cellFrame = cellFrame,
                let inputTable = table
                else { return }

            let convertedRect = self.view.convert(cellFrame, from: inputTable)

            animationFrame = CGRect(x: 10, y: convertedRect.origin.y + 5, width: 50, height: 50)

            endPoint = rootViewTabPoint

            factor = 0.5
        }

        self.view.addSubview(animationView)

        animationView.frame = animationFrame

        let fromPoint = animationView.center

        UIView.animate(withDuration: 0.5, animations: {

            animationView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        })

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            animationView.removeFromSuperview()

            completion()

        }
        animationView.animatePath(
            fromPoint: fromPoint,
            toPoint: endPoint,
            duration: 0.9,
            factor: factor)

        CATransaction.commit()
    }

    // MARK: - Notification
    func postCartNotification(count: Int, playBounceAnimation: Bool) {

        NotificationCenter.default.post(
            name: GoToMarketConstant.cartNotificationName,
            object: self,
            userInfo: ["CartCount": count, "playAnimation": playBounceAnimation])

    }

    // MARK: - Alert
    func showAlert(
        alertTitle: String,
        alertMessage: String,
        destructiveButtonName: String,
        cancelButtonName: String,
        destructiveCallBack: @escaping (() -> Void),
        cancelCallBack: @escaping (() -> Void)) {

        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: destructiveButtonName, style: .destructive, handler: { _ in

            destructiveCallBack()
            }))

        alert.addAction(UIAlertAction(title: cancelButtonName, style: .cancel, handler: { _ in

            cancelCallBack()

        }))

        self.present(alert, animated: true, completion: nil)
    }

    func showNotice(
        noticeTitle: String,
        noticeMessage: String,
        confirmButtonName: String,
        confirmCallBack: @escaping (() -> Void)) {

        let notice = UIAlertController(
            title: noticeTitle,
            message: noticeMessage,
            preferredStyle: UIAlertControllerStyle.alert)

        notice.addAction(UIAlertAction(title: confirmButtonName, style: .default, handler: { _ in

            confirmCallBack()
        }))

        self.present(notice, animated: true, completion: nil)
    }

}
