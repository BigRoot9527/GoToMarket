//
//  GoToMarketAnimator.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/4.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol contextViewProvider: class {
    
    func contextView(for animator: GoToMarketAnimator) -> UIView?
}

class GoToMarketAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration:TimeInterval = 0.6

    //MARK: - Input
    //Note: presented - 被present出來的view, presingting - 原本的view
    var isPresentation: Bool = true
    var isAsyncAnimation: Bool = true
    weak var presentedContextViewProvider: contextViewProvider?
    weak var presentingContextViewProvider: contextViewProvider?
    //Optional
    var presentingVisualEffectView: UIVisualEffectView = UIVisualEffectView()


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {

        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

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

        let initialContext = isPresentation ?
            presentingContextViewProvider?.contextView(for: self) :
            presentedContextViewProvider?.contextView(for: self)
        let finalContext = isPresentation ?
            presentedContextViewProvider?.contextView(for: self) :
            presentingContextViewProvider?.contextView(for: self)
        
        guard
            let initialContextView = initialContext,
            let finalContextView = finalContext
            else { return }
        
        guard let initialContextViewSnapShot = initialContextView.snapshotView(afterScreenUpdates: false) else { return }
        
        initialContextViewSnapShot.frame = containerView.convert(initialContextView.frame, from: fromView)
        
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
        initialContextView.alpha = 0.0
        finalContextView.alpha = 0.0
        
        initialContextViewSnapShot.transform = CGAffineTransform.identity
        initialContextViewSnapShot.center = CGPoint(x: initialContextViewSnapShot.frame.midX, y: initialContextViewSnapShot.frame.midY)
        initialContextViewSnapShot.clipsToBounds = true
        containerView.addSubview(initialContextViewSnapShot)
        containerView.bringSubview(toFront: initialContextViewSnapShot)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: { [weak self] in

            initialContextViewSnapShot.transform = contextViewScaleTransform

            initialContextViewSnapShot.center = CGPoint(x: finalContextView.frame.midX, y: finalContextView.frame.midY)

            if let check = self?.isPresentation, check {
                self?.presentingVisualEffectView.effect = UIVisualEffect()
                toView.alpha = 1.0
            } else {
                fromView.alpha = 0.0
            }

        }) { _ in

            initialContextView.alpha = 1.0
            finalContextView.alpha = 1.0
            transitionContext.completeTransition(true)
        }


    }









}
