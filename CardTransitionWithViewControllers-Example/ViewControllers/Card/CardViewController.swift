//
//  CardViewController.swift
//  CardTransitionWithViewControllers-Example
//
//  Created by William Boles on 10/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

struct CardViewModel {
    let title: String
    let subtitle: String
    let color: UIColor
}

class CardViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var descriptionLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelTrailingConstraint: NSLayoutConstraint!
    
    private(set) var cardViewModel: CardViewModel!
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.alpha = 0.0
    }
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: CardViewModel) {
        cardView.backgroundColor = viewModel.color
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        cardViewModel = viewModel
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Storyboard
    
    static func createFromStoryboard() -> CardViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: CardViewController.self))
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CardViewController") as? CardViewController else {
            fatalError("CardViewController should be present in storyboard")
        }
        
        return viewController
    }
}
