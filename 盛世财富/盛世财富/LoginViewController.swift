//
//  TransRecordViewController.swift
//  盛世财富
//
//  Created by zengchang on 15-3-17.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    var menu:REMenu!
    var count:Int = 0
    @IBAction func listTapped(sender: AnyObject) {
        count++
        
        var homeItme1:REMenuItem = REMenuItem(title: "Home1",subtitle:"Return to Home Screen1",image:UIImage(named: "11.jpg"),highlightedImage:nil){
            println($0.title)
            self.count++
        }
        var homeItme2:REMenuItem = REMenuItem(title: "Home2",subtitle:"Return to Home Screen2",image:UIImage(named: "21.jpg"),highlightedImage:nil){
            println($0.title)
            self.count++
        }
        var homeItme3:REMenuItem = REMenuItem(title: "Home3",subtitle:"Return to Home Screen3",image:UIImage(named: "31.jpg"),highlightedImage:nil){
            println($0.title)
            self.count++
        }
        
        if count%2 == 0{
            menu.close()
        }else{
            if menu == nil {
                self.menu = REMenu(items: [homeItme1,homeItme2,homeItme3])
            }
            self.menu.showFromNavigationController(self.navigationController)
        }
    }
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBAction func loginTapped(sender: AnyObject) {
        self.count++
        var manager = AFHTTPRequestOperationManager()
        var url = "http://192.168.1.25:8080/people/CheckLoginServlet"
        var params:NSDictionary! = ["username":usernameLabel.text,"password":passwordLabel.text]
//        if usernameLabel.text == "admin" && passwordLabel.text == "admin"  {
//            var adv = self.storyboard?.instantiateViewControllerWithIdentifier("personCenterViewController") as PersonCenterViewController
//            self.presentViewController(adv, animated: true, completion: nil)
//        }
//        var url = "http://www.sscf88.com/app-invest-content"
//        var params:NSDictionary! = nil
        self.performSegueWithIdentifier("loginIdentifier", sender: self)
       manager.GET(url, parameters: params,
            success:{
                (operation:
                AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //打印json数据
               //println("responseObject: \(responseObject!) ")
                
                //解析json数据是List集合类型
                // var json:[AnyObject] = responseObject as [AnyObject]
                var json:NSDictionary = responseObject as NSDictionary
                
                var result:Bool = json["result"] as Bool
                if result {
                    self.performSegueWithIdentifier("loginIdentifier", sender: self)
                }else{
                    //弹窗
                    var alert = UIAlertController(title: "提示", message: "您输入的密码或者账号有误！", preferredStyle:UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } ,
            failure:{
                (operation:AFHTTPRequestOperation!,error:NSError!) in
                //打印错误信息
                println("error:"+error.localizedDescription)
        } )
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //传递数据过去
        if segue.identifier == "loginIdentifier" {
            
        }
    }
    
//    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        
//    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.count++
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        return true
    }
}