//
//  SwitchCollectionViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/7.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {

    @IBOutlet weak var switchCollectionView: UICollectionView!
    
    var types: [String] = ["全部","蔬菜","水果"]
    let cellScaling: CGFloat = 0.5
    let cellHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        
        let layout = switchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: cellWidth, height: cellHeight)
        switchCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: cellWidth / 2, bottom: 0.0, right: cellWidth / 2)
        switchCollectionView.dataSource = self
        switchCollectionView.delegate = self
        
    }
}

extension SwitchViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SwitchCollectionViewCell.self), for: indexPath) as! SwitchCollectionViewCell
        
        cell.typeText = types[indexPath.item]
        
        return cell
    }
    
}

extension SwitchViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        guard let layout = self.switchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        print("cellWidthIncludingSpacing = \(cellWidthIncludingSpacing)")

        var offset = targetContentOffset.pointee
        print(offset)

        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        print("roundedIndex = \(roundedIndex)")

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left
            , y: -scrollView.contentInset.top)
        print("scrollView.contentInset.left = \(scrollView.contentInset.left)")
        print(offset)

        targetContentOffset.pointee = offset
        
        
        
        
//        let pageWidth: CGFloat = layout.itemSize.width + layout.minimumLineSpacing
//
//        let currentOffSet: CGFloat = scrollView.contentOffset.x
//
//        let targetOffSet:CGFloat = targetContentOffset.pointee.x
//
//        var newTargetOffset:CGFloat = 0
//
//        if(targetOffSet > currentOffSet){
//            newTargetOffset = (currentOffSet / pageWidth).rounded(.up) * pageWidth
//        }else{
//            newTargetOffset = (currentOffSet / pageWidth).rounded(.down) * pageWidth
//        }
//
//        if(newTargetOffset < 0){
//            newTargetOffset = 0;
//        }else if (newTargetOffset > scrollView.contentSize.width){
//            newTargetOffset = scrollView.contentSize.width
//        }
//
//        targetContentOffset.pointee.x = CGFloat(currentOffSet)
//        scrollView.setContentOffset(CGPoint(x: newTargetOffset, y: 0), animated: true)
        
    }
    
    
}
