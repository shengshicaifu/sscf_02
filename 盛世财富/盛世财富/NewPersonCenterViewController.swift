//
//  NewPersonCenterViewController.swift
//  盛世财富
//  我的账号
//  Created by 肖典 on 15/5/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class NewPersonCenterViewController:UITableViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var head: UIImageView!
    @IBOutlet weak var money: UILabel!

    var ehttp = HttpController()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        
//        self.run(NSDictionary())
        
//        手动添加蓝色大方块
//        var img = UIImageView(image: UIImage(named: "蓝色"))
//        img.frame.size.height = 300
//        img.frame.size.width = self.view.frame.width
//        var myFinance = UILabel(frame: CGRect(x: (img.frame.width - 80)/2, y: img.frame.midY - 80, width: 80, height: 20))
//        myFinance.text = "我的资产"
//        var myMoney = UILabel(frame: CGRect(x: 0, y: myFinance.frame.maxY+10, width: self.view.frame.width, height: 60))
//        myMoney.text = "8888.88"
//        myMoney.font = UIFont(name: "Helvetica", size: 50)
//        myMoney.textAlignment = NSTextAlignment.Center
//        img.addSubview(myFinance)
//        img.addSubview(myMoney)
//        mainTable.tableHeaderView = img
//        
        
    }
    
    func refreshData(){
        var user = NSUserDefaults.standardUserDefaults()
        if let username:NSString = user.objectForKey("username") as? NSString {
            self.navigationItem.title = username
        }else {
            self.navigationItem.title = "请登录"
        }
        if let usermoney:NSString = user.objectForKey("usermoney") as? NSString {
            self.money.text = usermoney
        }else {
            self.money.text = "- -"
        }
        if let headImage:NSData = user.objectForKey("headImage") as? NSData {
            self.head.image = UIImage(data: headImage)
        }else if let userpic:NSString = user.objectForKey("userpic") as? NSString {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let image = NSData(contentsOfURL: NSURL(string: userpic)!)
                self.head.image = UIImage(data: image!)
                user.setObject(image, forKey: "headImage")
                //这里写需要大量时间的代码
                println("这里写需要大量时间的代码")
                
                dispatch_async(dispatch_get_main_queue(), {
                    //这里返回主线程，写需要主线程执行的代码
                    println("这里返回主线程，写需要主线程执行的代码")
                })
               
            })
            let thread = NSThread(target: self, selector: "getHead:", object: userpic)
            thread.start()
        }else {
            //放默认头像
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    
    func getHead(sender:String){
        
        
        
    }
    
    //section的header高度
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        if section == 1{
            return 10
        }
        if section == 2{
            return 10
        }
        return 10
    }
    
    override func viewWillAppear(animated: Bool) {
//        检查网络
        var reach = Reachability(hostName: Constant().ServerHost)
        reach.unreachableBlock = {(r:Reachability!)in
            dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(title: "提示", message: "网络连接有问题，请检查手机网络", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        reach.startNotifier()
        
        refreshData()
    }
    
}