//
//  ProgressHUD.swift
//  ONE-Swift
//
//  Created by Robert Zhang on 16/3/23.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import Foundation
import SVProgressHUD

class ProgressHUD: NSObject {
    class func init_HUD() {
        SVProgressHUD.setBackgroundColor(UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7 ))
        SVProgressHUD.setForegroundColor(UIColor.grayColor())
        SVProgressHUD.setFont(UIFont.systemFontOfSize(14))
        SVProgressHUD.setMinimumDismissTimeInterval(0.2)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Custom)
    }
    
    //成功
    class func showSuccessWithStatus(string: String) {
        self.ProgressHUDShow(.Success, status: string)
    }
    
    //失败 ，NSError
    class func showErrorWithObject(error: NSError) {
        self.ProgressHUDShow(.ErrorObject, status: nil, error: error)
    }
    
    //失败，String
    class func showErrorWithStatus(string: String) {
        self.ProgressHUDShow(.ErrorString, status: string)
    }
    
    //转菊花
    class func showWithStatus(string: String) {
        self.ProgressHUDShow(.Loading, status: string)
    }
    
    //警告
    class func showWarningWithStatus(string: String) {
        self.ProgressHUDShow(.Info, status: string)
    }
    
    //dismiss消失
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    //私有方法
    private class func ProgressHUDShow(type: HUDType, status: String? = nil, error: NSError? = nil) {
        switch type {
        case .Success:
            SVProgressHUD.showSuccessWithStatus(status)
            break
        case .ErrorObject:
            guard let newError = error else {
                SVProgressHUD.showErrorWithStatus("Error:出错拉")
                return
            }
            
            if newError.localizedFailureReason == nil {
                SVProgressHUD.showErrorWithStatus("Error:出错拉")
            } else {
                SVProgressHUD.showErrorWithStatus(error!.localizedFailureReason)
            }
            break
        case .ErrorString:
            SVProgressHUD.showErrorWithStatus(status)
            break
        case .Info:
            SVProgressHUD.showInfoWithStatus(status)
            break
        case .Loading:
            SVProgressHUD.showWithStatus(status)
            break
        }
    }
    
    private enum HUDType: Int {
        case Success, ErrorObject, ErrorString, Info, Loading
    }
}