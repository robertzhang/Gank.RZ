//
//  ViewController.swift
//  Gank.RZ
//
//  Created by Robert Zhang on 16/5/11.
//  Copyright © 2016年 robertzhang. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation


class ViewController: UIViewController , ModalTransitionDelegate{
    
    @IBOutlet weak var circleMenuGroup: CircleMenu!
    
    @IBOutlet weak var menu: UIButton!
    
    @IBAction func onClickCircleMenu(sender: AnyObject) {
        if circleMenuGroup.buttonsIsShown() {
            self.menu.hidden = true
            
        } else {
            UIView.animateWithDuration(0.35, animations: {
                self.menu.center = self.circleMenuGroup.center
                }, completion: { finsh in
                    self.menu.hidden = false
                    self.circleMenuGroup.hidden = true
                }
            )
        }
    }
    
    @IBAction func onClickMenu(sender: AnyObject) {
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseIn, animations: {
            self.menu.center = self.circleMenuGroup.center
            },completion: { finsh in
                self.circleMenuGroup.hidden = false
                self.circleMenuGroup.onTap()
                self.onClickCircleMenu(sender)
        })
    }
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?
    
    let items: [(name: String, color: UIColor)] = [
        ("Android", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ("IOS", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        ("前端", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
        ("休息视频", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        ("拓展资源", UIColor(red:1, green:0.39, blue:0.48, alpha:1)),
        ("福利", UIColor(red:0.68, green:0.19, blue:0.88, alpha:1)),
        ]
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "container_identifier" {
            let viewcontroller = segue.destinationViewController as! DayGankViewController
            viewcontroller.rootViewController = self
        }
    }
    
    func hideMenu() {
        self.menu.center.y = self.view.bounds.height + self.menu.frame.height/2
    }
    
    func showMenu() {
        self.menu.center.y = self.view.bounds.height - self.menu.frame.height
    }
}

// MARK: CirecleMenuDelegate
extension ViewController: CircleMenuDelegate {
    // don't change button.tag
    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setTitle(items[atIndex].name, forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
    }
    
    // call before animation
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        self.circleMenuGroup.hidden = true
    }
    
    // call after animation
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        self.menu.hidden = false
        push(atIndex)
    }
    
    func push(index: Int) {
        let vc: UINavigationController
        switch index {
        case 0:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavgationController_identifier") as! UINavigationController
            (vc.topViewController as! CategoryViewController).category = Category.Android
        case 1:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavgationController_identifier") as! UINavigationController
            (vc.topViewController as! CategoryViewController).category = Category.iOS
        case 2:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavgationController_identifier") as! UINavigationController
            (vc.topViewController as! CategoryViewController).category = Category.前端
        case 3:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavgationController_identifier") as! UINavigationController
            (vc.topViewController as! CategoryViewController).category = Category.休息视频
        case 4:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavgationController_identifier") as! UINavigationController
            (vc.topViewController as! CategoryViewController).category = Category.拓展资源
        case 5:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("girllist_id") as! UINavigationController
        default:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("girllist_id") as! UINavigationController
        }
        if index == 5 {
            (vc.topViewController as! GirlListViewController).modalDelegate = self
        } else {
            (vc.topViewController as! CategoryViewController).modalDelegate = self
        }
        
        tr_presentViewController(vc, method: TRPresentTransitionMethod.Fade)
    }
}
