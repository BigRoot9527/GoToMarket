//
//  CustomSegmentedContrl.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/6/7.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

@IBDesignable class CustomSegmentedContrl: UIControl {
    
    
    var buttons = [UIButton]()
    var underLiner: UIView!
    var selector: UIView!
    
    var selectedSegmentIndex = 0 {
        didSet {
            updateSegmentedControlSegs(index: selectedSegmentIndex)
        }
    }
    
    var numberOfSegments: Int = 0 {
        didSet {
            numberOfSegments = buttons.count
        }
    }
    
    
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var commaSeperatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    @IBInspectable var textColor: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var selectorColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var selectorTextColor: UIColor? = .green {
        didSet {
            updateView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            updateView()
        }
    }

    
    func updateView() {
        
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let buttonTitles = commaSeperatedButtonTitles.components(separatedBy: ",")
        
        for buttonTitle in buttonTitles {
            
            let button = UIButton.init(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.init(name: "System-Bold", size: 18)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            
            buttons.append(button)
        }
        
        numberOfSegments = buttons.count
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        let y = (self.frame.maxY - self.frame.minY) - 4.0
        selector = UIView.init(frame: CGRect.init(x: 0, y: y, width: selectorWidth, height: 4.0))
        selector.layer.cornerRadius = 2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        // Create a StackView
        let stackView = UIStackView.init(arrangedSubviews: buttons)
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
    }
    
    
    @objc func buttonTapped(button: UIButton) {
        
        var selectorStartPosition: CGFloat!
        
        for (buttonIndex,btn) in buttons.enumerated() {
            
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                
                selectedSegmentIndex = buttonIndex
                
                selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                    btn.backgroundColor = UIColor(named: GotoMarketColors.VegeCellBackground)
                })
                
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
    
    func updateSegmentedControlSegs(index: Int) {
        
        var selectorStartPosition: CGFloat!
        
        selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(index)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.selector.frame.origin.x = selectorStartPosition
        })
    }

}

