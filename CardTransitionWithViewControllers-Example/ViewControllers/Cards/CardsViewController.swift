//
//  CardsViewController.swift
//  CardTransitionWithViewControllers-Example
//
//  Created by William Boles on 10/10/2019.
//  Copyright © 2019 William Boles. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var cardViewControllers: [CardViewController] = {
        var cardViewControllers = [CardViewController]()
        
        for index in 0..<10 {
            let cardViewController = CardViewController.createFromStoryboard()
            let _ = cardViewController.view
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
        
        return cell
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cardViewController = segue.destination as? CardViewController,
            let cell = sender as? CardCollectionViewCell,
            let indexPath = collectionView.indexPath(for: cell),
            let cardSegue = segue as? CardSegue,
            let hostedView = cell.hostedView {
                let cellCardViewController = cardViewControllers[indexPath.item]
                let startingPoint = cell.superview!.convert(cell.frame.origin, to: nil)
                let startingFrame = CGRect(x: startingPoint.x + hostedView.frame.origin.x, y: startingPoint.y + hostedView.frame.origin.y, width: hostedView.frame.size.width, height: hostedView.frame.size.height)
                cardSegue.startingFrame = startingFrame
                let _ = cardViewController.view
                cardViewController.configure(withViewModel: cellCardViewController.cardViewModel)
        }
    }
    
    // MARK: - ChildViewControllers
    
    private func addChildContentViewController(_ childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
}
