//
//  Tip.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/18/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import Foundation

class Tip {
    private var due: Double = 0.0
    private var tip : Double = 0.0
    private var total : Double = 0.0
    
    // Initializers
    init(totaldue: Double, tipAmount: Double, grandTotal: Double) {
        self.due = totaldue
        self.tip = tipAmount
        self.total = grandTotal
    }
    
    // Computed Properties
    
    // Public methods
}
