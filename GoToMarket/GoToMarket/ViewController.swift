//
//  LoginViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/2.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cropMarketInput = CropMarkets.taichung
        let cropRequestInput = CropQueryType.getInitailQuotes
        
        LoadingTaskKeeper.shared.saveMarket(cropMarketInput, ofKey: .crop)
        LoadingTaskKeeper.shared.saveQueryType(cropRequestInput, ofKey: .crop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let cropMarketOutput = LoadingTaskKeeper.shared.getQueryType(ofKey: .crop) as? CropMarkets, let cropRequestOutput = LoadingTaskKeeper.shared.getQueryType(ofKey: .crop) as? CropQueryType else {return}
        _ = CropManager(cropQuest: .init(cropRequestType: cropRequestOutput, cropMarket: cropMarketOutput))
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
