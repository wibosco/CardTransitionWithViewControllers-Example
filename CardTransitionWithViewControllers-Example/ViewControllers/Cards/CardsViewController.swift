//
//  CardsViewController.swift
//  CardTransitionWithViewControllers-Example
//
//  Created by William Boles on 10/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var cardViewControllers: [CardViewController] = {
        var cardViewControllers = [CardViewController]()
        
        for index in 0..<10 {
            let cardViewController = CardViewController.createFromStoryboard()
            let _ = cardViewController.view
            cardViewController.transitioningDelegate = self
            cardViewController.modalPresentationStyle = .custom
            
            
            let viewModel = CardViewModel(title: "title: \(index)", subtitle: "subtitle: \(index)", color: UIColor.randomPastelColor)
            
            cardViewController.configure(withViewModel: viewModel)
            
            addChildContentViewController(cardViewController)
            cardViewControllers.append(cardViewController)
        }
        
        return cardViewControllers
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.itemSize = CGSize(width: view.frame.width, height: 405)
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        
        let viewController = cardViewControllers[indexPath.item]
        
        cell.hostedView = viewController.view
        viewController.animate()
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = cardViewControllers[indexPath.item]
        let hostedViewFrame = calculateHostedViewFrame(atIndexPath: indexPath)
        viewController.startingFrame = hostedViewFrame
        
        removeChildContentViewController(viewController)
        
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Positioning
    
    private func calculateHostedViewFrame(atIndexPath indexPath: IndexPath) -> CGRect {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell,
                let hostedView = cell.hostedView else {
                    fatalError("Dependencies not set up correctly")
        }

        let hostedViewPoint = cell.superview?.convert(cell.frame.origin, to: nil) ?? CGPoint.zero
        let hostedViewFrame = CGRect(x: hostedViewPoint.x + hostedView.frame.origin.x, y: hostedViewPoint.y + hostedView.frame.origin.y, width: hostedView.frame.size.width, height: hostedView.frame.size.height)
        
        return hostedViewFrame
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let cardViewController = presented as? CardViewController,
            let startingFrame = cardViewController.startingFrame else {
            fatalError("Dependencies not set up correctly")
        }
        return CardPresentAnimationController(withStartingFrame: startingFrame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let cardViewController = dismissed as? CardViewController,
            let destinationFrame = cardViewController.startingFrame else {
                fatalError("Dependencies not set up correctly")
        }
        
        let dismissAnimationController = CardDismissAnimationController(withStartingFrame: destinationFrame) { cardViewController in
            guard let index = self.cardViewControllers.firstIndex(of: cardViewController) else {
                fatalError("Unknown card view controller")
            }
            
            self.addChild(cardViewController)
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        return dismissAnimationController
    }
    
    // MARK: - ChildViewControllers
    
    private func addChildContentViewController(_ childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
    
    private func removeChildContentViewController(_ childViewController: UIViewController) {
        guard childViewController.parent != nil else {
            return
        }
        
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
    }
}
