//
//  DetailViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/14.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit
import Hero

class TestHeroDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var passedName: String = ""
    
    var cellReference: HeroDetailTableViewCell?
    
    
    
    @IBOutlet weak var deTailTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deTailTableView.delegate = self
        deTailTableView.dataSource = self
        registerCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if deTailTableView.contentOffset.y < -50 {
            
            dismiss(animated: true, completion: nil)

        }

    }
//
//
    func registerCell() {
        let nibFile = UINib(nibName: "HeroDetailTableViewCell", bundle: nil)
        deTailTableView.register(nibFile, forCellReuseIdentifier: "HeroDetailTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroDetailTableViewCell", for: indexPath) as! HeroDetailTableViewCell
        cell.secondNamelabel.text = passedName
        cellReference = cell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    
//    @objc func handlePan(gr: UIPanGestureRecognizer) {
//        gr.delegate = self
//
//    let translation = gr.translation(in: view)
//        switch gr.state {
//        case .began:
//            dismiss(animated: true, completion: nil)
//        case .changed:
//            Hero.shared.update(translation.y / view.bounds.height)
//        default:
//            let velocity = gr.velocity(in: view)
//            if ((translation.y + velocity.y) / view.bounds.height) > 0.5 {
//                Hero.shared.finish()
//            } else {
//                Hero.shared.cancel()
//            }
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
