//
//  CalculateViewController.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/27.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var currentMultiplerLabel: UILabel!
    @IBOutlet weak var resetMultiplerButton: UIButton!
    @IBOutlet weak var actualCostTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    //TODO: make info labels to fade chainly
    
    //Input
    var itemCode: String = ""
    
    private let manager = NoteManager()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadMultiplerData()
    }
    
    private func setupUI() {
        
        visualEffectView.roundedCorner(cornerRadius: 10.0)
        enterButton.roundedCorner()
        cancelButton.roundedCorner()
    }
    
    private func loadMultiplerData() {
        
        
        
        
    }
    
    
    
    
    //MARK: - IBActions
    @IBAction func didTapEnterButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didChangeWeightTypeSegment(_ sender: UISegmentedControl) {
    }
    
    
}
