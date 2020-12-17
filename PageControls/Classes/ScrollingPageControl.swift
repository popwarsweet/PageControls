//
//  ScrollingPageControl.swift
//  PageControls
//
//  Created by Kyle Zaragoza on 8/8/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

@IBDesignable open class ScrollingPageControl: UIView {
    
    // MARK: - PageControl
    
    @IBInspectable open var pageCount: Int = 0 {
        didSet {
            updateNumberOfPages(pageCount)
        }
    }
    @IBInspectable open var progress: CGFloat = 0 {
        didSet {
            layoutFor(progress)
        }
    }
    open var currentPage: Int {
        return Int(round(progress))
    }
    
    
    // MARK: - Appearance
    
    @IBInspectable open var activeTint: UIColor = UIColor.white {
        didSet {
            ringLayer.borderColor = self.activeTint.cgColor
            activeLayersContainer.sublayers?.forEach() { $0.backgroundColor = activeTint.cgColor }
        }
    }
    @IBInspectable open var inactiveTint: UIColor = UIColor(white: 1, alpha: 0.3) {
        didSet {
            inactiveLayersContainer.sublayers?.forEach() { $0.backgroundColor = inactiveTint.cgColor }
        }
    }
    @IBInspectable open var indicatorPadding: CGFloat = 10 {
        didSet {
            if let sublayers = inactiveLayersContainer.sublayers {
                layoutPageIndicators(sublayers, container: inactiveLayersContainer)
            }
            if let sublayers = activeLayersContainer.sublayers {
                layoutPageIndicators(sublayers, container: activeLayersContainer)
            }
        }
    }
    @IBInspectable open var ringRadius: CGFloat = 10 {
        didSet {
            // resize view to fit ring
            self.sizeToFit()
            // adjust size
            ringLayer.cornerRadius = ringRadius
            ringLayer.frame = CGRect(origin: CGPoint.zero,
                                     size: CGSize(width: ringDiameter, height: ringDiameter))
            // layout
            center(ringLayer)
        }
    }
    @IBInspectable open var indicatorRadius: CGFloat = 5 {
        didSet {
            if let sublayers = inactiveLayersContainer.sublayers {
                layoutPageIndicators(sublayers, container: inactiveLayersContainer)
            }
            if let sublayers = activeLayersContainer.sublayers {
                layoutPageIndicators(sublayers, container: activeLayersContainer)
            }
        }
    }
    
