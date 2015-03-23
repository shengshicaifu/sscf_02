//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

//账户安全
class AccountSafeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func returnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCellWithIdentifier("firstCell") as UITableViewCell
        
        var imageView:UIImageView = cell.viewWithTag(1) as UIImageView
        var tempLabel:UILabel = cell.viewWithTag(2) as UILabel
        var realNameLabel:UILabel = cell.viewWithTag(3) as UILabel
        //标识每一项的状态：未设置，已设置
        var flagLabel:UILabel = cell.viewWithTag(4) as UILabel
        //将该label隐藏
//      flagLabel.hidden = true
        
        if indexPath.row == 0 {
            imageView.image = UIImage(named: "aaa.jpg")
            tempLabel.text = "实名认证"
            realNameLabel.text = "*杰(42*******)"
            flagLabel.text = "未设置"
        }else if indexPath.row == 1 {
            imageView.image = UIImage(named: "aaa.jpg")
            tempLabel.text = "绑定手机"
            realNameLabel.text = "135****4654"
            flagLabel.text = "已设置"
        }else{
            imageView.image = UIImage(named: "aaa.jpg")
            tempLabel.text = "交易密码"
            realNameLabel.text = "已设置，点击可修改"
            flagLabel.text = "已设置"
        }
        return cell
    }
    
    //用户点击cell之后的callBack
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //取出标识的label，判断执行修改还是设置
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("firstCell") as UITableViewCell
//        var flagLabel:UILabel = cell.viewWithTag(4) as UILabel
        let cell:UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        var flagLabel:UILabel = cell.viewWithTag(4) as UILabel
        if indexPath.row == 0 {
            if flagLabel.text == "未设置" {
                //实名未认证
                var adv = self.storyboard?.instantiateViewControllerWithIdentifier("realNameViewController") as RealNameViewController
                self.presentViewController(adv, animated: true, completion: nil)
            }else{
                //已认证,给出提示框
                var alert = UIAlertController(title: "提示", message: "您的实名认证已经设置", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }else if indexPath.row == 1 {
            var adv = self.storyboard?.instantiateViewControllerWithIdentifier("bindPhoneViewController") as BindPhoneViewController
            //将状态值赋予BindPhoneViewController的属性
            adv.flag = flagLabel.text
            self.presentViewController(adv, animated: true, completion: nil)
        }else {
            if flagLabel.text == "未设置" {
                var adv = self.storyboard?.instantiateViewControllerWithIdentifier("setTradePasswordViewController") as SetTradePasswordViewController
                self.presentViewController(adv, animated: true, completion: nil)
            }else{
                var adv = self.storyboard?.instantiateViewControllerWithIdentifier("updateTradePasswordViewController") as UpdateTradePasswordViewController
                self.presentViewController(adv, animated: true, completion: nil)
            }
        }
    }
    
}