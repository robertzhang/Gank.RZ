//
//  CategoryViewController.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/9.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit
import MJRefresh
import SafariServices
import TransitionTreasury
import TransitionAnimation

class CategoryViewController: UIViewController {
    
    var page = 1
    
    var ganks: [GankModel] = []
    
    var category: Category?
    
    var loadMore = false
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nav_item: UINavigationItem!
    
    @IBAction func onBack(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nav_item.title = String(category!)
        tableView.registerNib(UINib(nibName: CategoryCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CategoryCell.identifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None // 去掉cell之间的分割线
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 420
        tableView.delegate = self
        tableView.dataSource = self
        
        initMJRefresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        API.shareInstance.httpDelegate = self
    }
    
}

// MARK: MJRefresh
extension CategoryViewController : HttpDelegate {
    func initMJRefresh() {
        let mjHeader = MJRefreshNormalHeader(refreshingTarget: self,refreshingAction: #selector(self.pullToRefresh))
        mjHeader.lastUpdatedTimeLabel!.hidden = true
        mjHeader.stateLabel.textColor = UIColor.whiteColor()
        tableView.mj_header = mjHeader
        tableView.mj_header.beginRefreshing()
        
        let mjFooter = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.pullTOLoadMore))
        mjFooter.stateLabel.textColor = UIColor.whiteColor()
        tableView.mj_footer = mjFooter
    }
    
    func pullToRefresh() {
        loadMore = false
        page = 1
        API.shareInstance.gankCategoryData(category!, page: page, num: 20)
    }
    
    func pullTOLoadMore() {
        loadMore = true
        tableView.mj_footer.beginRefreshing()
        API.shareInstance.gankCategoryData(category!, page: page, num: 20)
    }
    
    // HttpDelegate
    /** 获取类型数据成功 */
    func onLoadDataSuccess(ganks: [GankModel]) {
        page += 1
        if loadMore {
            tableView.mj_footer.endRefreshing()
            if ganks.count < 20 {
                tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.ganks += ganks
            tableView.reloadData()
        } else {
            tableView.mj_footer.resetNoMoreData()
            tableView.mj_header.endRefreshing()
            self.ganks.removeAll()
            self.ganks += ganks
            self.tableView.reloadData()
        }
    }
    /** 获取数据失败 */
    func onLoadDataError() {
        ToastUtil.showTextToast("加载数据失败...")
        if loadMore {
            tableView.mj_footer.endRefreshing()
        }else{
            tableView.mj_header.endRefreshing()
        }
    }
}

// MRRK: UITableViewDelegate & UITableViewDataSource
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ganks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CategoryCell.identifier, forIndexPath: indexPath) as! CategoryCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.gankDescLabel.text = ganks[indexPath.row].desc
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = ganks[indexPath.row].url
        let safari = SFSafariViewController(URL: NSURL(string: url!)!, entersReaderIfAvailable: true)
        safari.title = ganks[indexPath.row].desc
        self.navigationController?.pushViewController(safari, animated: true)
    }
}
