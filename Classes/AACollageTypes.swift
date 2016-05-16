//
//  Types.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 14.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class Counter {
    static private var value = 0
    class var next: Int {
        let val = Counter.value
        Counter.value += 1
        return val
    }
}

class Container {
    let id = Counter.next
    let size: CGSize
    var setupSize: CGSize!
    lazy var area: CGFloat = {
        return self.size.height * self.size.width
    }()
    
    init(size _size: CGSize) {
        size = _size
    }
}

enum Divider {
    case Vertical
    case Horizontal
}

extension Divider {
    var opposite: Divider {
        switch self {
        case .Vertical:
            return Horizontal
        case .Horizontal:
            return Vertical
        }
    }
}

class SizeContainer {
    var value: CGSize!
}

indirect enum TreeNode {
    case Item(Container)
    case Box(TreeNode, Divider, SizeContainer, TreeNode)
}
