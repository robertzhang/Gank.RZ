//
//  NSObject+String.swift
//  ONE-Swift
//
//  Created by Robert Zhang on 16/3/29.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last! as String
    }
    
    //用于获取 cell 的 reuse identifier
    class var identifier: String {
        return String(format: "%@_identifier", self.nameOfClass)
    }
    
}