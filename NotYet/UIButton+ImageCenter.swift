//
//  UIButton+ImageCenter.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 27.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

extension UIButton {
    func centerVertically(withPadding padding: CGFloat, imageTop: Bool) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight: CGFloat = (imageSize.height + titleSize.height + padding)
        
        if imageTop {
            self.imageEdgeInsets = UIEdgeInsetsMake((totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width)
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, +(totalHeight - titleSize.height), 0.0)
        } else {
            self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width)
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height), 0.0)
        }
        
    }
    
    func centerVertically(imageTop: Bool) {
        let kDefaultPadding: CGFloat = 6.0
        self.centerVertically(withPadding: kDefaultPadding, imageTop: imageTop)
    }
}
