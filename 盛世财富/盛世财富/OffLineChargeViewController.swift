//
//  OffLineChargeViewController.swift
//  盛世财富
//  线下充值
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
        resignAll()
        
        
        let user = NSUserDefaults.standardUserDefaults()
        let url = Common.serverHost+"/App-Pay-offline"
        let afnet = AFHTTPRequestOperationManager()
        var param:AnyObject?
        if choose.selectedSegmentIndex == 0{
            if t_money.text.isEmpty {
                AlertView.showMsg("请输入金额！", parentView: self.view)
                return
            }
            if !Common.isMoney(t_money.text) {
                AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
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
            param = ["to":user.stringForKey("token"),"money_off":t_money.text,"off_bank":"兴业银行","off_way":t_account.text,"tran_id":t_id.text]
        }
        if choose.selectedSegmentIndex == 1{
            
            if p_money.text.isEmpty {
                AlertView.showMsg("请输入金额！", parentView: self.view)
                return
            }
            if !Common.isMoney(p_money.text) {
                AlertView.showMsg(Common.moneyErrorTip, parentView: self.view)
                return
            }
            if p_id.text.isEmpty {
                AlertView.showMsg("请输入交易参考号！", parentView: self.view)
                return
            }
            
            param = ["to":user.stringForKey("token"),"money_off":p_money.text,"off_bank":"无","off_way":"pos机刷卡","tran_id":p_id.text]
        }
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {
                
                AlertView.alert("提示", message: "网络连接有问题，请检查手机网络", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.view)
                afnet.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                afnet.POST(url, parameters: param, success: { (opration:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                    loading.stopLoading()
                    AlertView.showMsg(data["message"] as! String, parentView:  self.view)
//                    AlertView.alert("提示", message: data["message"], buttonTitle:"确定", viewController: self)
                     self.navigationController?.popViewControllerAnimated(true)
                    }) { (opration:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("错误", message: error.localizedDescription, buttonTitle: "确定", viewController: self)
                }
            })
        }
        reach.startNotifier()
        
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
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        resignAll()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignAll()
        return true
    }
    
    func resignAll(){
        t_money.resignFirstResponder()
        t_account.resignFirstResponder()
        t_id.resignFirstResponder()
        p_money.resignFirstResponder()
        p_id.resignFirstResponder()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }

}