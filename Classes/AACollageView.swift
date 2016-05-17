//
//  AACollageView.swift
//  AACollageSwift
//
//  Created by Azat Almeev on 17.05.16.
//  Copyright © 2016 Azat Almeev. All rights reserved.
//

import UIKit

class AACollageView: UIView {
    
    var images: [UIImage]?
    var margin: CGFloat = 0
    
    override var frame: CGRect {
        didSet {
            size = frame.size
            refreshCollage()
        }
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
            var height = size.height
            _calculator = AACollageMaker.makeCollageForImageSizes(img.map { $0.size }, toFitInWidth: size.width, resultHeight: &height)
            _size = CGSizeMake(size.width, height)
        }
    }
}
