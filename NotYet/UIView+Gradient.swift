//
//  UIView+Gradient.swift
//  NotYet
//
//  Created by Niklas Riekenbrauck on 26.11.16.
//  Copyright © 2016 Niklas Riekenbrauck. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(topRightColor: UIColor, bottomLeftColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [topRightColor.cgColor, bottomLeftColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        
        if let previousGradientLayer = layer.sublayers?.first as? CAGradientLayer {
            previousGradientLayer.removeFromSuperlayer()
        }
        
        layer.insertSublayer(gradient, at: 0)
    }
}
