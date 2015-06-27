//
//  CustomNavigationViewController.swift
//  盛世财富
//
//  Created by 肖典 on 15/6/27.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import Foundation
import UIKit
class CustomNavigationViewController:UIViewController,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    var contentUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url:NSURL = NSURL(string: contentUrl!)!
        var request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
        self.webView.delegate = self
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}