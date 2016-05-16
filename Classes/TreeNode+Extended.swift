//
//  AACollageExtensions.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 14.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

extension TreeNode {
    var size: CGSize {
        switch self {
        case Item(let container):
            if let size = container.setupSize {
                return size
            }
            return container.size
        case Box(let node1, let divider, let size, let node2):
            if let value = size.value {
                return value
            }
            switch divider {
            case .Vertical:
                let minHeight = min(node1.size.height, node2.size.height)
                let node1Ratio = node1.size.height / minHeight
                let node2Ratio = node2.size.height / minHeight
                node1.setupSize(CGSizeMake(node1.size.width / node1Ratio, minHeight))
                node2.setupSize(CGSizeMake(node2.size.width / node2Ratio, minHeight))
                size.value = CGSizeMake(node1.size.width + node2.size.width, minHeight)
            case .Horizontal:
                let minWidth = min(node1.size.width, node2.size.width)
                let node1Ratio = node1.size.width / minWidth
                let node2Ratio = node2.size.width / minWidth
                node1.setupSize(CGSizeMake(minWidth, node1.size.height / node1Ratio))
                node2.setupSize(CGSizeMake(minWidth, node2.size.height / node2Ratio))
                size.value = CGSizeMake(minWidth, node1.size.height + node2.size.height)
            }
            return size.value
        }
    }
    
    func setupSize(newValue: CGSize) {
        switch self {
        case Item(let container):
            container.setupSize = newValue
        case .Box(_, _, let size, _):
            size.value = newValue
        }
    }
    
    func fix() -> TreeNode {
        guard case Box(let node1, let divider, _, let node2) = self else { return self }
        switch divider {
        case .Vertical:
            let ratio = node1.size.height / node2.size.height
            if ratio > 1 {
                node1.setupSize(CGSizeMake(node1.size.width / ratio, node2.size.height))
            }
            else if ratio < 1 {
                node2.setupSize(CGSizeMake(node2.size.width * ratio, node1.size.height))
            }
            else if node1.size.width + node2.size.width > self.size.width {
                let ratio = (node1.size.width + node2.size.width) / self.size.width
                node1.setupSize(CGSizeMake(node1.size.width / ratio, node1.size.height / ratio))
                node2.setupSize(CGSizeMake(node2.size.width / ratio, node2.size.height / ratio))
            }
        case .Horizontal:
            let ratio = node1.size.width / node2.size.width
            if ratio > 1 {
                node1.setupSize(CGSizeMake(node2.size.width, node1.size.height / ratio))
            }
            else if ratio < 1 {
                node2.setupSize(CGSizeMake(node1.size.width, node2.size.height * ratio))
            }
            else if node1.size.height + node2.size.height > self.size.height {
                let ratio = (node1.size.height + node2.size.height) / self.size.height
                node1.setupSize(CGSizeMake(node1.size.width / ratio, node1.size.height / ratio))
                node2.setupSize(CGSizeMake(node2.size.width / ratio, node2.size.height / ratio))
            }
        }
        node1.fix()
        node2.fix()
        return self
    }
    
    func fit(toWidth width: CGFloat) -> TreeNode {
        let ratio = self.size.width / width
        setupSize(CGSizeMake(width, self.size.height / ratio))
        guard case Box(let node1, let divider, _, let node2) = self else { return self }
        switch divider {
        case .Horizontal:
            node1.fit(toWidth: width)
            node2.fit(toWidth: width)
        case .Vertical:
            node1.fit(toWidth: node1.size.width / ratio)
            node2.fit(toWidth: node2.size.width / ratio)
        }
        return self
    }
    
    func flatten(usingOffset offset: CGPoint = CGPointZero) -> [(Container, CGRect)] {
        switch self {
        case .Item(let container):
            return [(container, CGRectMake(offset.x, offset.y, container.setupSize.width, container.setupSize.height))]
        case .Box(let node1, let divider, _, let node2):
            let updOffset = divider == .Vertical ? CGPointMake(offset.x + node1.size.width, offset.y) : CGPointMake(offset.x, offset.y + node1.size.height)
            return node1.flatten(usingOffset: offset) + node2.flatten(usingOffset: updOffset)
        }
    }
    
    func printme(spaces: String = "") {
        switch self {
        case .Box(let node1, let divider, _, let node2):
            print("\(spaces)\(divider)Box", self.size, "{")
            node1.printme(spaces + "  ")
            node2.printme(spaces + "  ")
            print("\(spaces)}")
        case .Item(let container):
            print("\(spaces)Item", self.size, "<=", container.size)
        }
    }
}
