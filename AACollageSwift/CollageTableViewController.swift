//
//  CollageTableViewController.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 24.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class CollageTableViewController: UITableViewController {

    var items: [ItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        tableView.registerNib(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCellIdentifier")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let generate: [ItemModel] = (0 ..< (10 + arc4random_uniform(40))).map {
                let images = (0 ..< (1 + arc4random_uniform(6))).map { _ in UIImage(named: "\(1 + arc4random_uniform(27))")! }
                return ItemModel(withID: Int($0), title: "Item title \($0)", andImages: images)
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {
                self.items = generate
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(items.count, 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if items.count == 0, let loadingCell = tableView.dequeueReusableCellWithIdentifier("LoadingTableViewCell") {
            return loadingCell
        }
        else if let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCellIdentifier") as? ItemTableViewCell {
            cell.item = items[indexPath.row]
            return cell
        }
        fatalError()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
