//
//  ExtensionUIViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/24.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Animation
    
    func showingCartAnimation(
        isInChart:Bool,
        fromCellFrame cellFrame: CGRect?,
        cellTableView table: UITableView?,
        completion: @escaping () -> Void ) {
        
        let screenSize = UIScreen.main.bounds
        let rootViewPoint = CGPoint(x: screenSize.width / 2, y: screenSize.height)
        let animationView = UIImageView(image: #imageLiteral(resourceName: "cauliflower_icon"))
        
        var animationFrame: CGRect
        var endPoint: CGPoint
        var factor: CGFloat
        
        if !isInChart {
            
            animationFrame = CGRect(x: rootViewPoint.x - 40 , y: rootViewPoint.y, width: 50, height: 50)
            
            endPoint = CGPoint(x: -20, y: rootViewPoint.y - 100 )
            
            factor = -1
            
        } else {
            
            guard
                let cellFrame = cellFrame,
                let inputTable = table
                else { return }
            
            let convertedRect = self.view.convert(cellFrame, from: inputTable)
            
            animationFrame = CGRect(x: 10, y: convertedRect.origin.y + 5, width: 50, height: 50)
            
            endPoint = CGPoint(x: rootViewPoint.x, y: rootViewPoint.y)
            
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
            toPoint:   endPoint,
            duration:  0.9,
            factor:    factor)
        
        CATransaction.commit()
    }
    
    //MARK: - Notification
    func postCartNotification(count: Int) {
        
        NotificationCenter.default.post(
            name: GoToMarketConstant.cartNotificationName,
            object: self,
            userInfo: ["CartCount": count])
        
    }
    
    //MARK: - Alert
    func showAlert(
        alertTitle: String,
        alertMessage: String,
        destructiveButtonName: String,
        cancelButtonName: String,
        destructiveCallBack: @escaping (() -> Void),
        cancelCallBack: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: destructiveButtonName, style: .destructive, handler: { action in
            
            destructiveCallBack()
            }))
        
        alert.addAction(UIAlertAction(title: cancelButtonName, style: .cancel, handler: { action in
            
            cancelCallBack()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNotice(
        noticeTitle: String,
        noticeMessage: String,
        confirmButtonName: String,
        confirmCallBack: @escaping (() -> Void)) {
        
        let notice = UIAlertController(title: noticeTitle, message: noticeMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        notice.addAction(UIAlertAction(title: confirmButtonName, style: .default, handler: { action in
            
            confirmCallBack()
        }))
        
        self.present(notice, animated: true, completion: nil)
    }
    
}
