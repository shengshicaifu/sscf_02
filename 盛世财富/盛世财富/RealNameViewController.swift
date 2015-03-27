//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

//实名认证
class RealNameViewController: UIViewController,UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        realNameText.delegate = self
        idNumberText.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var realNameText: UITextField!
    @IBOutlet weak var idNumberText: UITextField!
    @IBAction func returnTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func commitTapped(sender: AnyObject){
        if realNameText.text == "" || idNumberText.text == "" {
                var alert = UIAlertController(title: "提示", message: "你输入的真实姓名或身份证号不能为空", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }else{
            let myStoryboard = self.storyboard
            let anotherViewController:AccountSafeViewController =  myStoryboard?.instantiateViewControllerWithIdentifier("accountSafeViewController") as AccountSafeViewController
            self.presentViewController(anotherViewController, animated: true, completion: nil)
        
//            var alert = UIAlertController(title: "认证成功", message: "情况属实", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
//            self.presentViewController(alert ,animated:true,completion:nil)
        }
    }
      //隐藏键盘
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        realNameText.resignFirstResponder()
        idNumberText.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        realNameText.resignFirstResponder()
        idNumberText.resignFirstResponder()
        return true
    }
//     func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
//        
//        return true
//    }


}