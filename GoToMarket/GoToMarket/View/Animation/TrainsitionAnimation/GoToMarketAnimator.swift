//
//  GoToMarketAnimator.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/4.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class GoToMarketAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration:TimeInterval = 0.6

    //MARK: - Input
    //Note: presented - 被present出來的view, presingting - 原本的view
    var isPresentation: Bool = true
    var isAsyncAnimation: Bool = true
    var presentedContextView: UIView = UIView()
    var presentingContextView: UIView = UIView()
    //Optional
    var presentingVisualEffectView: UIVisualEffectView = UIVisualEffectView()


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // Fade animation
        //        let containerView = transitionContext.containerView
        //
        //        let toView = transitionContext.view(forKey: .to)!
        //
        //        containerView.addSubview(toView)
        //
        //        toView.alpha = 0.0
        //
        //        UIView.animate(withDuration: duration, animations: {
        //
        //            toView.alpha = 1.0
        //
        //        }) { _ in
        //
        //            transitionContext.completeTransition(true)
        //        }


        let containerView = transitionContext.containerView

        guard
            let toView = transitionContext.viewController(forKey: .to)?.view,
            let fromView = transitionContext.viewController(forKey: .from)?.view
            else { return }

        let presentingView = isPresentation ?
            fromView :
            toView
        let presentedView = isPresentation ?
            toView :
            fromView

        let initialContextView = isPresentation ?
            presentingContextView :
            presentedContextView
        let finalContextView = isPresentation ?
            presentedContextView :
            presentingContextView

        let xScalesFactor = isPresentation ?
            initialContextView.frame.width / finalContextView.frame.width :
            finalContextView.frame.width / initialContextView.frame.width
        let yScaleFactor = isPresentation ?
            initialContextView.frame.height / finalContextView.frame.height :
            finalContextView.frame.height / initialContextView.frame.height

        let contextViewScaleTransform = CGAffineTransform(scaleX: xScalesFactor, y: yScaleFactor)


        //Initial State Before Animation
        if isPresentation {
            toView.alpha = 0.0
            containerView.addSubview(toView)
            containerView.bringSubview(toFront: toView)
            presentingVisualEffectView.effect = nil
        }
        initialContextView.transform = CGAffineTransform.identity
        initialContextView.center = CGPoint(x: initialContextView.frame.midX, y: initialContextView.frame.midY)
        initialContextView.clipsToBounds = true
        containerView.addSubview(initialContextView)
        containerView.bringSubview(toFront: initialContextView)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: { [weak self] in

            initialContextView.transform = contextViewScaleTransform

            initialContextView.center = CGPoint(x: finalContextView.frame.midX, y: finalContextView.frame.midY)

            if let check = self?.isPresentation, check {
                self?.presentingVisualEffectView.effect = UIVisualEffect()
                toView.alpha = 1.0
            } else {
                fromView.alpha = 0.0
            }

        }) { _ in

            transitionContext.completeTransition(true)
        }


    }









}