    fileprivate var indicatorDiameter: CGFloat {
        return indicatorRadius * 2
    }
    fileprivate var ringDiameter: CGFloat {
        return ringRadius * 2
    }
    fileprivate var inactiveLayersContainer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()]
        return layer
    }()
    fileprivate var activeLayersContainer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()]
        return layer
    }()
    fileprivate lazy var ringLayer: CALayer = { [unowned self] in
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero,
                             size: CGSize(width: self.ringDiameter, height: self.ringDiameter))
        layer.backgroundColor = UIColor.clear.cgColor
        layer.cornerRadius = self.ringRadius
        layer.borderColor = self.activeTint.cgColor
        layer.borderWidth = 1
        layer.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()]
        return layer
    }()
    fileprivate lazy var inactiveLayerMask: CAShapeLayer = { [unowned self] in
        let layer = CAShapeLayer()
        layer.fillRule = CAShapeLayerFillRule.evenOdd
        layer.frame = CGRect(origin: CGPoint.zero,
                             size: CGSize(width: self.ringDiameter, height: self.ringDiameter))
        layer.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()]
        return layer
    }()
    fileprivate lazy var activeLayerMask: CAShapeLayer = { [unowned self] in
        let layer = CAShapeLayer()
        layer.frame = CGRect(origin: CGPoint.zero,
                             size: CGSize(width: self.ringDiameter, height: self.ringDiameter))
        layer.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()]
        return layer
        }()
    
    
    // MARK: - Init
    
    fileprivate func addRequiredLayers() {
        self.layer.addSublayer(inactiveLayersContainer)
        self.layer.addSublayer(activeLayersContainer)
        self.layer.addSublayer(ringLayer)
        inactiveLayersContainer.mask = inactiveLayerMask
        activeLayersContainer.mask = activeLayerMask
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addRequiredLayers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addRequiredLayers()
    }
    
    
    // MARK: - State Update
    
    fileprivate func updateNumberOfPages(_ count: Int) {
        // no need to update
        guard count != inactiveLayersContainer.sublayers?.count else { return }
        // reset current layout
        inactiveLayersContainer.sublayers?.forEach() { $0.removeFromSuperlayer() }
        activeLayersContainer.sublayers?.forEach() { $0.removeFromSuperlayer() }
        // add layers for new page count
        var inactivePageIndicatorLayers = [CALayer]()
        var activePageIndicatorLayers = [CALayer]()
        for _ in 0..<count {
            // add inactve layers
            let inactiveLayer = pageIndicatorLayer(self.inactiveTint.cgColor)
            inactiveLayersContainer.addSublayer(inactiveLayer)
            inactivePageIndicatorLayers.append(inactiveLayer)
            // add actve layers
            let activeLayer = pageIndicatorLayer(self.activeTint.cgColor)
            activeLayersContainer.addSublayer(activeLayer)
            activePageIndicatorLayers.append(activeLayer)
        }
        layoutPageIndicators(inactivePageIndicatorLayers, container: inactiveLayersContainer)
        layoutPageIndicators(activePageIndicatorLayers, container: activeLayersContainer)
        center(ringLayer)
        self.invalidateIntrinsicContentSize()
    }
    
    fileprivate func pageIndicatorLayer(_ color: CGColor) -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = color
        return layer
    }
    
    
    // MARK: - Layout
    
    fileprivate func maskPath(_ size: CGSize, progress: CGFloat, inverted: Bool) -> CGPath {
        let offsetFromCenter = progress * (indicatorDiameter + indicatorPadding) - (ringRadius - indicatorRadius)
        let circleRect = CGRect(
            x: offsetFromCenter,
            y: 0,
            width: size.height,
            height: size.height)
        let circlePath = UIBezierPath(roundedRect: circleRect, cornerRadius: size.height/2)
        if inverted {
            let path = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
            path.append(circlePath)
            return path.cgPath
        } else {
            return circlePath.cgPath
        }
    }
    
    fileprivate func layoutFor(_ progress: CGFloat) {
        // ignore if progress is outside of page indicators' bounds
        guard progress >= 0 && progress <= CGFloat(pageCount - 1) else { return }
        let offsetFromCenter = progress * (indicatorDiameter + indicatorPadding)
        let containerOffset = self.bounds.size.width/2 - indicatorRadius - offsetFromCenter
        inactiveLayersContainer.frame.origin.x = containerOffset
        activeLayersContainer.frame.origin.x = containerOffset
        inactiveLayerMask.path = maskPath(inactiveLayerMask.bounds.size, progress: progress, inverted: true)
        activeLayerMask.path = maskPath(activeLayerMask.bounds.size, progress: progress, inverted: false)
    }
    
    fileprivate func center(_ layer: CALayer) {
        let frame = CGRect(
            x: (self.bounds.width - layer.bounds.width)/2,
            y: (self.bounds.height - layer.bounds.height)/2,
            width: layer.bounds.width,
            height: layer.bounds.width)
        layer.frame = frame
    }
    
    fileprivate func layoutPageIndicators(_ layers: [CALayer], container: CALayer) {
        let layerDiameter = indicatorRadius * 2
        var layerFrame = CGRect(
            x: 0,
            y: (ringDiameter - indicatorDiameter)/2,
            width: layerDiameter,
            height: layerDiameter)
        layers.forEach() { layer in
            layer.cornerRadius = self.indicatorRadius
            layer.frame = layerFrame
            layerFrame.origin.x += layerDiameter + indicatorPadding
        }
        layerFrame.origin.x -= indicatorPadding
        container.frame = CGRect(x: 0, y: 0, width: layerFrame.origin.x, height: ringLayer.bounds.height)
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        let pageCountWidth = pageCount + (pageCount - 1)
        return CGSize(width: CGFloat(pageCountWidth) * indicatorDiameter + CGFloat(pageCountWidth - 1) * indicatorPadding,
                      height: ringDiameter)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        // layout containers
        inactiveLayersContainer.frame = self.bounds
        inactiveLayerMask.frame = self.bounds
        activeLayersContainer.frame = self.bounds
        activeLayerMask.frame = self.bounds
        // layout indicators
        if let layers = inactiveLayersContainer.sublayers {
            layoutPageIndicators(layers, container: inactiveLayersContainer)
        }
        if let layers = activeLayersContainer.sublayers {
            layoutPageIndicators(layers, container: activeLayersContainer)
        }
        // update ring
        center(ringLayer)
        layoutFor(progress)
    }
}
