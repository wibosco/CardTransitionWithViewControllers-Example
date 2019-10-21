//
//  CardDismissAnimationController.swift
//  CardTransitionWithViewControllers-Example
//
//  Created by Boles, William (Developer) on 17/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit


class CardDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let startingFrame: CGRect
    private let completion: (CardViewController) -> ()
    
    // MARK: - Init
    
    init(withStartingFrame startingFrame: CGRect, completion: @escaping (CardViewController) -> ()) {
        self.startingFrame = startingFrame
        self.completion = completion
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? CardViewController else {
            return
        }
        
        fromViewController.view.layer.masksToBounds = true
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromViewController.view)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            fromViewController.descriptionLabelLeadingConstraint.constant = 0
            fromViewController.descriptionLabelTrailingConstraint.constant = 0
            fromViewController.view.frame = self.startingFrame
            fromViewController.closeButton.alpha = 0.0
            fromViewController.view.layer.cornerRadius = 20
            
            fromViewController.view.setNeedsLayout()
            fromViewController.view.layoutIfNeeded()
        }) { (_) in
            transitionContext.completeTransition(true)
            self.completion(fromViewController)
        }
    }
}
