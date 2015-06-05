//
//  FindResultsViewController.swift
//  盛世财富
//
//  Created by 莫文琼 on 15/6/4.
//  Copyright (c) 2015年 sscf88. All rights reserved.
//

import UIKit
/**
*  搜索结果
*/
private let longNameSize = 6
private let shortNamesButtonIndex = 1
private let longNamesButtonIndex = 2

class FindResultsViewController: UITableViewController,UISearchResultsUpdating{

    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names:[String: [String]] = [String: [String]]()
    var keys: [String] = []
    var filteredNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
    }

    func updateSearchResultsForSearchController(searchController: UISearchController){
            let searchString = searchController.searchBar.text//搜索内容
            let buttonIndex = searchController.searchBar.selectedScopeButtonIndex//选中的按钮
            filteredNames.removeAll(keepCapacity: true)
            if !searchString.isEmpty {
                //自定义的过滤方法
                let filter: String -> Bool = { name in
                    // Filter out long or short names depending on which
                    // scope button is selected.
                    let nameLength = count(name)
                    if (buttonIndex == shortNamesButtonIndex
                    && nameLength >= longNameSize)
                    || (buttonIndex == longNamesButtonIndex
                    && nameLength < longNameSize) {
                        return false
                    }
                    let range = name.rangeOfString(searchString,
                    options: NSStringCompareOptions.CaseInsensitiveSearch)
                    return range != nil
                }
                for key in keys {
                    let namesForKey = names[key]!
                    let matches = namesForKey.filter(filter)
                    filteredNames += matches
                }
            }
            tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier) as! UITableViewCell
        cell.textLabel?.text = filteredNames[indexPath.row]
        return cell
    }


}
