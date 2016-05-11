//
//  ToastUtil.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/5.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import Foundation
import SVProgressHUD

class ToastUtil {
    static func showTextToast(string: String? = "发生错误！"){
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.setMinimumDismissTimeInterval(2.3)
        SVProgressHUD.showSuccessWithStatus("\(string!)")
    }
}