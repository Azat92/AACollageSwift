//: Playground - noun: a place where people can play

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

func resize(images: [CGSize], toFitInWidth width: CGFloat, usingMargin margin: CGFloat = 0) -> [CGRect] {
    if images.count < 1 {
        return []
    }
    print(images.map { Container(size: $0) }.sort { $0.area > $1.area }.map { $0.size })
    let sortedTree = makeTree(images.map { Container(size: $0) }.sort { $0.area > $1.area }).fix()
    sortedTree.printme()
    return sortedTree.fit(toWidth: width).flatten().sort { $0.0.id < $1.0.id }.map { CGRectInset($1, margin / 2, margin / 2) }
}

func divide(containers: [Container]) -> ([Container], [Container]) { // partition problem
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

func makeTree(containers: [Container], divider: Divider = .Vertical) -> TreeNode {
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

print(resize([CGSizeMake(1280.0, 960.0), CGSizeMake(2560.0, 1920.0), CGSizeMake(640.0, 1136.0), CGSizeMake(960.0, 1280.0)], toFitInWidth: 320))

for i in 0 ..< 50 {
    var sizes: [CGSize] = []
    for j in 0 ..< arc4random_uniform(15) {
        sizes.append(CGSizeMake(CGFloat(1 + arc4random_uniform(499)), CGFloat(1 + arc4random_uniform(499))))
    }
    let width = CGFloat(10 + arc4random_uniform(499))
    let rects = resize(sizes, toFitInWidth: width)
    for (size, rect) in zip(sizes, rects) {
        if (size.width / size.height - rect.size.width / rect.size.height) > 0.1 {
            fatalError("wrong calculation")
        }
    }
}

