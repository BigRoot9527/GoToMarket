//
//  SettingTableViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/29.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class SettingTableViewController: UITableViewController {
    
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let navHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        
        let calculatedHeight = (screenHeight - navHeight - tabBarHeight) / 3.2 - 20

        return calculatedHeight > 150 ? calculatedHeight : 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            showingAbout()
        }
        
        if indexPath.row == 1 {
            
            changingMarket()
        }
        
        if indexPath.row == 2 {
            
            sendEmail()
        }
        
        if indexPath.row == 3 {
            
            rateOnTheAppStore()
        }
    }
    
    private func showingAbout() {
        
        performSegue(withIdentifier: String(describing: AboutViewController.self), sender: self)
    }
    
    private func changingMarket() {
        
        let settingVC = UIStoryboard.marketSetting().instantiateInitialViewController() as! MarketSettingViewController
        
        settingVC.itemTypeInput = TaskKeys.crop
        
        settingVC.hero.modalAnimationType = .fade
        
        present(settingVC, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            
        case String(describing: AboutViewController.self):
            
            guard let aboutVC =  segue.destination as? AboutViewController else { return }
            
            aboutVC.hero.isEnabled = true
            
            aboutVC.hero.modalAnimationType = .fade
            
        default:
            
            return
        }
    }
    
    

}

//MARK: - SendingEmail
extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    
    private func sendEmail() {
        
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
    
    private func rateOnTheAppStore() {
        
        SKStoreReviewController.requestReview()
        //TODO: Custom URL request
    }
    
}
