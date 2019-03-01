//
//  BackgroundView.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/18/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import Foundation
import UIKit

enum SliderType {
    case Tip
    case Split
}

protocol didSlideThroughDelegate: class {
    func updateTipPercentageTo(currentPercentage: Float?)
    func updateNumberOfPeopleSplit(count: Int?)
}


class Slider: UIView {
    
    // MARK: - UI Properties
    var titleLabel = UILabel()
    var percentageLabel = UILabel()
    var subTitleLabel = UILabel()
    var sliderObject = UISlider()
    var numberOfPeopleStepper = FlatStepper()
    
    // Feedback
    let selectedFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // Delegate Property
    weak var delegate : didSlideThroughDelegate?
    
    // MARK: - CONTROL UI PROPERTIES
    // Tip variables
    var percentileValue : Double = 0
    var decimalValue : Float = 0.0
    
    // Split Variables

 
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: -8)
        selectedFeedbackGenerator.prepare()
    
    }
    
    convenience init(size: CGRect) {
        self.init(frame: size)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style(slidertype: SliderType) {
        switch slidertype {
        case .Split:
            setupSplitController()
        case .Tip:
            setupCustomTipController()
        }
    }
    
    // MARK: - Types of setups for the sliders
    
    fileprivate func setupSplitController() {
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfPeopleStepper.translatesAutoresizingMaskIntoConstraints = false
       
        
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(numberOfPeopleStepper)
        addSliderSplitComponents()
    }
    
    fileprivate func addSliderSplitComponents() {
        
        titleLabel.text = "Split Bill"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 24)
        titleLabel.textColor = UIColor.lightGray
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.titleLabel.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    
        subTitleLabel.text = "Number of People"
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont(name: "Lato-Light", size: 21)
        subTitleLabel.textColor = UIColor.cleanBlack()
        
    
        self.subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        self.subTitleLabel.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        self.subTitleLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Stepper Actions
        numberOfPeopleStepper.leftButton.addTarget(self, action: #selector(self.decrementValue), for: .touchUpInside)
        numberOfPeopleStepper.rightButton.addTarget(self, action: #selector(self.incrementValue), for: .touchUpInside)
        
        // Stepper
        numberOfPeopleStepper.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 25).isActive = true
        numberOfPeopleStepper.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        numberOfPeopleStepper.widthAnchor.constraint(equalToConstant: self.bounds.width - 20).isActive = true
        numberOfPeopleStepper.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    fileprivate func setupCustomTipController() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sliderObject.translatesAutoresizingMaskIntoConstraints = false
        

        self.addSubview(titleLabel)
        self.addSubview(percentageLabel)
        self.addSubview(sliderObject)
        addSliderComponents()
    }
    
    // Slider Tip Componenets
    fileprivate func addSliderComponents() {
        
        titleLabel.text = "Custom Tip"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 23)
        titleLabel.textColor = UIColor.lightGray
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.titleLabel.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        percentageLabel.text = "0"
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont(name: "Lato-Light", size: 38)
        percentageLabel.textColor = UIColor.cleanBlack()
        
        self.percentageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        self.percentageLabel.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        self.percentageLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        // Slider
        sliderObject.tintColor = UIColor.emeraldColor()
        sliderObject.minimumValue = 0.0
        sliderObject.maximumValue = 0.5
        
        sliderObject.addTarget(self, action: #selector(self.changedValue(_:)), for: .valueChanged)
        self.sliderObject.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 50).isActive = true
        self.sliderObject.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.sliderObject.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        self.sliderObject.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    
    // MARK: - ACTION METHODS
    
    @objc func changedValue(_ sender: UISlider) {
        
        //percentileValue = Int(sender.value) // Int for label
        
        print(String(format: "%0.2f", sender.value))
        
        let fractionalPart = sender.value.truncatingRemainder(dividingBy: 1.0)
        let modifiedFractionalPart = Int(fractionalPart * 100.0)
        let resString = String(modifiedFractionalPart)
        
        // convert the string to percentage
        print("Res: \(resString)")
        
        // Animator for the current value
        UIView.animate(withDuration: 0.3) {
            self.percentageLabel.text = "\(modifiedFractionalPart)" + "%"
            self.delegate?.updateTipPercentageTo(currentPercentage: sender.value)
        }
        
        
        
    }
    
    // STEPPER
    @objc func decrementValue() {
        selectedFeedbackGenerator.impactOccurred()
        self.delegate?.updateNumberOfPeopleSplit(count: numberOfPeopleStepper.value)
    }
    
    @objc func incrementValue() {
        selectedFeedbackGenerator.impactOccurred()
        self.delegate?.updateNumberOfPeopleSplit(count: numberOfPeopleStepper.value)
    }
  
    
 
}
