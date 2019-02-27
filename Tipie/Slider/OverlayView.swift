//
//  OverlayView.swift
//  Tipie
//
//  Created by Neftali Samarey on 1/21/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import Foundation
import UIKit

protocol SliderPercentageInputDelegate: class {
    func updateTipPercentage(currentPercentage: Float?)
}

class Overlay: UIView {
    
    var titleLabel = UILabel()
    var percentageLabel = UILabel()
    var sliderObject = UISlider()
    
    weak var delegate : SliderPercentageInputDelegate?
  
    
    var percentileValue : Double = 0
    var decimalValue : Float = 0.0
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
//         NotificationCenter.default.addObserver(self, selector: #selector(Overlay.userIsSliding(notification:)), name: NSNotification.Name(notificationKey), object: nil)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sliderObject.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: -8)
        
        self.addSubview(titleLabel)
        self.addSubview(percentageLabel)
        self.addSubview(sliderObject)
        addSliderComponents()
    }
    
    convenience init(size: CGRect) {
        self.init(frame: size)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            self.delegate?.updateTipPercentage(currentPercentage: sender.value)
        }
        
    
        
    }
    
    

    
}
