//
//  CardPresentAnimationController.swift
//  CardTransitionWithViewControllers-Example
//
//  Created by William Boles on 10/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class CardPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let startingFrame: CGRect
    
    // MARK: - Init
    
    init(withStartingFrame startingFrame: CGRect) {
        self.startingFrame = startingFrame
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) as? CardViewController else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        toViewController.view.frame = startingFrame
        toViewController.view.layer.masksToBounds = true
        toViewController.view.layer.cornerRadius = 10
        
        containerView.addSubview(toViewController.view)
        
        let duration = transitionDuration(using: transitionContext)
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            toViewController.descriptionLabelLeadingConstraint.constant = 30
            toViewController.descriptionLabelTrailingConstraint.constant = 30
            toViewController.view.frame = finalFrame
            toViewController.closeButton.alpha = 1.0
            toViewController.view.layer.cornerRadius = 0

            toViewController.view.setNeedsLayout()
            toViewController.view.layoutIfNeeded()
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
