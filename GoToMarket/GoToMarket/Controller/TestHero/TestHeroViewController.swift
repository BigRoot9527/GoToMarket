//
//  TestHeroViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/14.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Hero

class TestHeroViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let titleNameArray = ["BigRoot", "Hello", "Yoyoyo","BigRoot", "Hello", "Yoyoyo","BigRoot", "Hello", "Yoyoyo"]
    
    @IBOutlet weak var sourceTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleNameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
        cell.titleNameLabel.text = titleNameArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc2 = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc2.hero.isEnabled = true
        vc2.hero.modalAnimationType = .uncover(direction: .down)
        
        vc2.passedName = titleNameArray[indexPath.row]
//        vc2.modalPresentationStyle = .
        present(vc2, animated: true, completion: nil)
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "PerformDetail") {
//            
//            let selectedIndexPath:NSIndexPath = self.sourceTableView.indexPathForSelectedRow! as NSIndexPath
//            let detailVC: DetailViewController = segue.destination as! DetailViewController
//            
//            detailVC.passedName = titleNameArray[selectedIndexPath.row]
//            
//            detailVC.hero.modalAnimationType = .uncover(direction: .down)  //nice
//            
////            detailVC.hero.
////            detailVC.hero.modalAnimationType = .push(direction: .left)
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sourceTableView.delegate = self
        sourceTableView.dataSource = self
        registerCell()
    }
    
    private func registerCell() {
        let nibFile = UINib(nibName: "TitleTableViewCell", bundle: nil)
        sourceTableView.register(nibFile, forCellReuseIdentifier: "TitleTableViewCell")
    }

}
