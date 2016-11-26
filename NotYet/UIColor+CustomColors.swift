//
//  UIColor+CustomColors.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

extension UIColor {
    class var customLightGreen: UIColor {
        return UIColor(netHex: 0x99e24b)
    }
    
    class var customGreen: UIColor {
        return UIColor(netHex: 0x47d73a)
    }
    
    class var customBackgroundGray: UIColor {
        return UIColor(netHex: 0xf2f2f2)
    }
    
    class var customLightGray: UIColor {
        return UIColor(netHex: 0xbebebe)
    }
    
    class var customGray: UIColor {
        return UIColor(netHex: 0xb1b1b1)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
