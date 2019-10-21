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

class CardViewController: UIViewController, UICollectionViewDataSource {
    var startingFrame: CGRect?

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var middleCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
        
    @IBOutlet weak var descriptionLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelTrailingConstraint: NSLayoutConstraint!
    
    private(set) var cardViewModel: CardViewModel!
    private var animating: Bool = false
    private var collectionViewContentOffsetSet: Bool = false
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.alpha = 0.0
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 70, height: 70)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        topCollectionView.setCollectionViewLayout(layout, animated: false)
        middleCollectionView.setCollectionViewLayout(layout, animated: false)
        bottomCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !collectionViewContentOffsetSet else {
            return
        }
        collectionViewContentOffsetSet = true
        
        let xOffset: CGFloat = 35
    
        //Setting the content offset in viewDidLoad can sometimes lead to it being reset/ignored before the view is on screeen
        topCollectionView.contentOffset = CGPoint(x: xOffset, y: topCollectionView.contentOffset.y)
        bottomCollectionView.contentOffset = CGPoint(x: xOffset, y: bottomCollectionView.contentOffset.y)
    }
    
    // MARK: - Configure
    
    func configure(withViewModel viewModel: CardViewModel) {
        cardView.backgroundColor = viewModel.color
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        cardViewModel = viewModel
    }
    
    // MARK: - Animation
    
    func animate() {
        guard !animating else {
            return
        }
        
        animating = true
        animateScroll()
    }
    
    private func animateScroll() {
        let topCollectionViewNextContentOffset = CGPoint(x: topCollectionView.contentOffset.x + 1, y: topCollectionView.contentOffset.y)
        let middleCollectionViewNextContentOffset = CGPoint(x: middleCollectionView.contentOffset.x + 1, y: middleCollectionView.contentOffset.y)
        let bottomCollectionViewNextContentOffset = CGPoint(x: bottomCollectionView.contentOffset.x + 1, y: bottomCollectionView.contentOffset.y)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { [weak self] in
            self?.topCollectionView.contentOffset = topCollectionViewNextContentOffset
            self?.middleCollectionView.contentOffset = middleCollectionViewNextContentOffset
            self?.bottomCollectionView.contentOffset = bottomCollectionViewNextContentOffset
        }) { [weak self] (_) in
            self?.animateScroll()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 500
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TileCollectionViewCell", for: indexPath) as? TileCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        
        cell.backgroundColor = UIColor.randomPastelColor

        return cell
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
