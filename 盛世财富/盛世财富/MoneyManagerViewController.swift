//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

//资金管理
class MoneyManagerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var imageView:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func returnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
//    var arrString:[String] = ["aaaa","bbbb","cccc","dddd"]
    @IBOutlet weak var tableView: UITableView!
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section.hashValue == 1{
            return 2
        }
        else{
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int)->CGFloat{
        return 0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int)->CGFloat{
        return 50
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 75
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                return 50
            }
        }
       
            return 150
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = self.tableView.dequeueReusableCellWithIdentifier("transRecordCell") as! UITableViewCell
        cell.selectedBackgroundView.backgroundColor = UIColor.grayColor()
        cell.backgroundColor = UIColor.grayColor()
        if indexPath.section == 0{
            if indexPath.row == 0{
                var moneylabel:UILabel = UILabel(frame: CGRectMake(10, 10, 200, 20))
                moneylabel.text = "账户净资产(元)"
                var moneyNo:UILabel = UILabel(frame: CGRectMake(10, 55, 50, 20))
                moneyNo.text = "0.00"
                cell.addSubview(moneyNo)
                cell.addSubview(moneylabel)
            }
        }
        else if indexPath.section == 1{
            if indexPath.row == 0{
                var managerMoneylabel:UILabel = UILabel(frame: CGRectMake(10, 10, 200, 20))
                managerMoneylabel.text = "理财资产(元)"
                var managerMoneyNo:UILabel = UILabel(frame: CGRectMake(10, 50, 50, 20))
                managerMoneyNo.text = "0.00"
                var wathMoneylabel:UILabel = UILabel(frame: CGRectMake(10, 90, 200, 20))
                wathMoneylabel.text = "债权投资(元)"
                var wathMoneyNo:UILabel = UILabel(frame: CGRectMake(10, 130, 50, 20))
                wathMoneyNo.text = "0.00"
                var UMoneylabel:UILabel = UILabel(frame: CGRectMake(200, 90, 200,20))
                UMoneylabel.text = "U计划(元)"
                var UMoneyNo:UILabel = UILabel(frame: CGRectMake(200, 130, 50, 20))
                UMoneyNo.text = "0.00"
                cell.addSubview(managerMoneylabel)
                cell.addSubview(managerMoneyNo)
                cell.addSubview(wathMoneylabel)
                cell.addSubview(wathMoneyNo)
                cell.addSubview(UMoneylabel)
                cell.addSubview(UMoneyNo)
            }
            else{
                var managerMoneylabel:UILabel = UILabel(frame: CGRectMake(10, 10, 200, 20))
                managerMoneylabel.text = "账户余额(元)"
                var managerMoneyNo:UILabel = UILabel(frame: CGRectMake(10, 50, 50, 20))
                managerMoneyNo.text = "0.00"
                var wathMoneylabel:UILabel = UILabel(frame: CGRectMake(10, 90, 200, 20))
                wathMoneylabel.text = "可用金额(元)"
                var wathMoneyNo:UILabel = UILabel(frame: CGRectMake(10, 130, 50, 20))
                wathMoneyNo.text = "0.00"
                var UMoneylabel:UILabel = UILabel(frame: CGRectMake(200, 90, 200, 20))
                UMoneylabel.text = "冻结金额(元)"
                var UMoneyNo:UILabel = UILabel(frame: CGRectMake(200, 130, 50, 20))
                UMoneyNo.text = "0.00"
                cell.addSubview(managerMoneylabel)
                cell.addSubview(managerMoneyNo)
                cell.addSubview(wathMoneylabel)
                cell.addSubview(wathMoneyNo)
                cell.addSubview(UMoneylabel)
                cell.addSubview(UMoneyNo)
            }
        }
        else{
            var chargeButton:UIButton = UIButton(frame: CGRectMake(0, 0, 190,50))
            chargeButton.setTitle("充值", forState: UIControlState.Normal )
            var withdrawButton:UIButton = UIButton(frame: CGRectMake(190, 0, 190, 50 ))
            withdrawButton.setTitle("提现", forState: UIControlState.Normal)
            chargeButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            withdrawButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
//            chargeButton.backgroundColor = UIColor.greenColor()
//            withdrawButton.backgroundColor = UIColor.redColor()
            cell.addSubview(chargeButton)
            cell.addSubview(withdrawButton)
            chargeButton.addTarget(self, action: "chargeAppTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            withdrawButton.addTarget(self, action: "withdrawAppTapped", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
//        //取出控件
//        var label1 = cell.viewWithTag(1) as UILabel
//        var label2 = cell.viewWithTag(2) as UILabel
//        
//        //对控件进行赋值
//        for string in arrString {
//            label1.text = string
//            label2.text = string + "1111"
//        }
        
        return cell
    }
    
    func chargeAppTapped(sender:AnyObject){
         var mainView = self.storyboard?.instantiateViewControllerWithIdentifier("chargeViewController") as!  ChargeViewController
//        self.navigationController?.pushViewController(mainView, animated: true)
        self.presentViewController(mainView, animated: true, completion: nil)
        
//        var alert = UIAlertController(title: "提示", message: "进入充值页面", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)

        
    }
    func withdrawAppTapped(sender:AnyObject){
        var alert = UIAlertController(title: "提示", message: "进入提现页面", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        
    }
}