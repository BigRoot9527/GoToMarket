//
//  ExtnesionUIView.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/22.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

extension UIView {
    
    //MARK: Animation
    func animatePath(
        fromPoint start : CGPoint,
        toPoint end: CGPoint,
        duration time: Double,
        factor: CGFloat)
    {
        // The animation
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        // Animation's path
        let path = UIBezierPath()
        
        // Move the "cursor" to the start
        path.move(to: start)
        
        // Calculate the control points
        let factor : CGFloat = factor
        
        let deltaX : CGFloat = end.x - start.x
        let deltaY : CGFloat = end.y - start.y
        
        let c1 = CGPoint(x: start.x + deltaX * factor, y: start.y)
        let c2 = CGPoint(x: end.x                    , y: end.y - deltaY * factor)
        
        // Draw a curve towards the end, using control points
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        
        // Use this path as the animation's path (casted to CGPath)
        animation.path = path.cgPath;
        
        // The other animations properties
        animation.fillMode              = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration              = time
        animation.timingFunction        = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        // Apply it
        self.layer.zPosition = 0
        self.layer.add(animation, forKey:"trash")
    }
    
    //CornerRadius
    func roundedCorner(cornerRadius radius: CGFloat = 5.0) {
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
