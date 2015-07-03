//
//  ChooseBankTableViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/7/2.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  选择银行卡
*/
class ChooseBankTableViewController: UITableViewController,UITableViewDataSource,UITableViewDelegate {
    
    var bankArray:NSMutableArray!//银行
    var choosedBankId = "0"//选中的行
    var viewController:OffLineChargeViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        var path = NSBundle.mainBundle().pathForResource("bankList", ofType: "plist")
        
        bankArray = NSMutableArray(contentsOfFile: path!)
        
        //NSLog("bankArray = %@", bankArray)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bankCell", forIndexPath: indexPath) as! UITableViewCell
        
        var img = cell.viewWithTag(1) as! UIImageView
        var bankName = cell.viewWithTag(2) as! UILabel
        
        var row = indexPath.row
        var bankDict = self.bankArray[row] as! NSDictionary
        
        bankName.text = bankDict["bankName"] as? String

        var path1 = NSBundle.mainBundle().pathForResource("bankImage", ofType: "bundle")
        var imagePath = path1?.stringByAppendingPathComponent(NSString(format: "logo/%@.png", bankDict["bankId"] as! String) as String)
        
        img.image = UIImage(contentsOfFile: imagePath!)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if self.choosedBankId == bankDict["bankId"] as! String {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var bankDict = self.bankArray[indexPath.row] as! NSDictionary
        self.choosedBankId = bankDict["bankId"] as! String
        
        self.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
        viewController.choosedBankId = self.choosedBankId
        viewController.choosedBankCode = bankDict["bankCode"] as! String
        viewController.choosedBankName = bankDict["bankName"] as! String
    }
    
    
}
