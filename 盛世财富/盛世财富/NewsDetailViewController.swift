//
//  NewsDetailViewController.swift
//  盛世财富
//
//  Created by 云笺 on 15/6/6.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    var  detailItem :NSDictionary?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newLabel: UITextView!
    @IBOutlet weak var sendTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //println(detailItem)
        titleLabel.text = detailItem?.valueForKey("title") as? String
        newLabel.text = detailItem?.valueForKey("msg") as! String
        var sendTime = detailItem?.objectForKey("send_time") as! NSString
        var sendTimeDouble = sendTime.doubleValue
        var fomartTime = Common.dateFromTimestamp(sendTimeDouble)
        sendTimeLabel.text = fomartTime

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
