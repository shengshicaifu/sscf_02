//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit



//修改手机绑定
class BindPhoneViewController: UIViewController,UITextFieldDelegate {
    //标识执行的操作
    @IBOutlet weak var oldPhoneLabel: UILabel!
    @IBOutlet weak var oldPhoneCodeTextFied: UITextField!
    @IBAction func getPhoneCodeTapped(sender: AnyObject) {
        //点击获取验证码
    }
    @IBAction func nextStepTapped(sender: AnyObject) {
        //下一步按钮点击事件
//        var view1:UIView = self.view.viewWithTag(1) as UIView!
//        var view2:UIView = self.view.viewWithTag(2) as UIView!
        
//        view1.hidden = true
//        //view1.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0)
//        println("view1.hidden:\(view1.hidden)")
//        view2.hidden = false
//        println("view2.hidden:\(view2.hidden)")
//        println("enter...")
        
        //弹出加载的提示框
//        FVCustomAlertView.shareInstance.showDefaultLoadingAlertOnView(self.view, withTitle: "Loading")
        FVCustomAlertView.shareInstance.showDefaultErrorAlertOnView(self.view, withTitle: "数据有误", withSize: CGSize(width: 100, height: 40))
        flag = true
    }
    
    var timer:NSTimer = NSTimer()
    var flag:Bool = false
    var time:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPhoneCodeTextFied.delegate = self
//        ShowAlertView.startTimer(&timer, uvc: self)
//        ShowAlertView.hideAlertView(&flag, time: &time, view: self.view)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "hideAlertView", userInfo: nil, repeats: true)
    }
    
    //隐藏提示框
    func hideAlertView(){
        if flag {
            time++
            if time >= 30 {
                FVCustomAlertView.shareInstance.hideAlertFromView(self.view, fading: true)
                time = 0
                flag = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func returnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        oldPhoneCodeTextFied.resignFirstResponder()
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        oldPhoneCodeTextFied.resignFirstResponder()
    }
    
    
}