//
//  HoverView.swift
//  Tipie
//
//  Created by Neftali Samarey on 3/5/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit

protocol SelectionMadeDelegate: class {
    func selectedInded(index: Int)
}

// If instanitated, the host must then set the constraints or bounds for this view
class HoverView: UIView {
    
    // Delegate
    weak var delegate : SelectionMadeDelegate? = nil
    
    var floatingView = UIView()
    var segmentControlObject = UISegmentedControl()
    
    // Direct initalizerts for the beginning of the main control
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(size: CGRect) {
        self.init(frame: size)
        setupLayout()
        setSegmentControlStyling()
    }
    
    fileprivate func setSegmentControlStyling() {
        
    }
    
    
    // Set the  layers up
    func setupLayout() {
        
        self.floatingView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.TipiePink()
        
        addSubview(floatingView)
        
        floatingView.addSubview(segmentControlObject)
        // Initate the segment controlle on the child view
    }
    


}
