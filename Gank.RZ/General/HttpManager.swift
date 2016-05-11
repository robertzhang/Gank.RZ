//
//  HttpManager.swift
//  ONE-Swift
//
//  Created by Robert Zhang on 16/3/31.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import Alamofire
import SwiftyJSON


class HttpManager: NSObject{
    class var sharedInstance: HttpManager {
        struct Static {
            static let instance: HttpManager = HttpManager()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
    }
    
    func requestForGetWithParameters(url: String, parameters params: [String:String], success: (json: JSON)->Void, errors: ()->Void) {
        
        // 使用 Alamofire 进行网络数据请求
        Alamofire.request(.GET, url, parameters: params).responseJSON {response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    // 这里是为了判断返回数据是否正确，可根据具体情况判断
                    guard let result = json["error"].bool where result == false else {
                        errors()
                        return
                    }
                    success(json: json)
                }
                break
            case .Failure(let error):
                NSLog("error,failure: \(error)")
                errors()
                break
            }
        }
    }
    
    func requestForGetWithOutParamameters(url: String, success: (json: JSON)->Void, errors: ()->Void) {
        // 使用 Alamofire 进行网络数据请求
        Alamofire.request(.GET, url).responseJSON {response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    guard let result = json["error"].bool where result == false else {
                        errors()
                        return
                    }
                    success(json: json)
                }
                break
            case .Failure(let error):
                NSLog("error,failure: \(error)")
                errors()
                break
            }
        }
        
    }
  
}

