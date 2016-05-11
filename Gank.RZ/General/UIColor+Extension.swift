//
//  UIColor+Extension.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/5.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit

extension UIColor {
    static func color(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
    
    static func randomColor()->UIColor{
        let red = CGFloat(arc4random_uniform(255))
        let green = CGFloat(arc4random_uniform(255))
        let blue = CGFloat(arc4random_uniform(255))
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 0.8)
    }
}