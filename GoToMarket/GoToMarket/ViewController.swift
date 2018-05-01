//
//  ViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/4/30.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CropQuoteManagerDelegate {
    func manager(_ manager: CropQuoteManager, didGet cropQuote: [CropNewQuote]) {
        cropQuote.forEach {
            print("\($0)\n")
        }
    }
    
    func manager(_ manager: CropQuoteManager, didFailWith error: Error) {
        print(error)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var manager = CropQuoteManager()
        manager.delegate = self
        manager.requestCropQuote(onCropName: nil, onCropID: nil, skipDataAmout: nil, maxDataAmount: nil, fromDate: nil, toDate: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

