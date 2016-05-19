//
//  ItemModel.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 18.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class ItemModel: NSObject {

    let id: Int
    let title: String
    let images: [UIImage]
    let cache = NSCache()
    
    func collageBackupForWidth(width: CGFloat) -> AACollageViewBackup {
        if let backup = cache.objectForKey(width) as? AACollageViewBackup {
            return backup
        }
        else {
            let update = AACollageView.precalculatedBoundsWithImageSizes(images.map { $0.size }, widthLimit: width)
            cache.setObject(update, forKey: width)
            return update
        }
    }
    
    func heightForWidth(width: CGFloat) -> CGFloat {
        return collageBackupForWidth(width).size.height + 18 + 16
    }
    
    init(withID _id: Int, title _title: String, andImages _images: [UIImage]) {
        id = _id
        title = _title
        images = _images
        super.init()
    }
    
}
