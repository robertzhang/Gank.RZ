//
//  API.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/4.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import ObjectMapper

/**
 获取日期接口: http://gank.io/api/day/history
 分类数据: http://gank.io/api/data/数据类型/请求个数/第几页
 每日数据： http://gank.io/api/day/年/月/日
 随机数据：http://gank.io/api/random/data/分类/个数
 */

// 分类
enum Category {
    case 福利
    case Android
    case iOS
    case 拓展资源
    case 前端
    case 休息视频
    case all
}

@objc protocol HttpDelegate {
    /** 获取发布日期成功 */
    optional func onLoadDaySuccess(days: [String])
    /** 获取每日数据成功*/
    optional func onLoadDayDataSuccess(categoryGanks: [String : [GankModel]])
    /** 获取类型数据成功 */
    optional func onLoadDataSuccess(ganks: [GankModel])
    /** 获取数据失败 */
    optional func onLoadDataError()
}

class API {
    var baseURL = "http://gank.io/api/"
    /** 每次获取的数据量 */
    static let number = 15
    var httpDelegate: HttpDelegate?
    private static let instance = API()
    
    class var shareInstance: API {
        return instance;
    }
    
    /** 通过分类获取数据 */
    func gankCategoryData(category: Category, page: Int, num: Int? = API.number){
        // 对 StringURL 进行编码格式转换，否则会报错
        let url = (baseURL + "data/\(category)/\(num!)/\(page)").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!

        var ganks:[GankModel] = []
        HttpManager.sharedInstance.requestForGetWithOutParamameters(
            url,
            success: { json in
                for item in json["results"].arrayValue {
                    let list = Mapper<GankModel>().map(item.rawValue)
                    ganks.append(list!)
                }
                self.httpDelegate?.onLoadDataSuccess!(ganks)
            },
            errors: {
                self.httpDelegate?.onLoadDataError!()
        })
    }
    
    /** 通过日期获取数据 */
    func gankDayData(str: String) {
        let url = (baseURL + "day/\(str.getYear())/\(str.getMonth())/\(str.getDay())").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        var ganks: [String : [GankModel]] = [:]
        HttpManager.sharedInstance.requestForGetWithOutParamameters(
            url,
            success: { json in
                let categorys = json["category"].array
                for category in categorys! {
                    ganks[category.string!] = []
                    
                    for item in json["results"][category.string!].array! {
                        let list = Mapper<GankModel>().map(item.rawValue)
                        ganks[category.string!]!.append(list!)
                    }
                }
                self.httpDelegate?.onLoadDayDataSuccess!(ganks)
            }, errors: {
                self.httpDelegate?.onLoadDataError!()
        })
        
    }
    /** 获取发布日期 */
    func gankHistory() {
        let url = (baseURL + "day/history").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        var strs: [String] = []
        HttpManager.sharedInstance.requestForGetWithOutParamameters(
            url,
            success: { json in
                for item in json["results"].arrayValue {
                    strs.append(item.string!)
                }
                
                self.httpDelegate?.onLoadDaySuccess!(strs)
            },
            errors: {
               self.httpDelegate?.onLoadDataError!()
        })
    }
    
    /** 获取随机数据 */
    func gankRandomData(category: Category) {
        let url = (baseURL + "random/data/\(category)/\(API.number)").stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        var ganks:[GankModel] = []
        HttpManager.sharedInstance.requestForGetWithOutParamameters(
            url,
            success: { json in
                for item in json["results"].arrayValue {
                    let list = Mapper<GankModel>().map(item.rawValue)
                    ganks.append(list!)
                }
                self.httpDelegate?.onLoadDataSuccess!(ganks)
            },
            errors: {
               self.httpDelegate?.onLoadDataError!()
        })
    }
    
}