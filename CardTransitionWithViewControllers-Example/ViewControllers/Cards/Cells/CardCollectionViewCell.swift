//
//  CardCollectionViewCell.swift
//  CardTransitionWithViewControllers-Example
//
//  Created by William Boles on 10/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - HostedView
    
    var hostedView: UIView? {
        didSet {
            guard let hostedView = hostedView else {
                return
            }
            let padding: CGFloat = 30
            hostedView.frame = CGRect(x: padding, y: padding, width: contentView.bounds.size.width - (padding*2), height: contentView.bounds.size.height - padding)
            hostedView.layer.cornerRadius = 10
            hostedView.layer.masksToBounds = true
            contentView.addSubview(hostedView)
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        guard let hostedView = hostedView,
            hostedView.superview == contentView else {
            return
        }
        
        hostedView.removeFromSuperview()
        self.hostedView = nil
    }
}
