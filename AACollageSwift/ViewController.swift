//
//  ViewController.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 14.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collage: AACollageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collage.images = [UIImage(named: "1.jpg")!, UIImage(named: "2.jpg")!, UIImage(named: "3.jpg")!, UIImage(named: "4.png")!, UIImage(named: "5.jpg")!, UIImage(named: "6.png")!, UIImage(named: "7.jpg")!, UIImage(named: "8.jpg")!, UIImage(named: "9.png")!]
        collage.margin = 2
    }
}

