//
//  LoginViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = CropManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cropMarketInput = CropMarkets.taichung
        let cropRequestInput = CropQueryType.updateQuote(lastUpdateDate: nil)
        
        LoadingTaskKeeper.shared.saveMarket(cropMarketInput.rawValue, ofKey: .crop)
        LoadingTaskKeeper.shared.saveQueryType(cropRequestInput.rawValue, ofKey: .crop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard
        let cropMarketOutput = LoadingTaskKeeper.shared.getMarket(ofKey: .crop) ,
        let cropRequestOutput = LoadingTaskKeeper.shared.getQueryType(ofKey: .crop),
        let market = CropMarkets(rawValue: cropMarketOutput),
        let type =  CropQueryType(rawValue: cropRequestOutput)
            else {return}
        
        manager.getCropDataBase(task: type, market: market, success: { bool in
            print(bool)
        }) { _ in
            print("GG")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
