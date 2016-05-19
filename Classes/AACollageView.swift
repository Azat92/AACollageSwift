//
//  AACollageView.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 17.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class AACollageViewBackup: NSObject {
    
    let size: CGSize
    let calculator: CGFloat -> [CGRect]
    
    init(withSize _size: CGSize, andCalculator _calculator: CGFloat -> [CGRect]) {
        size = _size
        calculator = _calculator
        super.init()
    }
}

class AACollageView: UIView {
    
    var images: [UIImage]? {
        didSet {
            recalculate(withSize: size)
        }
    }
    var margin: CGFloat = 0 {
        didSet {
            _frames = nil
        }
    }
    
    override var frame: CGRect {
        didSet {
            size = frame.size
            refreshCollage()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return self.size
    }
    
    var size: CGSize {
        get {
            return _size ?? CGSizeZero
        }
        set {
            recalculate(withSize: newValue)
        }
    }
    
    var frames: [CGRect] {
        if let rects = _frames {
            return rects
        }
        guard let calc = _calculator else { return [] }
        _frames = calc(margin)
        return _frames!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        size = frame.size
        refreshCollage()
    }
    
    class func collageBoundsWithImageSizes(sizes: [CGSize], widthLimit width: CGFloat) -> CGSize {
        return AACollageView.precalculatedBoundsWithImageSizes(sizes, widthLimit: width).size
    }
    
    class func precalculatedBoundsWithImageSizes(sizes: [CGSize], widthLimit width: CGFloat) -> AACollageViewBackup {
        var height: CGFloat = 0
        let calculator = AACollageMaker.makeCollageForImageSizes(sizes, toFitInWidth: width, resultHeight: &height)
        return AACollageViewBackup(withSize: CGSizeMake(width, height), andCalculator: calculator)
    }
    
    func restoreUsingBackup(backup: AACollageViewBackup) {
        _calculator = backup.calculator
        _size = backup.size
        _frames = nil
        invalidateIntrinsicContentSize()
    }
    
    func refreshCollage() {
        subviews.forEach { $0.removeFromSuperview() }
        for (idx, rect) in frames.enumerate() {
            let imgView = UIImageView()
            imgView.image = images?[idx]
            imgView.frame = rect
            addSubview(imgView)
        }
    }
    
    // cache
    private var _calculator: (CGFloat -> [CGRect])?
    private var _frames: [CGRect]?
    private var _size: CGSize?
    
    private func recalculate(withSize size: CGSize) {
        _calculator = nil
        _frames = nil
        _size = nil
        if let img = images {
            let backup = AACollageView.precalculatedBoundsWithImageSizes(img.map { $0.size }, widthLimit: size.width)
            _calculator = backup.calculator
            _size = backup.size
        }
        invalidateIntrinsicContentSize()
    }
}
