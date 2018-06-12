//
//  AppDelegate.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/4/30.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        print("Database URL = \(NSPersistentContainer.defaultDirectoryURL())")

        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = GoToMarketConstant.IQKeyboardDoneButtonText

        switchToTaabBarStoryBoard()
        return true
    }

    func switchToTaabBarStoryBoard() {

        if !Thread.current.isMainThread {

            DispatchQueue.main.async { [weak self] in

                self?.switchToTaabBarStoryBoard()
            }

            return
        }

        window?.rootViewController = UIStoryboard.tabBar().instantiateInitialViewController()
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "GoToMarket")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
