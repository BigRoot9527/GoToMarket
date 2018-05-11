//
//  RAMBounceAnimation.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/11.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//
import RAMAnimatedTabBarController

class RAMBounceAnimation : RAMItemAnimation {

    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = GoToMarketColor.tabBarTintColor.color()
        icon.tintColor = GoToMarketColor.tabBarTintColor.color()
    }

    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
        icon.tintColor = defaultIconColor
        
    }

    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = GoToMarketColor.tabBarTintColor.color()
        icon.tintColor = GoToMarketColor.tabBarTintColor.color()
    }

    func playBounceAnimation(_ icon : UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic

        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
}
