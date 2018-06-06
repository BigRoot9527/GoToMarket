//
//  GoToMarketAnimator.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/4.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

protocol ContextViewProvider: class {
    
    func contextView(for animator: GoToMarketAnimator) -> UIView?
}

class GoToMarketAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration:TimeInterval = 0.4

    //MARK: - Input
    //Note: presented - 被present出來的view, presingting - 原本的view
    var isPresentation: Bool = true
    var isAsyncAnimation: Bool = true
    weak var presentedContextViewProvider: ContextViewProvider?
    weak var presentingContextViewProvider: ContextViewProvider?
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
        print("=======================")
        print(finalContextView.frame)
        
        initialContextView.layer.masksToBounds = true
        
        guard let initialContextViewSnapShot = initialContextView.snapshotView(afterScreenUpdates: true) else { return }
        
        finalContextView.alpha = 1.0
        finalContextView.layer.masksToBounds = true
        
        let finailContextViewSnapShot = isPresentation ? UIView() : finalContextView.snapshotView(afterScreenUpdates: true)!

        let xScalesFactor = isPresentation ?
            finalContextView.frame.width / initialContextView.frame.width :
            initialContextView.frame.width / finalContextView.frame.width
        let yScaleFactor = isPresentation ?
            finalContextView.frame.height / initialContextView.frame.height :
            initialContextView.frame.height / finalContextView.frame.height

        let contextViewScaleTransform = CGAffineTransform(scaleX: xScalesFactor, y: yScaleFactor)
        
        
        let initialContextFrame = containerView.convert(initialContextView.frame, from: initialContextView.superview)
        
        let finalContextViewFrame = containerView.convert(finalContextView.frame, from: finalContextView.superview)

        
        
        
        //Initial State Before Animation
        if isPresentation {
            toView.alpha = 0.0
            containerView.addSubview(toView)
            containerView.bringSubview(toFront: toView)
            presentingVisualEffectView.effect = nil
        }
        
        initialContextView.alpha = 0.0
        finalContextView.layer.masksToBounds = false
        finalContextView.alpha = 0.0
        
        initialContextViewSnapShot.transform = CGAffineTransform.identity
        initialContextViewSnapShot.frame = initialContextFrame
        initialContextViewSnapShot.layer.masksToBounds = true
        
        finailContextViewSnapShot.transform = CGAffineTransform.identity
        finailContextViewSnapShot.frame = initialContextFrame
        finailContextViewSnapShot.layer.masksToBounds = true
        
        finailContextViewSnapShot.alpha = 0.0
        initialContextViewSnapShot.alpha = 1.0
        
        containerView.addSubview(finailContextViewSnapShot)
        containerView.addSubview(initialContextViewSnapShot)
        
        containerView.bringSubview(toFront: initialContextViewSnapShot)
        containerView.bringSubview(toFront: finailContextViewSnapShot)
        
        
        
        UIView.animate(withDuration: duration / 2, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            
            finailContextViewSnapShot.transform = contextViewScaleTransform
            finailContextViewSnapShot.frame = finalContextViewFrame
            finailContextViewSnapShot.alpha = 1.0

            initialContextViewSnapShot.transform = contextViewScaleTransform
            initialContextViewSnapShot.frame = finalContextViewFrame
            initialContextViewSnapShot.alpha = 0.0

            if let check = self?.isPresentation, check {
                
                self?.presentingVisualEffectView.effect = UIVisualEffect()
                toView.alpha = 1.0
                finalContextView.alpha = 1.0
                
            } else {
                
                fromView.alpha = 0.0
            }

        }) { _ in

            initialContextView.alpha = 0.0
            initialContextView.layer.masksToBounds = false
            finalContextView.alpha = 1.0
            
            initialContextViewSnapShot.removeFromSuperview()
            finailContextViewSnapShot.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

    }
}
