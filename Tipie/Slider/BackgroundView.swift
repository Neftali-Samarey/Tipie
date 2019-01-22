//
//  BackgroundView.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/18/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import Foundation
import UIKit

class BackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    convenience init(size: CGRect) {
        self.init(frame: size)
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
 
}
