//
//  CustomSegmentedContrl.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/7.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

class CustomSegmentedContrl: UIControl {
    
    private var inputButtons: [CustomSegCrlButton]
    private var selectorColor: UIColor?
    private var selector = UIView()
    
    var selectedSegmentIndex = 0 {
        didSet {
            updateSegmentedControlSegs(index: selectedSegmentIndex)
            sendActions(for: .valueChanged)
        }
    }
    
    var numberOfSegments: Int {
        return inputButtons.count
    }

    init(frame: CGRect, selectorColor color: UIColor, customSegButtons inputButtons: [CustomSegCrlButton]) {
        
        self.selectorColor = color
        self.inputButtons = inputButtons
        
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var frame: CGRect {
        didSet {
            setupFrames()
        }
    }

    
    private func setupViews() {
        
        for element in inputButtons {
            
            element.buttonItem.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
        }
    
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        // Create a StackView
        let stackView = UIStackView.init(arrangedSubviews: inputButtons.map({ element -> UIButton in
            return element.buttonItem
        }))
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        bringSubview(toFront: selector)
        
        selectedSegmentIndex = 0
        inputButtons.first?.didSelected()
    }
    
    
    private func setupFrames() {
        
        let selectorWidth = frame.width / CGFloat(inputButtons.count)
        let y = (self.frame.maxY - self.frame.minY) - 4.0
        selector = UIView.init(frame: CGRect.init(x: 0, y: y, width: selectorWidth, height: 4.0))
        selector.layer.cornerRadius = 2
    }
    
    
    @objc func buttonTapped(button: UIButton) {
        
        for (index,element) in inputButtons.enumerated() {
            
            if button === element.buttonItem {
                
                UIView.animate(withDuration: 0.3) { [weak self] in
                    
                    self?.inputButtons[index].didSelected()
                    self?.selectedSegmentIndex = index
                }
                
                
            } else {
                
                UIView.animate(withDuration: 0.3) { [weak self] in
                    
                    self?.inputButtons[index].unSelected()
                }
            }
        }
    }
    
    
    func updateSegmentedControlSegs(index: Int) {
        
        var selectorStartPosition: CGFloat
        
        selectorStartPosition = frame.width / CGFloat(inputButtons.count) * CGFloat(index)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.selector.frame.origin.x = selectorStartPosition
        })
    }
}

