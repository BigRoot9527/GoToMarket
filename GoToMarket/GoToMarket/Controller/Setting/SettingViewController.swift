//
//  SettingViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/20.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapChangeCropButton(_ sender: UIButton) {
        
        
        let settingVC = UIStoryboard.marketSetting().instantiateInitialViewController() as! MarketSettingViewController
        
        settingVC.itemTypeInput = TaskKeys.crop
        
        settingVC.hero.modalAnimationType = .fade
        
        present(settingVC, animated: true, completion: nil)
        
    }
    

}
