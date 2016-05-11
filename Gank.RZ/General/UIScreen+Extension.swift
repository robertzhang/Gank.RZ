//
//  UIScreen+Extension.swift
//  ONE-Swift
//
//  Created by Robert Zhang on 16/4/6.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit

public extension UIScreen{
    class var size: CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    class var width: CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class var height: CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    class var orientationSize: CGSize {
        let systemVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        let isLand: Bool = UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
        return (systemVersion > 8.0 && isLand) ? UIScreen.SwapSize(self.size) : self.size
    }
    
    class var orientationWidth: CGFloat {
        return self.orientationSize.width
    }
    
    class var orientationHeight: CGFloat {
        return self.orientationSize.height
    }
    
    class var DPISize: CGSize {
        let size: CGSize = UIScreen.mainScreen().bounds.size
        let scale: CGFloat = UIScreen.mainScreen().scale
        return CGSizeMake(size.width * scale, size.height * scale)
    }
    
    class func SwapSize(size: CGSize) -> CGSize {
        return CGSizeMake(size.height, size.width)
    }
}