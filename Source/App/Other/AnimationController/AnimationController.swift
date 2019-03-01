//
//  AnimationController.swift
//  Habbbit
//
//  Created by Onyekachi Ezeoke on 28/02/2019.
//  Copyright © 2019 Team Sweet Cheeks. All rights reserved.
//

import UIKit

public class AnimationController: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType
    
    
    public enum AnimationType {
        case present
    }
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
    
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to)
            else { transitionContext.completeTransition(false)
                return }
        
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        }
    }
    
    private func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0, usingSpringWithDamping: 0.80,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut, animations: {
                        viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
}

