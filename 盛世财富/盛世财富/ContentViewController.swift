//
//  ContentViewController.swift
//  盛世财富
//  文章
//  Created by 云笺 on 15/5/19.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var contentUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //var url = nsur
        //NSURLRequest(URL: nsurl(NSString)
        println(contentUrl)
        var url:NSURL = NSURL(string: contentUrl!)!
        var request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
        self.webView.delegate = self
    }
    
    //MARK:- UIWebViewDelegate
    
}
