//
//  GradientColor.swift
//  CWKSemua
//
//  Created by Pieter Yonathan on 07/06/21.
//

import Foundation
import UIKit

extension UIView{
    public func setTwoGradient(width : CGFloat, height : CGFloat){
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientlayer.colors = [UIColor(red: 0.26, green: 0.48, blue: 0.45, alpha: 1).cgColor,
                                UIColor(red: 0.61, green: 0.85, blue: 0.56, alpha: 1).cgColor,
                                UIColor(red: 0.16, green: 0.34, blue: 0.52, alpha: 1).cgColor]
        gradientlayer.locations = [0, 0.3064007525677447, 1]
        gradientlayer.startPoint = CGPoint(x: 2, y: -0.81)
        gradientlayer.endPoint = CGPoint(x: -0.35, y: 1.05)
        gradientlayer.cornerRadius = 20
        layer.cornerRadius = 20
        layer.insertSublayer(gradientlayer, at: 0)
    }
    
}
