//
//  MoreViewController.swift
//  盛世财富
//
//  Created by xiao on 15-3-24.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//



import UIKit

class MoreViewController: UITableViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var mainTable: UITableView!
    
   
    override func viewDidLoad() {

        super.viewDidLoad()
        mainTable.delegate = self
        self.mainTable.rowHeight = 44.0
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 54/255.0, green: 169/255.0, blue: 245/255.0, alpha: 1)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.mainTable.frame.width, height: 175))
        let image = UIImage(named: "1.jpg")
        imageView.image = image
        self.mainTable.tableHeaderView?.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func call(sender: AnyObject) {
//        println(1)
        var alert = UIAlertController(title: "提示", message: "是否拨打客服电话？", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "拨打", style: UIAlertActionStyle.Destructive, handler: { (action:UIAlertAction!) -> Void in
            var url1 = NSURL(string: "tel://4008573088")
            UIApplication.sharedApplication().openURL(url1!)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 10
    }
}

