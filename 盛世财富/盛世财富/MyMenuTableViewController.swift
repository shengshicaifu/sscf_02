//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController{
    var selectedMenuItem : Int = 0
    var str: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 1
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL\(indexPath.section)") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL\(indexPath.section)")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        var f = UIFont.systemFontOfSize(18)
        var head = UILabel(frame: CGRect(x: 0, y: 10, width: 320, height: 20))
        head.textAlignment = NSTextAlignment.Center
        head.font = f
        
        var choice = UISegmentedControl(frame: CGRect(x: 10, y: 40, width: 300, height: 30))
        
        
        
        switch indexPath.section {
        case 0:										
            head.text = "借款状态"
            choice.insertSegmentWithTitle("不限", atIndex: 0, animated: true)
            choice.insertSegmentWithTitle("所有", atIndex: 1, animated: true)
            choice.insertSegmentWithTitle("招标中", atIndex: 2, animated: true)
            choice.insertSegmentWithTitle("已成功", atIndex: 3, animated: true)
            choice.insertSegmentWithTitle("已完成", atIndex: 4, animated: true)
            
        case 1:
            head.text = "借款金额"
            choice.insertSegmentWithTitle("不限", atIndex: 0, animated: true)
            choice.insertSegmentWithTitle("<10万", atIndex: 1, animated: true)
            choice.insertSegmentWithTitle("50-200", atIndex: 2, animated: true)
            choice.insertSegmentWithTitle("200-1000", atIndex: 3, animated: true)
            choice.insertSegmentWithTitle(">1000万", atIndex: 4, animated: true)
        case 2:
            head.text = "借款期限"
            choice.insertSegmentWithTitle("不限", atIndex: 0, animated: true)
            choice.insertSegmentWithTitle("<1月", atIndex: 1, animated: true)
            choice.insertSegmentWithTitle("1-3月", atIndex: 2, animated: true)
            choice.insertSegmentWithTitle("4-6月", atIndex: 3, animated: true)
            choice.insertSegmentWithTitle("7-12月", atIndex: 4, animated: true)
        
        default:
            head.text = "错误"
        }
        choice.selectedSegmentIndex = 0
        cell?.addSubview(head)
        cell?.addSubview(choice)

        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        if (indexPath.row == selectedMenuItem) {
//            return
//        }
//        selectedMenuItem = indexPath.row
//        
//        //Present new view controller
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
//        var destViewController : UIViewController
//        switch (indexPath.row) {
//        case 0:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
//            //传递参数判断是否看过,0: 未看过,1: 看过
//            destViewController.setValue("0", forKey: "isCheck")
//            break
//        case 1:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController2") as UIViewController
//            destViewController.setValue("1", forKey: "isCheck")
//            break
//        case 2:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController3") as UIViewController
//            destViewController.setValue("0", forKey: "isCheck")
//            break
//        case 3:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4") as UIViewController
//            destViewController.setValue("1", forKey: "isCheck")
//            break
//        default:
//            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
//            destViewController.setValue("0", forKey: "isCheck")
//            break
//        }
//        
//        sideMenuController()?.setContentViewController(destViewController)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
