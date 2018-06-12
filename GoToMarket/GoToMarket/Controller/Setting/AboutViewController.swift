//
//  AboutViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/28.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didTapWindowButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func nChangeOfSegment(_ sender: UIControl) {

    }

}
