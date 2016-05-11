//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

enum Category {
    case 福利
    case Android
    case IOS
    case 拓展资源
    case 前端
    case all
}

Category.拓展资源

let a = [Category.Android: [1,3,5],Category.IOS:[6],]
var b:[String] = []
for key in a.keys {
    b.append(String(key))
}
b