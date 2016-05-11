//
//  GankCell.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/6.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit
import SafariServices
import TransitionTreasury
import TransitionAnimation

class GankCell: UITableViewCell {

    @IBOutlet weak var cellTableView: UITableView!
    
    @IBOutlet weak var item: UINavigationItem!
    
    var gankData: [String:[GankModel]]?
    
    var categorys: [String] = []
    
    var topImageHeight: CGFloat = 220
    
    var lastContentY: CGFloat = 0
    
    var topImageView: UIImageView!
    
    var parentViewController: DayGankViewController?
    
    func configureCell(data: [String: [GankModel]]) {
        gankData = data
        initData()
        initTableView()
        layoutIfNeeded()
    }
    
    func initData() {
        categorys.removeAll()
        // 获取所有类型
        for key in (gankData?.keys)! {
            if key == String(Category.福利) {
                continue
            }
            categorys.append(String(key))
        }
        
        cellTableView.reloadData()
    }
    func initTableView() {
        topImageHeight = self.contentView.bounds.width * 0.65
        topImageView = UIImageView(frame: CGRect(x: 0, y: -topImageHeight, width: self.contentView.bounds.width, height: topImageHeight))
        if let imageurl = gankData![String(Category.福利)]?[0].url {
            topImageView.kf_setImageWithURL(NSURL(string: imageurl)!)
        }
        topImageView.contentMode = .ScaleAspectFill
        topImageView.clipsToBounds = true
        
        cellTableView.registerNib(UINib(nibName: CategoryCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CategoryCell.identifier)
        cellTableView.delegate = self
        cellTableView.dataSource = self
        cellTableView.contentInset = UIEdgeInsetsMake(topImageHeight, 0, 0, 0)
        cellTableView.addSubview(topImageView)
        cellTableView.rowHeight = UITableViewAutomaticDimension
        cellTableView.estimatedRowHeight = 180
    }
    
}

// MARK: UITableViewDelegate & UITableViewDataSource
extension GankCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categorys.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categorys[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let name = categorys[section]
        var number = 0
        for (key , value) in gankData! {
            if String(key) == name {
                number = value.count
                break
            }
        }
        return number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CategoryCell.identifier, forIndexPath: indexPath) as! CategoryCell
        
        for (key,value) in gankData! {
            if categorys[indexPath.section] == String(key) {
                cell.gankDescLabel.text = value[indexPath.row].desc
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = gankData![categorys[indexPath.section]]![indexPath.row].url
        let safari = SFSafariViewController(URL: NSURL(string: url!)!, entersReaderIfAvailable: true)
        safari.title = gankData![categorys[indexPath.section]]![indexPath.row].desc
        parentViewController?.presentViewController(safari, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < -topImageHeight{
            topImageView.frame.origin.y = offsetY
            topImageView.frame.size.height = -offsetY
        }
        
        // ScrollView 的滑动设置 Menu 的隐藏动画
        if lastContentY < scrollView.contentOffset.y {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
                self.parentViewController?.rootViewController?.hideMenu()
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: {
                self.parentViewController?.rootViewController?.showMenu()
                }, completion: nil)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastContentY = scrollView.contentOffset.y
    }
}