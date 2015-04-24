//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

//交易密码
class UpdateTradePasswordViewController: UIViewController,UITextFieldDelegate {
    //标识执行的操作
//    var flag:String!
    //修改交易密码
    @IBOutlet weak var oldPasswordLabel: UITextField!
    @IBOutlet weak var newPasswordLabel: UITextField!
    @IBOutlet weak var surePasswordLabel: UITextField!
    @IBAction func updatePwdSureTapped(sender: AnyObject) {
//        //修改密码确定按钮点击事件
//        println("update")
        if oldPasswordLabel.text == "" || newPasswordLabel.text == "" || surePasswordLabel.text == "" {
            var alert = UIAlertController(title: "提示", message: "你输入的密码不能为空", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            FVCustomAlertView.shareInstance.showDefaultErrorAlertOnView(self.view, withTitle: "修改成功", withSize: CGSize(width: 100, height: 40))
            flag = true
            
        }
    }
    
    var timer:NSTimer = NSTimer()
    var flag:Bool = false
    var time:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordLabel.delegate = self
        newPasswordLabel.delegate = self
        surePasswordLabel.delegate = self
        
//        var updateView:UIView = self.view.viewWithTag(1) as UIView!
//        var setView : UIView = self.view.viewWithTag(2) as UIView!
//        flag = "未设置121"
//        if flag == "未设置" {
//            //设置密码，显示设置，隐藏修改
//            // ?????? 设置密码view出现不了？？？
//            updateView.hidden = true
//            setView.hidden = false
//            self.title = "设置交易密码"
//        }else {
//            //修改密码，显示修改，隐藏设置
//            updateView.hidden = false
//            setView.hidden = true
//            navigationItem.title = "修改交易密码"
//            self.title = "修改交易密码"
//        }
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
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        oldPasswordLabel.resignFirstResponder()
        newPasswordLabel.resignFirstResponder()
        surePasswordLabel.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        oldPasswordLabel.resignFirstResponder()
        newPasswordLabel.resignFirstResponder()
        surePasswordLabel.resignFirstResponder()
        return true
    }
}