//
//  GirlViewController.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/6.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit

class GirlViewController: UIViewController , UIScrollViewDelegate{
    
    var girl: GankModel?

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var girlImage: UIImageView!
    
    @IBAction func onSaveClick(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(girlImage.image!, self, #selector(GirlViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image:UIImage,didFinishSavingWithError:NSError,contextInfo:AnyObject){
        ToastUtil.showTextToast("保存成功")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.delegate = self
        
        self.girlImage.kf_setImageWithURL(NSURL(string: (girl?.url)!)!)
        let date = DateUtil.stringToDate((girl?.publishedAt!)!)
        self.title = DateUtil.dateToString(date, dateFormat: "yyyy/MM/dd")
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.girlImage
    }
}
