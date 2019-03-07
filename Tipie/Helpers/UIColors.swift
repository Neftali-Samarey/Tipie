//
//  UIColors.swift
//  Tippin'
//
//  Created by Neftali Samarey on 1/19/19.
//  Copyright © 2019 Neftali Samarey. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g:Int , b:Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
    }
    
    class func cleanBlack()->UIColor {
        return UIColor(r: 25, g: 25, b: 25)
    }
    
    class func cleanWhite()->UIColor {
        return UIColor(r: 245, g: 246, b: 250)
    }
    
    class func cleanIndigo()->UIColor {
        return UIColor(r: 75, g: 68, b: 108)
    }
    
    class func emeraldColor()->UIColor {
        return UIColor(r: 46, g: 204, b: 113)
    }
    
    class func flatPink()->UIColor {
        return UIColor(r: 255, g: 45, b: 85)
    }
    
    class func flatPinkBackground()->UIColor {
        return UIColor(r: 255, g: 241, b: 244)
    }
    
    class func TipiePink()->UIColor {
        return UIColor(r: 255, g: 26, b: 65)
    }


}
