//
//  LoadingTableViewCell.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 18.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicator.startAnimating()
    }
    
}
