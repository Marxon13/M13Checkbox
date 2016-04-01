//
//  M13CheckboxFillManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/30/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class M13CheckboxFillManager: M13CheckboxManager {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    override var tintColor: UIColor {
        didSet {
            selectedBoxLayer.strokeColor = tintColor.CGColor
            selectedBoxLayer.fillColor = tintColor.CGColor
        }
    }
    
    override var secondaryTintColor: UIColor? {
        didSet {
            unselectedBoxLayer.strokeColor = secondaryTintColor?.CGColor
        }
    }
    
    override var secondaryCheckmarkTintColor: UIColor? {
        didSet {
            markLayer.strokeColor = secondaryCheckmarkTintColor?.CGColor
        }
    }
    
    override var hideBox: Bool {
        didSet {
            selectedBoxLayer.hidden = hideBox
            unselectedBoxLayer.hidden = hideBox
        }
    }
    
    override init() {
        // Disable som implicit animations.
        let newActions = [
            "opacity": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull(),
            "fillColor": NSNull(),
            "path": NSNull(),
            "lineWidth": NSNull()
        ]
        
        // Setup the unselected box layer
        unselectedBoxLayer.lineCap = kCALineCapRound
        unselectedBoxLayer.rasterizationScale = UIScreen.mainScreen().scale
        unselectedBoxLayer.shouldRasterize = true
        unselectedBoxLayer.actions = newActions
        
        unselectedBoxLayer.opacity = 1.0
        unselectedBoxLayer.strokeEnd = 1.0
        unselectedBoxLayer.transform = CATransform3DIdentity
        unselectedBoxLayer.fillColor = nil
        
        // Setup the selected box layer.
        selectedBoxLayer.lineCap = kCALineCapRound
        selectedBoxLayer.rasterizationScale = UIScreen.mainScreen().scale
        selectedBoxLayer.shouldRasterize = true
        selectedBoxLayer.actions = newActions
        
        selectedBoxLayer.transform = CATransform3DIdentity
        
        // Setup the checkmark layer.
        markLayer.lineCap = kCALineCapRound
        markLayer.lineJoin = kCALineJoinRound
        markLayer.rasterizationScale = UIScreen.mainScreen().scale
        markLayer.shouldRasterize = true
        markLayer.actions = newActions
        
        markLayer.transform = CATransform3DIdentity
        markLayer.fillColor = nil
    }
    
    //----------------------------
    // MARK: - Layers
    //----------------------------
    
    let markLayer = CAShapeLayer()
    let selectedBoxLayer = CAShapeLayer()
    let unselectedBoxLayer = CAShapeLayer()
    
    override var layersToDisplay: [CALayer] {
        return [unselectedBoxLayer, selectedBoxLayer, markLayer]
    }
    
    //----------------------------
    // MARK: - Animations
    //----------------------------
    
    override func animate(fromState: M13Checkbox.CheckState, toState: M13Checkbox.CheckState) {
        super.animate(fromState, toState: toState)
        
        if toState == .Unchecked {
            
            let wiggleAnimation = animations.fillAnimation(1, amplitude: 0.18, reverse: true)
            let opacityAnimation = animations.opacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
            })
            
            selectedBoxLayer.addAnimation(wiggleAnimation, forKey: "transform")
            markLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            
        } else {
            if fromState == .Unchecked {
                markLayer.path = paths.path(toState)?.CGPath
                
                let wiggleAnimation = animations.fillAnimation(1, amplitude: 0.18, reverse: false)
                let opacityAnimation = animations.opacityAnimation(false)
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({ () -> Void in
                    self.resetLayersForState(toState)
                })
                
                selectedBoxLayer.addAnimation(wiggleAnimation, forKey: "transform")
                markLayer.addAnimation(opacityAnimation, forKey: "opacity")
                
                CATransaction.commit()
            } else {
                let fromPath = paths.path(fromState)
                let toPath = paths.path(toState)
                
                let morphAnimation = animations.morphAnimation(fromPath!, toPath: toPath!)
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                    self.resetLayersForState(self.state)
                    })
                
                markLayer.addAnimation(morphAnimation, forKey: "path")
                
                CATransaction.commit()
            }
        }
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    override func layoutLayers() {
        // Frames
        unselectedBoxLayer.frame = CGRectMake(0.0, 0.0, paths.size, paths.size)
        selectedBoxLayer.frame = CGRectMake(0.0, 0.0, paths.size, paths.size)
        markLayer.frame = CGRectMake(0.0, 0.0, paths.size, paths.size)
        // Paths
        unselectedBoxLayer.path = paths.pathForBox().CGPath
        selectedBoxLayer.path = paths.pathForBox().CGPath
        markLayer.path = paths.path(state)?.CGPath
    }
    
    //----------------------------
    // MARK: - Display
    //----------------------------
    
    override func resetLayersForState(state: M13Checkbox.CheckState) {
        super.resetLayersForState(state)
        // Remove all remnant animations. They will interfere with each other if they are not removed before a new round of animations start.
        unselectedBoxLayer.removeAllAnimations()
        selectedBoxLayer.removeAllAnimations()
        markLayer.removeAllAnimations()
        
        // Set the properties for the final states of each necessary property of each layer.
        unselectedBoxLayer.strokeColor = secondaryTintColor?.CGColor
        unselectedBoxLayer.lineWidth = paths.boxLineWidth
        
        selectedBoxLayer.strokeColor = tintColor.CGColor
        selectedBoxLayer.fillColor = tintColor.CGColor
        selectedBoxLayer.lineWidth = paths.boxLineWidth
        
        markLayer.strokeColor = secondaryCheckmarkTintColor?.CGColor
        markLayer.lineWidth = paths.checkmarkLineWidth
        
        if state == .Unchecked {
            selectedBoxLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            markLayer.opacity = 0.0
        } else if state == .Checked {
            selectedBoxLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            markLayer.opacity = 1.0
        } else {
            selectedBoxLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            markLayer.opacity = 1.0
        }
        
        // Paths
        unselectedBoxLayer.path = paths.pathForBox().CGPath
        selectedBoxLayer.path = paths.pathForBox().CGPath
        markLayer.path = paths.path(state)?.CGPath
    }
    
}

