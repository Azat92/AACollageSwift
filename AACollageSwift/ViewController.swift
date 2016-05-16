//
//  ViewController.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 14.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addImages()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.addImages(fitWidth: size.width)
    }
    
    func addImages(fitWidth width: CGFloat? = nil) {
        view.subviews.forEach { $0.removeFromSuperview() }
        let images = [UIImage(named: "1.jpg")!, UIImage(named: "2.jpg")!, UIImage(named: "3.jpg")!, UIImage(named: "4.png")!, UIImage(named: "5.jpg")!, UIImage(named: "6.png")!, UIImage(named: "7.jpg")!, UIImage(named: "8.jpg")!, UIImage(named: "9.png")!]
        var height = CGFloat(0)
        for (idx, rect) in AACollageMaker.makeCollageForImageSizes(images.map { $0.size }, toFitInWidth: width ?? view.bounds.size.width, resultHeight: &height, usingMargin: 1)().enumerate() {
            let imageView = UIImageView(frame: CGRectMake(rect.origin.x, rect.origin.y + 20, rect.size.width, rect.size.height))
            imageView.image = images[idx]
            imageView.contentMode = .ScaleAspectFit
            view.addSubview(imageView)
        }
    }



}

