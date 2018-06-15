//
//  SwitchCollectionViewCell.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/7.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class SwitchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var typeSwitchLabel: UILabel!

    var typeText: String? {
        didSet {
            self.updateUI()
        }
    }

    private func updateUI() {

        guard let text = typeText else { return }
        
        typeSwitchLabel.text = text
    }

}
