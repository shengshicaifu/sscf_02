//
//  ModifyPhoneStepFirstViewController.swift
//  盛世财富
//  修改手机号码第一步
//  Created by 云笺 on 15/5/20.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class ModifyPhoneStepFirstViewController: UIViewController {

    
    @IBOutlet weak var oldPhoneLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var getCodeButton: UIButton!
    var phone:String!
    var timer:NSTimer!
    var f_id:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        phone = NSUserDefaults.standardUserDefaults().objectForKey("phone") as! String
        ///phone = "15527410109"
        self.oldPhoneLabel.text = phone
        
    }
    
    //获取验证码
    @IBAction func getCodeTapped(sender: UIButton) {
        resignAll()
        
        //禁用获取验证码按钮60秒
        getCodeButton.enabled = false
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "repeat", userInfo: nil, repeats: true)
        
        //获取验证码
        var url = Constant.getServerHost() + "/App-Ucenter-sendphone"
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
        var params = ["to":token,"cellphone":phone]
        NSLog("发送验证码参数：%@", params)
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        loading.startLoading(self.view)
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                loading.stopLoading()
                
                var result = data as! NSDictionary
                NSLog("验证码%@", result)
                var code = result["code"] as! Int
                var msg:String = ""
                if code == 0 {
                    msg = "验证码发送失败，请重试!"
                }else if code == 1 {
                    msg = "手机号已被别人使用!"
                }else if code == 100 {
                    msg = "短信验证码发送成功"
                }
                AlertView.showMsg(msg, parentView: self.view)
            },
            failure:{ (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                loading.stopLoading()
                println(error)
                AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
            }
        )
    }
    
    var i = 60
    func repeat(){
        getCodeButton.setTitle("\(i)", forState: UIControlState.Disabled)
        i--
        if i == 0 {
            i = 60
            timer.invalidate()
            getCodeButton.enabled = true
            getCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        }
    }
    

    //下一步
    @IBAction func nextStepTapped(sender: UIButton) {
        resignAll()
        
        var code = codeTextField.text
        if code.isEmpty {
            AlertView.showMsg("验证码不能为空", parentView: self.view)
            return
        }

        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"]) as Set<NSObject>
        var url = Constant.getServerHost() + "/App-Ucenter-alertPhone"
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
        var params = ["to":token,"step":"1","cellphone":phone,"code":code,"f_id":""]
        println(params)
        loading.startLoading(self.view)
        manager.POST(url, parameters: params,
            success: { (op:AFHTTPRequestOperation!, data:AnyObject!) -> Void in
                loading.stopLoading()
                var result = data as! NSDictionary
                var resultCode = result["code"] as! Int
                if resultCode == -1 {
                    AlertView.alert("提示", message: "请登录后再使用", buttonTitle: "确定", viewController: self)
                
                } else if resultCode == 0 {
                    AlertView.alert("提示", message: "手机验证码错误", buttonTitle: "确定", viewController: self)
                    self.codeTextField.becomeFirstResponder()
                } else if resultCode == 200 {
                    self.f_id = result["data"]?["f_id"] as? String
                    self.performSegueWithIdentifier("modifyPhoneNextStepSegue", sender: self)
                }
                
            },failure: { (op:AFHTTPRequestOperation!, error:NSError!) -> Void in
                loading.stopLoading()
                AlertView.alert("提示", message: "服务器错误", buttonTitle: "确定", viewController: self)
            }
        )
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "modifyPhoneNextStepSegue" {
            
            var controller = segue.destinationViewController as! ModifyPhoneStepSecondViewController
            controller.f_id = self.f_id
        }
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        resignAll()
        return true
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        resignAll()
        
    }
    
    func resignAll(){
        codeTextField.resignFirstResponder()
    }

}
