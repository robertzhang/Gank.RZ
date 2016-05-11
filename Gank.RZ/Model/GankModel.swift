//
//  Item.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/4.
//  Copyright © 2016年 robertzhang. All rights reserved.
//
import ObjectMapper

class GankModel: NSObject, Mappable{
    
    var _id: String?
    var createdAt: String?
    var desc: String?
    var publishedAt: String?
    var source: String?
    var type: String?
    var url: String?
    var used: Bool?
    var who: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id             <- map["_id"]
        createdAt       <- map["createdAt"]
        desc            <- map["desc"]
        publishedAt     <- map["publishedAt"]
        source          <- map["source"]
        type            <- map["type"]
        url             <- map["url"]
        used            <- map["used"]
        who             <- map["who"]
    }
}