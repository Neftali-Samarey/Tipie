//
//  FlatStepper.swift
//  Tipie
//
//  Created by Neftali Samarey on 2/25/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit

protocol FlatStepperDelegate : class {
    func buttonWasToggled(condition: Bool)
}

class FlatStepper: UIView {
    
    public let leftButton = UIButton()
    public let rightButton = UIButton()
    private let middleLabel = UILabel()
    
    weak var delegate : FlatStepperDelegate? = nil
    
    // Defaults to 0
    public var value = 1 {
        didSet {
            middleLabel.text = String(value)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        
        DispatchQueue.main.async {
            let labelWidthWeight: CGFloat = 0.5
            let buttonWidth = self.bounds.size.width * ((1 - labelWidthWeight) / 2)
            let labelWidth = self.bounds.size.width * labelWidthWeight
            
            self.leftButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: self.bounds.size.height)
            self.middleLabel.frame = CGRect(x: buttonWidth, y: 0, width: labelWidth, height: self.bounds.size.height)
            self.rightButton.frame = CGRect(x: labelWidth + buttonWidth, y: 0, width: buttonWidth, height: self.bounds.size.height)
        }
        
    }
    
    fileprivate func setup() {
        
        DispatchQueue.main.async {
            self.delegate?.buttonWasToggled(condition: false)
        }
        // Left button
        leftButton.setTitle("-", for: .normal)
        leftButton.backgroundColor = UIColor.flatPink()
        leftButton.addTarget(self, action: #selector(FlatStepper.leftButtonTouchDown(button:)), for: .touchUpInside)
        
        self.leftButton.layer.opacity = 0.5
        self.leftButton.isEnabled = false
     
        addSubview(leftButton)
        
        // Right button
        
        rightButton.setTitle("+", for: .normal)
        rightButton.backgroundColor = UIColor.flatPink()
        rightButton.addTarget(self, action: #selector(FlatStepper.rightButtonTouchDown(button:)), for: .touchUpInside)
        addSubview(rightButton)
        
        // Middle label
        middleLabel.text = String(value)
        middleLabel.font = UIFont(name: "Lato-Light", size: 25)
        middleLabel.textAlignment = .center
        middleLabel.backgroundColor = UIColor.flatPinkBackground()
        addSubview(middleLabel)
    
    }
    
    // Increments
    @objc private func leftButtonTouchDown(button: UIButton) {
        guard value > 1 else {
            return
        }
        if (value <= 2) {
            self.leftButton.layer.opacity = 0.5
            self.leftButton.isEnabled = false
            self.delegate?.buttonWasToggled(condition: false)
        }
        value -= 1 // Value is at 1 when stepper is disabled at 1
    }
    
    @objc private func rightButtonTouchDown(button: UIButton) {
        self.delegate?.buttonWasToggled(condition: true)
        self.leftButton.isEnabled = true
        self.leftButton.layer.opacity = 1
        self.leftButton.backgroundColor = UIColor.flatPink() // TODO: COME UP WITH A MORE EFFICIENT METHOD OF REVERTING
        value += 1
    }
    
    // MARK: - UI OVERRIDE METHODS
    public func setLeftButtonColorWith(color: UIColor) {
        self.leftButton.backgroundColor = color
    }
    
    public func setRightButtonColorWith(color: UIColor) {
        self.rightButton.backgroundColor = color
    }
    

    
    
   
    
   
    

}
