//
//  GradientView.swift
//  SmackAlpha
//
//  Created by Ghita on 10/6/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import UIKit

@IBDesignable // able to work in storyboard
class GradientView: UIView {

    // var will be able to change inside sb dynamically
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 1, green: 0.4846054316, blue: 0.8637048602, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var buttomColor: UIColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor , buttomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
