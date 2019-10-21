//
//  TileCollectionViewCell.swift
//  CardTransitionWithViewControllers-Example
//
//  Created by Boles, William (Developer) on 18/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    
    // MARK: - ViewLifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
