//
//  VerifyRealNameViewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/5/27.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//
import Foundation
import UIKit
/**
*  实名认证控制器
*/
class VerifyRealNameViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var styleView: UIView!
    @IBOutlet weak var realNameTextField: UITextField!
    @IBOutlet weak var idcardTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var cardFrontImage:UIImage?
    var cardBackImage:UIImage?
    var cardHandImage:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realNameTextField.delegate = self
        idcardTextField.delegate = self
        
        Common.customerBgView(styleView)
        Common.customerButton(confirmButton)
        Common.addBorder(realNameTextField)
        Common.addBorder(realNameLabel)
    
    }
    
   
    //提交
    @IBAction func okTapped(sender: UIButton) {
        resignAll()
        
        //输入验证
        var realName = realNameTextField.text
        if realName.isEmpty {
            AlertView.showMsg("请输入姓名", parentView: self.view)
            return
        }
        if !Common.stringLengthIn(realName, start: 1, end: 20){
            AlertView.showMsg("姓名长度不能超过20个字符", parentView: self.view)
            return
        }
        var idcard = idcardTextField.text
        if idcard.isEmpty {
            AlertView.showMsg("请输入身份证号码", parentView: self.view)
            return
        }
        if let str:NSString = idcard{
            if str.length != 18 {
                AlertView.showMsg("请输入18位身份证号码", parentView: self.view)
                return
            }
        }
           //提交数据
        //检查手机网络
        var reach = Reachability(hostName: Common.domain)
        reach.unreachableBlock = {(r:Reachability!) -> Void in
            //NSLog("网络不可用")
            dispatch_async(dispatch_get_main_queue(), {

                AlertView.alert("提示", message: "网络连接有问题，请检查网络是否连接", buttonTitle: "确定", viewController: self)
            })
        }
        
        reach.reachableBlock = {(r:Reachability!) -> Void in
           //NSLog("网络可用")
            dispatch_async(dispatch_get_main_queue(), {
                loading.startLoading(self.view)
                var manager = AFHTTPRequestOperationManager()
                var url = Common.serverHost + "/App-Ucenter-verifyRealName"
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
                var params = ["to":token!,"real_name":realName,"idcard":idcard]
                //NSLog("实名认证参数%@", params)
                manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
                manager.POST(url, parameters: params, success: { (operation:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                        loading.stopLoading()
                        var result = data as! NSDictionary
                        //NSLog("实名认证提交返回信息%@", result)
                        var code = result["code"] as! Int
                        if code == 0 {
                            AlertView.alert("提示", message: result["message"] as! String, buttonTitle: "确定", viewController: self)
                        }else if code == -1 {
                            AlertView.alert("提示", message: result["message"] as! String, buttonTitle: "确定", viewController: self)
                        }else if code == 200 {
                            
                            //将用户的idcard和isVerify放入userdefault中
                            
                            var userdefault = NSUserDefaults.standardUserDefaults()
                            userdefault.setObject(idcard, forKey: "isUpload")
                            userdefault.setObject("1", forKey: "isVerify")
                            
                            AlertView.alert("提示", message: "实名认证通过", buttonTitle: "确定", viewController: self, callback: { (alertAction:UIAlertAction!) -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                    
                    }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                        loading.stopLoading()
                        AlertView.alert("提示", message: "服务器异常", buttonTitle: "确定", viewController: self)
                        
                })

            })
        }
      
        reach.startNotifier()
        
    }
    
    //MARK:- 隐藏键盘
    override func viewWillAppear(animated: Bool) {
        DaiDodgeKeyboard.addRegisterTheViewNeedDodgeKeyboard(self.view)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        DaiDodgeKeyboard.removeRegisterTheViewNeedDodgeKeyboard()
        super.viewWillDisappear(animated)
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        if textField == idcardTextField{
            var str = string as NSString
            var lengthOfString:NSInteger = str.length;
            for (var loopIndex:NSInteger = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
                var character:unichar = str.characterAtIndex(loopIndex)
                if (character < 48) {
                    return false
                } // 48 unichar for 0
                if (character > 57){
                    return false
                } // 57 unichar for 9
            }
            var inputString = textField.text as NSString
            // Check for total length
            var proposedNewLength:NSInteger = inputString.length - range.length + str.length;
            if (proposedNewLength > 18) {
                return false
            }//限制长度
            return true
        }else{
            if range.location >= 20{
                return false
            }else{
                return true
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == realNameTextField {
            idcardTextField.becomeFirstResponder()
        }else if textField == idcardTextField{
            resignAll()
        }
        
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        resignAll()
        
    }
    
    func resignAll(){
        realNameTextField.resignFirstResponder()
        idcardTextField.resignFirstResponder()
    }

}
