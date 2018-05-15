////
////  ExtensionOfNSFetchResultsController.swift
////  GoToMarket
////
////  Created by 許庭瑋 on 2018/5/3.
////  Copyright © 2018年 許庭瑋. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//extension CoreDataDemoTableViewController
//{
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController?.sections?.count ?? 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let sections = fetchedResultsController?.sections, sections.count > 0 {
//            return sections[section].numberOfObjects
//        } else {
//            return 0
//        }
//    }
//
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return fetchedResultsController?.sectionIndexTitles
//    }
//    
//    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
//    }
//}
