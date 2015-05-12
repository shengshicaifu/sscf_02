//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,HttpProtocol {
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var regist: UIButton!
    var timeLineUrl = "http://www.sscf88.com/App-Login"//链接地址
    var tmpListData: NSMutableArray = NSMutableArray()//临时数据  下拉添加
    var eHttp: HttpController = HttpController()//新建一个httpController
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.delegate = self
        passwordLabel.delegate = self
        login.layer.cornerRadius = 5
        regist.layer.cornerRadius = 5
        regist.layer.borderColor = UIColor.grayColor().CGColor
        regist.layer.borderWidth = 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//    var menu:REMenu!
//    var count:Int = 0
//    @IBAction func listTapped(sender: AnyObject) {
//        count++
//        
//        var homeItme1:REMenuItem = REMenuItem(title: "sss",subtitle:"Return to Home Screen1",image:UIImage(named: "11.jpg"),highlightedImage:nil){
//            println($0.title)
//            self.count++
//        }
//        var homeItme2:REMenuItem = REMenuItem(title: "Home2",subtitle:"Return to Home Screen2",image:UIImage(named: "21.jpg"),highlightedImage:nil){
//            println($0.title)
//            self.count++
//        }
//        var homeItme3:REMenuItem = REMenuItem(title: "Home3",subtitle:"Return to Home Screen3",image:UIImage(named: "31.jpg"),highlightedImage:nil){
//            println($0.title)
//            self.count++
//        }
//        
//        if count%2 == 0{
//            menu.close()
//        }else{
//            if menu == nil {
//                self.menu = REMenu(items: [homeItme1,homeItme2,homeItme3])
//            }
//            self.menu.showFromNavigationController(self.navigationController)
//        }
//    }
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBAction func loginTapped(sender: AnyObject) {
//        self.count++
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        //http://www.sscf88.com/App-Login
        
        if let name:NSString = usernameLabel.text{
            if name.length > 0 && name.length <= 20{
                if let pwd:NSString = passwordLabel.text{
                    if pwd.length > 0 && pwd.length <= 20{
                        eHttp.post(timeLineUrl, params: ["userName":usernameLabel.text,"userPass":passwordLabel.text,"userFlag":0] ,view: self.view ) { (result:NSDictionary)->Void in
                            //            println(result["message"])
                            if let code = result["code"] as? Int{
                                
                                println(result)
                                if(code == 200){
                                    var user = NSUserDefaults.standardUserDefaults()
                                    user.setObject(self.usernameLabel.text, forKey: "username")
                                    user.setObject(result["data"]?["userPass"], forKey: "userpass")
                                    user.setObject(result["data"]?["userPic"], forKey: "userpic")
                                    user.setObject("1",forKey: "usermoney")
                                    println(user.objectForKey("usermoney"))
//                                    user.setObject(result["data"]?["proInfo"]?["total_all"], forKey: "usermoney")
                                    //                    println(user.valueForKey("userpass"))
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                    //                    self.performSegueWithIdentifier("loginIdentifier", sender: self)
                                }
                                if(code == 0){
                                    //报错弹窗
                                    AlertView.showMsg(result["message"] as! String, parentView: self.view)
                                    
                                    //                    var alert = UIAlertController(title: "错误", message: result["message"] as? String, preferredStyle:UIAlertControllerStyle.Alert)
                                    //                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                                    //
                                    //                    self.presentViewController(alert, animated: true, completion: nil)
                                    
                                }
                            }else{
                                AlertView.showMsg("服务器异常，请完全退出程序后重试！", parentView: self.view)
                                //                var alert = UIAlertController(title: "错误", message: "服务器异常，请完全退出程序后重试！", preferredStyle:UIAlertControllerStyle.Alert)
                                //                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                                //                
                                //                self.presentViewController(alert, animated: true, completion: nil)
                            }
                            
                            
                        }

                    }else{
                        AlertView.showMsg("密码格式不对！", parentView: self.view)
                    }
                }else{
                    AlertView.showMsg("请填写密码！", parentView: self.view)
                }
            }else{
                AlertView.showMsg("用户名格式不对！", parentView: self.view)
            }
        }else{
            AlertView.showMsg("请填写用户名！", parentView: self.view)
        }
        
        
        
        
//        var manager = AFHTTPRequestOperationManager()
//        var url = "http://192.168.1.25:8080/people/CheckLoginServlet"
//        var params:NSDictionary! = ["username":usernameLabel.text,"password":passwordLabel.text]
//       var url = "http://www.sscf88.com/app-invest-content"
//       var params:NSDictionary! = nil
//        self.performSegueWithIdentifier("loginIdentifier", sender: self)
//        manager.GET(url, parameters: params,
//            success:{
//                (operation:
//                AFHTTPRequestOperation!,
//                responseObject: AnyObject!) in
//                //打印json数据
//                //println("responseObject: \(responseObject!) ")
//                
//                //解析json数据是List集合类型
//                // var json:[AnyObject] = responseObject as [AnyObject]
//                var json:NSDictionary = responseObject as NSDictionary
//                
//                var result:Bool = json["result"] as Bool
//                if result {
//                    self.performSegueWithIdentifier("loginIdentifier", sender: self)
//                }else{
//                    //弹窗
//                    var alert = UIAlertController(title: "提示", message: "您输入的密码或者账号有误！", preferredStyle:UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }
//            } ,
//            failure:{
//                (operation:AFHTTPRequestOperation!,error:NSError!) in
//                //打印错误信息
//                println("error:"+error.localizedDescription)
//        } )

        
    }
    //读取json并解析
    func didRecieveResult(result: NSDictionary){
//        if(result["data"]?.valueForKey("list") != nil){
//            self.tmpListData = result["data"]?.valueForKey("list") as NSMutableArray //list数据
//            //            self.page = result["data"]?["page"] as Int
////            self.mainTable.reloadData()
//        }

       
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //传递数据过去
        if segue.identifier == "loginIdentifier" {
            
        }
    }
    @IBAction func returnKey(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        
//    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.count++
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        return true
    }
}