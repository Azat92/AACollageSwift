//
//  ManualHeightTableViewCell.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 18.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class ManualHeightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var collageView: AACollageView!
    
    var item: ItemModel! {
        didSet {
            titleTextLabel.text = item.title
            collageView.images = item.images
            collageView.margin = 2
            collageView.restoreUsingBackup(item.collageBackupForWidth(self.frame.size.width))
            collageView.refreshCollage()
        }
    }

}
