//
//  ViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/4/30.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, CropQuoteManagerDelegate {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    func manager(_ manager: CropQuoteManager, didGet cropQuote: [CropNewQuote]) {
        updateDatabase(with: cropQuote)
    }
    
    func manager(_ manager: CropQuoteManager, didFailWith error: Error) {
        print(error)
    }
    
    func updateDatabase(with newQuote: [CropNewQuote]) {
        container?.performBackgroundTask{ [weak self] context in
            for quoteInfo in newQuote {
                _ = CropNew.findOrCreateQuote(matching: quoteInfo, in: context)
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let quoteCount = (try?context.fetch(CropNew.fetchRequest()))?.count {
                    print("Database count: \(quoteCount)")
                }
            }
        }
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

