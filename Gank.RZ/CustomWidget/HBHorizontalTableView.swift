//
//  HBHorizontalTableView.swift
//  ONE-Swift
//
//  Created by Robert Zhang on 16/3/29.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit
import Foundation

@objc protocol HBTableViewDelegate: NSObjectProtocol {
    func tableView(horizontalTableView: HBHorizontalTableView, numberOfRowsInSection section: Int) -> Int
    func tableView(horizontalTableView: HBHorizontalTableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    
    optional func numberOfSectionsInTableView(horizontalTableView: HBHorizontalTableView) -> Int
    optional func tableView(horizontalTableView: HBHorizontalTableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    optional func tableView(horizontalTableView: HBHorizontalTableView, viewForHeaderInSection section: Int) -> UIView?
    optional func tableView(horizontalTableView: HBHorizontalTableView, viewForFooterInSection section: Int) -> UIView?
    optional func tableView(horizontalTableView: HBHorizontalTableView, widthForCellAtIndexPath: NSIndexPath) -> CGFloat
    
    // 刷新操作，add by zhangchao
    func onLoadMore()
//    func onPullToFresh()
}

class HBHorizontalTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    var delegate: HBTableViewDelegate?
    var tableView: UITableView?
    
    var rowWidth: CGFloat {
        get {
            return tableView!.rowHeight
        }
    }
    
    var contentSize: CGSize {
        get {
            let size: CGSize = tableView!.contentSize
            return CGSizeMake(size.height, size.width)
        }
    }
    
    var contentOffset: CGPoint {
        get {
            let offset: CGPoint = tableView!.contentOffset
            return CGPointMake(offset.y, offset.x)
        }
    }
    
    var animated: Bool?
    
    // 加载更多 by zhangchao
    var infiniteScrollingView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("horizontal TableView -> initWithFrame")
        setTableView()
        set_Frame(self.frame)
        setContentOffset(self.contentOffset)
        setRowWidth(self.rowWidth)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("horizontal TableView -> awakeFromNib")
        setTableView()
        set_Frame(self.frame)
        setContentOffset(self.contentOffset)
        setRowWidth(self.rowWidth)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func register(nibName: String, cellClass: AnyClass?, identifier: String) {
        self.tableView!.registerClass(cellClass, forCellReuseIdentifier: identifier)
        let cellNib: UINib = UINib(nibName: nibName, bundle: nil)
        self.tableView!.registerNib(cellNib, forCellReuseIdentifier: identifier)
    }
    
    func setTableView() {
        refreshOrientation()
        
        let tableView = UITableView(frame: self.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.showsVerticalScrollIndicator = false
        
        // add by zhangchao
        tableView.pagingEnabled = true
        

        self.addSubview(tableView)
        self.tableView = tableView
        
        //加载更多
        self.setupInfiniteScrollingView()
        
    }
    
    func set_Frame(frame: CGRect) {
        super.frame = frame
        refreshOrientation()
    }
    
    func setContentOffset(offset: CGPoint) {
        setContentOffset(offset, animated: false)
    }
    
    func setContentOffset(offset: CGPoint, animated: Bool) {
        tableView!.setContentOffset(CGPointMake(offset.x, offset.y), animated: animated)
    }
    
    func setRowWidth(rowWidth: CGFloat) {
        tableView!.rowHeight = rowWidth
    }
    
    func refreshOrientation() {
        if tableView == nil { return }
        
        // First reset rotation
        tableView!.transform = CGAffineTransformIdentity
        tableView!.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
        
        // Adjust frame
        let xOrigin = (self.bounds.size.width - self.bounds.size.height) / 2.0
        let yOrigin = (self.bounds.size.height - self.bounds.size.width) / 2.0
        tableView!.frame = CGRectMake(xOrigin, yOrigin, self.bounds.size.height, self.bounds.size.width)
        
        // Apply rotation again
        tableView!.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        tableView!.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.height - 7.0)
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if delegate!.respondsToSelector(#selector(HBTableViewDelegate.tableView(_:viewForHeaderInSection:))) {
            let headerView: UIView = delegate!.tableView!(self, viewForHeaderInSection: section)!
            return headerView.frame.size.width
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if delegate!.respondsToSelector(#selector(HBTableViewDelegate.tableView(_:viewForFooterInSection:))) {
            let footerView: UIView = delegate!.tableView!(self, viewForFooterInSection: section)!
            return footerView.frame.size.width
        }
        return 0
    }
    
    func viewToHoldSectionView(sectionView: UIView) -> UIView {
        sectionView.frame = CGRectMake(0, 0, sectionView.frame.size.width, self.frame.size.height)
        let rotatedView = UIView(frame: sectionView.frame)
        rotatedView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
        sectionView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
        rotatedView.addSubview(sectionView)
        return rotatedView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if delegate!.respondsToSelector(#selector(HBTableViewDelegate.tableView(_:viewForHeaderInSection:))) {
            let sectionView: UIView = delegate!.tableView!(self, viewForHeaderInSection: section)!
            return viewToHoldSectionView(sectionView)
        }
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if delegate!.respondsToSelector(#selector(HBTableViewDelegate.tableView(_:viewForFooterInSection:))) {
            let sectionView: UIView = delegate!.tableView!(self, viewForFooterInSection: section)!
            return viewToHoldSectionView(sectionView)
        }
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate!.respondsToSelector(#selector(HBTableViewDelegate.tableView(_:didSelectRowAtIndexPath:))) {
            delegate!.tableView!(self, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if delegate!.respondsToSelector(#selector(HBTableViewDelegate.tableView(_:widthForCellAtIndexPath:))) {
            return delegate!.tableView!(self, widthForCellAtIndexPath: indexPath)
        }
        return tableView.rowHeight
    }
    
    
    // MARK: TableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if delegate!.respondsToSelector(#selector(HBTableViewDelegate.numberOfSectionsInTableView(_:))) {
            return delegate!.numberOfSectionsInTableView!(self)
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.tableView(self, numberOfRowsInSection: section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = delegate!.tableView(self, cellForRowAtIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        // Rotate if needed
        if CGAffineTransformEqualToTransform(cell.contentView.transform, CGAffineTransformIdentity) {
            
            let xOrigin = (cell.bounds.size.width - cell.bounds.size.height) / 2.0
            let yOrigin	= (cell.bounds.size.height - cell.bounds.size.width) / 2.0
            cell.contentView.frame = CGRectMake(yOrigin, xOrigin, cell.bounds.size.height, cell.bounds.size.width)
            cell.contentView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2.0))
            
        }

        return cell
    }
    
}

// MARK: ScrollViewDelegate implements
extension HBHorizontalTableView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.width) {
            //滑到底部加载更多
            loadMore()
            NSLog("滑到底部加载更多===");
        }
        if (scrollView.contentOffset.y < 0) {
            //滑到顶部更新
            NSLog("滑到顶部更新===");
        }
    }
    
    
    func loadMore() {
        return delegate!.onLoadMore()
    }
    
    //加载视图
    private func setupInfiniteScrollingView() {
        var temp = NSBundle.mainBundle().loadNibNamed("Refresh", owner: self, options: nil)
        let activityViewIndicator = temp[0] as! HeaderOrFooterView
        
        self.infiniteScrollingView = UIView(frame: CGRectMake(0, 0, UIScreen.height, UIScreen.width))
        
        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.infiniteScrollingView!.backgroundColor = UIColor.color(25, green: 118, blue: 210, alpha: 1)
        
        activityViewIndicator.center = (self.infiniteScrollingView?.center)!
        activityViewIndicator.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2.0))
        
        activityViewIndicator.indicator.startAnimating()
        self.infiniteScrollingView!.addSubview(activityViewIndicator)
        
    }
}
