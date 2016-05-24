//
//  ManualHeightTableViewController.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 18.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class ManualHeightTableViewController: CollageTableViewController {

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if items.count == 0 {
            return 44
        }
        else {
            let model = items[indexPath.row]
            return model.heightForWidth(tableView.frame.size.width)
        }
    }
    
}
