# Gank.RZ 
这是一款基于 [Gank API](http://gank.io/api) 开发的 Swift 版本客户端，目的在于学习和总结。

> 开发语言 Swift 2.2
> 开发环境 xcode 7.3

## 截图
![初始化界面](https://github.com/robertzhang/Gank.RZ/blob/master/screenshots/01.jpeg)
![主界面](https://github.com/robertzhang/Gank.RZ/blob/master/screenshots/02.jpeg)
![主界面加载更多](https://github.com/robertzhang/Gank.RZ/blob/master/screenshots/03.jpeg)
![分类导航](https://github.com/robertzhang/Gank.RZ/blob/master/screenshots/04.jpeg)
![分类界面](https://github.com/robertzhang/Gank.RZ/blob/master/screenshots/05.jpeg)
![福利界面](https://github.com/robertzhang/Gank.RZ/blob/master/screenshots/06.jpeg)
![福利详情页](https://github.com/robertzhang/Gank.RZ/blob/master/screenshots/07.jpeg)

## Usage
克隆工程：
> git clone https://github.com/robertzhang/Gank.RZ

添加第三方资源：
> gem install cocoapods
> pod install
 
## 功能说明
### 使用开源库
swift source：

* pod "SwiftyJSON"
* pod "Alamofire"
* pod "Kingfisher"
* pod "ObjectMapper"
* pod "AlamofireObjectMapper"
* pod "AFDateHelper"
* pod "TransitionTreasury"
* pod "TransitionAnimation"

objective-c source：

* pod "SVProgressHUD"
* pod "MJRefresh"

### 简介 
该项目是这一段时间内，对 IOS & Swift 学习的总结。项目中并没有难度很大的技术，也没有使用什么高级框架。比较适合初学者参考学习。

项目中包括每日精选、分类查看，福利三个主要视图组成。

* 每日精选采用横向滑动展示内容， 滑动到最后一页进行加载更多的操作。
* 分类使用 CircleMenu 第三方控件进行导航。
* 福利仿照 Gank.lu 做的

关于 Gank API 。通过 Gank “发过干货日期接口”获取所以发布日期，再根据这些有效日期通过“每日数据接口”获取相关数据。最新的 Gank API 又添加了两个新的接口，不打算再接入Gank.RZ。感兴趣的同学可以自行研究。

## BUG
* 主界面加载更多，返回第一页。第一页图片显示异常，再次切好后页面正常

## 鸣谢 & License
* 该项目遵守 [MIT](https://github.com/robertzhang/Gank.RZ/blob/master/LICENSE) 
* 感谢 Gank API 提供的支持
* 参考 [Gank.lu](https://github.com/Panl/Gank.lu)

