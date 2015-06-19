//
//  AccountSafeTableViewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/18.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  账户安全
*/
class AccountSafeTableViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    //MARK:- tableview
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //实名认证verifyRealNameSegue
        //登录密码modifyLoginPassSegue
        //交易密码 setPinPassSegue  modifyPinPassSegue
        //绑定手机 modifyPhoneStepFirstSegue
        //手势密码 handPasswordSegue
        var cell = tableView.dequeueReusableCellWithIdentifier("accountSafeCell") as! UITableViewCell
        var leftLabel = cell.viewWithTag(1) as! UILabel
        var rightLabel = cell.viewWithTag(2) as! UILabel
        var tipImageView = cell.viewWithTag(3) as! UIImageView
        var leftText:String = ""
        var rightText:String = ""
        
        var row = indexPath.row
        
        if row == 0 {
            
            leftText = "实名认证"
            
            let isUpload = NSUserDefaults.standardUserDefaults().objectForKey("isUpload") as? NSString
            if isUpload == nil || isUpload == "" {
                rightText = "未实名认证"
            } else {
                let isVerify = NSUserDefaults.standardUserDefaults().objectForKey("isVerify") as? String
                if isVerify == "0" {
                    rightText = "未实名认证"
//                    cell.accessoryType = UITableViewCellAccessoryType.None
//                    cell.userInteractionEnabled = false
                }else if isVerify == "1" {
                    tipImageView.image = UIImage(named: "yes")
                    rightText = Common.replaceStringToX(isUpload!, start: 2, end: isUpload!.length-4)
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    cell.userInteractionEnabled = false
                }
            }
            
        }else if row == 1{
            leftText = "登录密码"
            rightText = "修改"
        }else if row == 2{
            leftText = "交易密码"
            let pinpass = NSUserDefaults.standardUserDefaults().objectForKey("pinpass") as? NSString
            if pinpass == nil {
                rightText = "请设置交易密码"
            } else {
                rightText = "修改交易密码"
                tipImageView.image = UIImage(named: "yes")
            }
        }else if row == 3{
            
            //绑定手机
            leftText = "绑定手机"
            var phone = NSUserDefaults.standardUserDefaults().objectForKey("phone") as? NSString
            if phone != nil {
                rightText = Common.replaceStringToX(phone!, start: 3, end: 7)
                tipImageView.image = UIImage(named: "yes")
            }
            
        }
//        else if row == 4{
//            leftText = "手势密码"
//            rightText = ""
//        }
        leftLabel.text = leftText
        rightLabel.text = rightText
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedRow = indexPath.row
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        var rightLabel = cell?.viewWithTag(2) as! UILabel
        if selectedRow == 0 {
//            let isUpload = NSUserDefaults.standardUserDefaults().objectForKey("isUpload") as? NSString
//            if isUpload == nil || isUpload == "" {
//                self.performSegueWithIdentifier("verifyRealNameSegue", sender:nil)
//            }
            let isVerify = NSUserDefaults.standardUserDefaults().objectForKey("isVerify") as? NSString
            if isVerify != "1" {
                //未实名认证通过
                self.performSegueWithIdentifier("verifyRealNameSegue", sender:nil)
            }
        }else if selectedRow == 1 {
            self.performSegueWithIdentifier("modifyLoginPassSegue", sender: nil)
        }else if selectedRow == 2 {
            let pinpass = NSUserDefaults.standardUserDefaults().objectForKey("pinpass") as? NSString
            if pinpass == nil {
                var view = self.storyboard?.instantiateViewControllerWithIdentifier("setPinPasswordViewController") as! SetPinPasswordViewController
                self.presentViewController(view, animated: true, completion: nil)
            }else{
                self.performSegueWithIdentifier("modifyPinPassSegue", sender: nil)
            }
        }else if selectedRow == 3 {
            self.performSegueWithIdentifier("modifyPhoneStepFirstSegue", sender: nil)
        }
//        else if selectedRow == 4 {
//            self.performSegueWithIdentifier("handPasswordSegue", sender: nil)
//        }
    }
    
}
