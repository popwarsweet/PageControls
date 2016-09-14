//
//  SnakePageControl.swift
//  PageControls
//
//  Created by Kyle Zaragoza on 8/5/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

@IBDesignable open class SnakePageControl: UIView {
    
    // MARK: - PageControl
    
    @IBInspectable open var pageCount: Int = 0 {
        didSet {
            updateNumberOfPages(pageCount)
        }
    }
    @IBInspectable open var progress: CGFloat = 0 {
        didSet {
            layoutActivePageIndicator(progress)
        }
    }
    open var currentPage: Int {
        return Int(round(progress))
    }
    
    
    // MARK: - Appearance
    
    @IBInspectable open var activeTint: UIColor = UIColor.white {
        didSet {
            activeLayer.backgroundColor = activeTint.cgColor
        }
    }
    @IBInspectable open var inactiveTint: UIColor = UIColor(white: 1, alpha: 0.3) {
        didSet {
            inactiveLayers.forEach() { $0.backgroundColor = inactiveTint.cgColor }
        }
    }
    @IBInspectable open var indicatorPadding: CGFloat = 10 {
        didSet {
            layoutInactivePageIndicators(inactiveLayers)
        }
    }
    @IBInspectable open var indicatorRadius: CGFloat = 5 {
        didSet {
            layoutInactivePageIndicators(inactiveLayers)
        }
    }
    
    fileprivate var indicatorDiameter: CGFloat {
        return indicatorRadius * 2
    }
    fileprivate var inactiveLayers = [CALayer]()
    fileprivate lazy var activeLayer: CALayer = { [unowned self] in
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero,
                             size: CGSize(width: self.indicatorDiameter, height: self.indicatorDiameter))
        layer.backgroundColor = self.activeTint.cgColor
        layer.cornerRadius = self.indicatorRadius
        layer.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()]
        return layer
        }()
    
    
    // MARK: - State Update
    
    fileprivate func updateNumberOfPages(_ count: Int) {
        // no need to update
        guard count != inactiveLayers.count else { return }
        // reset current layout
        inactiveLayers.forEach() { $0.removeFromSuperlayer() }
        inactiveLayers = [CALayer]()
        // add layers for new page count
        inactiveLayers = stride(from: 0, to:count, by:1).map() { _ in
            let layer = CALayer()
            layer.backgroundColor = self.inactiveTint.cgColor
            self.layer.addSublayer(layer)
            return layer
        }
        layoutInactivePageIndicators(inactiveLayers)
        // ensure active page indicator is on top
        self.layer.addSublayer(activeLayer)
        layoutActivePageIndicator(progress)
        self.invalidateIntrinsicContentSize()
    }
    
    
    // MARK: - Layout
    
    fileprivate func layoutActivePageIndicator(_ progress: CGFloat) {
        // ignore if progress is outside of page indicators' bounds
        guard progress >= 0 && progress <= CGFloat(pageCount - 1) else { return }
        let denormalizedProgress = progress * (indicatorDiameter + indicatorPadding)
        let distanceFromPage = abs(round(progress) - progress)
        var newFrame = activeLayer.frame
        let widthMultiplier = (1 + distanceFromPage*2)
        newFrame.origin.x = denormalizedProgress
        newFrame.size.width = newFrame.height * widthMultiplier
        activeLayer.frame = newFrame
    }
    
    fileprivate func layoutInactivePageIndicators(_ layers: [CALayer]) {
        let layerDiameter = indicatorRadius * 2
        var layerFrame = CGRect(x: 0, y: 0, width: layerDiameter, height: layerDiameter)
        layers.forEach() { layer in
            layer.cornerRadius = self.indicatorRadius
            layer.frame = layerFrame
            layerFrame.origin.x += layerDiameter + indicatorPadding
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactiveLayers.count) * indicatorDiameter + CGFloat(inactiveLayers.count - 1) * indicatorPadding,
                      height: indicatorDiameter)
    }
}
