//
//  AutoHeightTableViewController.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 18.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class AutoHeightTableViewController: CollageTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

}
