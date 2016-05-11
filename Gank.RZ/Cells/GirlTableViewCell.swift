//
//  GirlTableViewCell.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/5.
//  Copyright © 2016年 robertzhang. All rights reserved.
//
import UIKit
import Kingfisher

class GirlTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var girlImage: UIImageView!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var updateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
    }
    
    func setCell(gank: GankModel) {
        self.girlImage.backgroundColor = UIColor.randomColor()
        self.girlImage.kf_setImageWithURL(NSURL(string: gank.url!)!)
        
        self.author.text = gank.who
        let date = DateUtil.stringToDate(gank.publishedAt!)
        self.updateTime.text = DateUtil.dateToString(date, dateFormat: "yyyy年MM月dd日")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
