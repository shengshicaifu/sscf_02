//
//  OffLineChargeViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/5/23.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class OffLineChargeViewController:UIViewController {
    @IBOutlet weak var choose: UISegmentedControl!
    @IBOutlet weak var transfer: UIView!
    @IBOutlet weak var pos: UIView!
    @IBOutlet weak var t_money: UITextField!
    @IBOutlet weak var t_account: UITextField!
    @IBOutlet weak var t_id: UITextField!
    @IBOutlet weak var p_money: UITextField!
    @IBOutlet weak var p_id: UITextField!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn1.layer.cornerRadius = 5
        btn2.layer.cornerRadius = 5
        choose.selectedSegmentIndex = 0
    }
    
    @IBAction func submit(sender: UIButton) {
        if t_money.text.isEmpty {
            AlertView.showMsg("请输入金额！", parentView: self.view)
            return
        }
        if t_account.text.isEmpty {
            AlertView.showMsg("请输入银行账号！", parentView: self.view)
            return
        }
        if t_id.text.isEmpty {
            AlertView.showMsg("请输入汇款单号！", parentView: self.view)
            return
        }
        if p_money.text.isEmpty {
            AlertView.showMsg("请输入金额！", parentView: self.view)
            return
        }
        if p_id.text.isEmpty {
            AlertView.showMsg("请输入交易参考号！", parentView: self.view)
            return
        }
        
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Pay-offline"
        let afnet = AFHTTPRequestOperationManager()
        var param:AnyObject?
        if choose.selectedSegmentIndex == 0{
            param = ["to":user.stringForKey("token"),"money_off":t_money.text,"off_bank":"兴业银行","off_way":t_account.text,"tran_id":t_id.text]
        }
        if choose.selectedSegmentIndex == 1{
            param = ["to":user.stringForKey("token"),"money_off":p_money.text,"off_bank":"无","off_way":"pos机刷卡","tran_id":p_id.text]
        }
        afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
            
            AlertView.showMsg(data["message"] as! String, parentView: self.view)
            }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
            AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
        }
        

    }
    @IBAction func segChange(sender: UISegmentedControl) {
        //开始动画
        UIView.beginAnimations("test",context: nil)
        //动画时长
        UIView.setAnimationDuration(1)
        // FlipFromRight
        // CurlUp
        //动画样式
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft,
            forView :self.view,
            cache:true)
        //更改view顺序
        self.view.exchangeSubviewAtIndex(0,withSubviewAtIndex :1)
        //提交动画
        UIView.commitAnimations()
                
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}