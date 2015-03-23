//
//  CalleryController.swift
//  BeautyCallery
//
//  Created by zengchang on 15-3-1.
//  Copyright (c) 2015年 zengchang. All rights reserved.
//
import UIKit

class DetailViewController:UIViewController {
    var topTitle:String!
    var buttonReturn:UIButton!
    override func viewDidLoad() {
        if topTitle == "交易记录" || topTitle == "回账查询" {
            //构造一个返回按钮
            buttonReturn = UIButton(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
            buttonReturn.setTitle("返回", forState: UIControlState.Normal)
            buttonReturn.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forState: UIControlState.Normal)
            //为按钮绑定事件
            buttonReturn.addTarget(self, action: "turnBack:", forControlEvents: UIControlEvents.TouchUpInside)
            
            var titleLabel:UILabel = UILabel(frame: CGRect(x: 100, y: 10, width: 150, height: 50))
            titleLabel.text = topTitle!
            
            self.view.addSubview(buttonReturn)
            self.view.addSubview(titleLabel)
        }
        
        navigationItem.title = topTitle
    }
    
    func turnBack(sender:AnyObject){
        //返回
        self.dismissViewControllerAnimated(true, completion: nil)
//        var personCenter:PersonCenterViewController = self.storyboard?.instantiateViewControllerWithIdentifier("personCenterViewController") as PersonCenterViewController
//        
//        self.presentViewController(personCenter, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
