//
//  AACollageMaker.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 14.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class AACollageMaker: NSObject {
    
    class func makeCollageForImageSizes(sizes: [CGSize], toFitInWidth width: CGFloat, inout resultHeight height: CGFloat) -> CGFloat -> [CGRect] {
        let imageTree = makeTree(sizes.map { Container(size: $0) }.sort { $0.area > $1.area })
        height = imageTree.size.height / imageTree.size.width * width
        return { margin in
            return imageTree.fix().fit(toWidth: width).flatten().sort { $0.0.id < $1.0.id }.map { CGRectInset($1, margin / 2, margin / 2) }
        }
    }
    
    class func divide(containers: [Container]) -> ([Container], [Container]) { // partition problem
        let sum = { (containers: [Container]) -> CGFloat in
            containers.reduce(0) { $0 + $1.area }
        }
        var leftBucket: [Container] = []
        var rightBucket: [Container] = []
        for item in containers {
            if sum(leftBucket) < sum(rightBucket) {
                leftBucket.append(item)
            }
            else {
                rightBucket.append(item)
            }
        }
        return (leftBucket, rightBucket)
    }
    
    class func makeTree(containers: [Container], divider: Divider = .Vertical) -> TreeNode {
        if containers.count < 1 {
            fatalError("Containers count should be > 0")
        }
        else if containers.count == 1, let first = containers.first {
            return .Item(first)
        }
        else {
            let parts = divide(containers)
            return .Box(makeTree(parts.0, divider: divider.opposite), divider, SizeContainer(), makeTree(parts.1, divider: divider.opposite))
        }
    }
}

//for i in 0 ..< 50 {
//    var sizes: [CGSize] = []
//    for j in 0 ..< arc4random_uniform(15) {
//        sizes.append(CGSizeMake(CGFloat(1 + arc4random_uniform(499)), CGFloat(1 + arc4random_uniform(499))))
//    }
//    let width = CGFloat(10 + arc4random_uniform(499))
//    let rects = resize(sizes, toFitInWidth: width)
//    for (size, rect) in zip(sizes, rects) {
//        if (size.width / size.height - rect.size.width / rect.size.height) > 0.1 {
//            fatalError("wrong calculation")
//        }
//    }
//}
