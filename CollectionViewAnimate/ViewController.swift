//
//  ViewController.swift
//  CollectionViewAnimate
//
//  Created by Ryan Temple on 3/16/18.
//  Copyright © 2018 Ryan Temple. All rights reserved.
//

import UIKit
import SnapKit
import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    let colors: [UIColor]
    var collectionView: UICollectionView!
    var layout = Layout()
    
    // MARK: Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        var colors: [UIColor] = []
        
        for _ in 1...20 {
            colors.append(UIColor.randomColor())
        }
        
        self.colors = colors
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = {
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.white
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.kind)
            
            return collectionView
        }()
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: Status Bar
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ContentCell.kind,
            for: indexPath
            ) as! ContentCell
        
        cell.backgroundColor = colors[indexPath.item]
        cell.label.text = "Cell \(indexPath.item)"
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        layout.selectedCellIndexPath = layout.selectedCellIndexPath == indexPath ? nil : indexPath
        
        let bounceEnabled = false
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: bounceEnabled ? 0.5 : 1.0,
            initialSpringVelocity: bounceEnabled ? 2.0 : 0.0,
            options: UIViewAnimationOptions(),
            animations: {
                self.layout.invalidateLayout()
                self.collectionView.layoutIfNeeded()
        },
            completion: nil
        )
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(Number.random(from: 0, to: 255)) / 255.0
        let green = CGFloat(Number.random(from: 0, to: 255)) / 255.0
        let blue = CGFloat(Number.random(from: 0, to: 255)) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct Number {
    static func random(from: Int, to: Int) -> Int {
        guard from < to else { fatalError("`from` MUST be less than `to`") }
        let delta = UInt32(to + 1 - from)
        
        return from + Int(arc4random_uniform(delta))
    }
}
