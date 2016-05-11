//
//  DayGankViewController.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/6.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit

class DayGankViewController: UIViewController{
    
    var gankPage = 0
    
    var datas: [[String : [GankModel]]] = [[:]]
    
    /** 存放发布日期 */
    var history: [String] = []
    
    var htv: HBHorizontalTableView?
    
    var rootViewController: ViewController?
    
    var isfirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        API.shareInstance.httpDelegate = self
        // 首次加载，需获取最新的数据
        API.shareInstance.gankHistory()
    }
    
    func register() {
        htv = HBHorizontalTableView(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height))
        htv!.register(GankCell.nameOfClass, cellClass: GankCell.self, identifier: GankCell.identifier)
        htv!.delegate = self
        self.view.addSubview(htv!)
    }
    
    override func viewDidAppear(animated: Bool) {
        API.shareInstance.httpDelegate = self
    }
    
    
}

// MARK: Horizontal TableView Delegate
extension DayGankViewController: HBTableViewDelegate, HttpDelegate {
    
    // HttpDelegate
    func onLoadDaySuccess(days: [String]) {
        history += days
        isfirst = true
        API.shareInstance.gankDayData(history[gankPage])
    }
    
    func onLoadDayDataSuccess(categoryGanks: [String : [GankModel]]) {
        // 下面这样做的目的是 tableview:numberOfRowsInSection 初始化的时候需要 datas 不为nil,
        // datas = [[:]] 初始化,默认datas.count = 1。
        // 如果下面不做判断，则会第一页为空视图
        if isfirst {
            datas[0] = categoryGanks
            isfirst = false
        } else {
            datas.append(categoryGanks)
        }
        gankPage += 1
        self.htv?.tableView?.reloadData()
    }
    
    // HBTableViewDelegate
    func onLoadMore() {
        API.shareInstance.gankDayData(history[gankPage])
    }
    
    func numberOfSectionsInTableView(horizontalTableView: HBHorizontalTableView) -> Int {
        return 1
    }
    
    func tableView(horizontalTableView: HBHorizontalTableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(horizontalTableView: HBHorizontalTableView, widthForCellAtIndexPath: NSIndexPath) -> CGFloat {
        //cell的内容高度
        return self.view.bounds.width
    }
    
    func tableView(horizontalTableView: HBHorizontalTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = horizontalTableView.tableView!.dequeueReusableCellWithIdentifier(GankCell.identifier, forIndexPath: indexPath) as! GankCell
        
        cell.configureCell(datas[indexPath.row])
        cell.parentViewController = self
        
        // 给tableview加入footview
        if (indexPath.row == self.datas.count-1) {
            horizontalTableView.tableView!.tableFooterView = horizontalTableView.infiniteScrollingView
        }
        
        return cell
    }
    
    
    func tableView(horizontalTableView: HBHorizontalTableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected row -> \(indexPath.row)")
        horizontalTableView.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    }

}