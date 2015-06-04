//
//  FindViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/4.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  发现
*  搜索功能
*/
class FindViewController: UIViewController {
    let sectionsTableIdentifier = "SectionsTableIndentifier"
    var names: [String: [String]]!
    var keys: [String]!
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
        
        let path = NSBundle.mainBundle().pathForResource("sortednames", ofType: "plist")
        let nameDict = NSDictionary(contentsOfFile: path!)
        names = nameDict as! [String: [String]]
        keys = sorted(nameDict?.allKeys as! [String])
        
        let resultsController = FindResultsViewController()
        resultsController.names = names
        resultsController.keys = keys
        searchController = UISearchController(searchResultsController: resultsController)
        
        let searchBar = searchController.searchBar
        searchBar.scopeButtonTitles = ["All", "Short", "Long"]
        searchBar.placeholder = "Enter a search term"
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        searchController.searchResultsUpdater = resultsController
        
        
    }

}
