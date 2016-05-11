//
//  GirlListViewController.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/5.
//  Copyright © 2016年 robertzhang. All rights reserved.
//
import UIKit
import MJRefresh
import TransitionTreasury
import TransitionAnimation

// MARK: MAIN
class GirlListViewController: UIViewController {
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func onBack(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
    }
    var lastContentY: CGFloat = 0
    
    var girlData: GankModel?
    
    var girlDatas: [GankModel] = []
    
    var loadingMore = false
    
    var page = 1
    
    var loadMoreText = UILabel()
    
    var showedPosition = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.registerNib(UINib(nibName: GirlTableViewCell.nameOfClass, bundle: nil), forCellReuseIdentifier: GirlTableViewCell.identifier)
        
        tableview.separatorStyle = UITableViewCellSeparatorStyle.None // 去掉cell之间的分割线
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 420
        
        initMJRefresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        API.shareInstance.httpDelegate = self
    }
    
}

// MARK: MJRefresh
extension GirlListViewController: HttpDelegate{
    
    func initMJRefresh(){
        let mjHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.pullToRefresh))
        mjHeader.lastUpdatedTimeLabel!.hidden = true
        mjHeader.stateLabel!.textColor = UIColor.whiteColor()
        tableview.mj_header = mjHeader
        tableview.mj_header.beginRefreshing()
        let mjFooter = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.pullToLoadMore))
        mjFooter.stateLabel!.textColor = UIColor.whiteColor()
        tableview.mj_footer = mjFooter
    }
    
    func pullToRefresh(){
        loadingMore = false
        page = 1
        API.shareInstance.gankCategoryData(Category.福利, page: page)
    }
    
    func pullToLoadMore(){
        loadingMore = true
        tableview.mj_footer.beginRefreshing()
        API.shareInstance.gankCategoryData(Category.福利, page: page)
    }
    
    func onLoadDataSuccess(ganks: [GankModel]) {
        page += 1
        if loadingMore {
            tableview.mj_footer.endRefreshing()
            if ganks.count < API.number{
                tableview.mj_footer.endRefreshingWithNoMoreData()
            }
            girlDatas += ganks
            tableview.reloadData()
        }else{
            tableview.mj_footer.resetNoMoreData()
            tableview.mj_header.endRefreshing()
            girlDatas.removeAll()
            girlDatas += ganks
            tableview.reloadData()
        }
    }
    
    func onLoadDataError() {
        ToastUtil.showTextToast("加载数据失败...")
        if loadingMore {
            tableview.mj_footer.endRefreshing()
        }else{
            tableview.mj_header.endRefreshing()
        }
    }
}

// MARK: implements UITableViewDelegate & UITableViewDataSource
extension GirlListViewController: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return girlDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GirlTableViewCell.identifier, forIndexPath: indexPath) as! GirlTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None // 取消选择风格
        cell.setCell(girlDatas[indexPath.row])
        
        // cell 延迟显示的动画
        if indexPath.row > showedPosition {
            UIView.animateWithDuration(0.4, animations: {
                cell.cardView.center.y -= cell.cardView.bounds.height/1.5
            })
            showedPosition = indexPath.row
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        girlData = girlDatas[indexPath.row]
        performSegueWithIdentifier(GirlViewController.identifier, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == GirlViewController.identifier {
           let girlController = segue.destinationViewController as! GirlViewController
            girlController.girl = girlData
        }
    }
}
