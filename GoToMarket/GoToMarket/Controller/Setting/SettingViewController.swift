//
//  SettingViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/20.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    //MARK: - IBAction
    @IBAction func didTapChangeCropButton(_ sender: UIButton) {
        
        let settingVC = UIStoryboard.marketSetting().instantiateInitialViewController() as! MarketSettingViewController
        
        settingVC.itemTypeInput = TaskKeys.crop
        
        settingVC.hero.modalAnimationType = .fade
        
        present(settingVC, animated: true, completion: nil)
    }
    
    @IBAction func didTapAboutButoon(_ sender: UIButton) {
        
        performSegue(withIdentifier: String(describing: AboutViewController.self), sender: self)
    }
    
    @IBAction func didTapEmailButton(_ sender: UIButton) {
        
        sendEmail()
    }

}


//MARK: - SendingEmail
extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["b97611043@g.ntu.edu.tw"])
            mail.setSubject(NSLocalizedString("Issue Report", comment: ""))
            
            self.present(mail, animated: true)
            
        } else {
            
            let alertController = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("Your iPhone could not send mail.", comment: ""), preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
        
    }
    
    func rateOnTheAppStore() {
        
        SKStoreReviewController.requestReview()
    }
    
}
