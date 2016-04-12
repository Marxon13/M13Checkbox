//
//  M13CheckboxSpiralManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/1/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class M13CheckboxSpiralManager: M13CheckboxManager {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    override var tintColor: UIColor {
        didSet {
            selectedBoxLayer.strokeColor = tintColor.CGColor
            markLayer.strokeColor = tintColor.CGColor
        }
    }
    
    override var secondaryTintColor: UIColor? {
        didSet {
            unselectedBoxLayer.strokeColor = secondaryTintColor?.CGColor
        }
    }
    
    override var hideBox: Bool {
        didSet {
            selectedBoxLayer.hidden = hideBox
            unselectedBoxLayer.hidden = hideBox
        }
    }
    
    override init() {
        super.init()
        
        paths = M13CheckboxSpiralPathPresets()
        
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
        selectedBoxLayer.fillColor = nil
        
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
            // Temporarily set the path of the checkmark to the long checkmark
            markLayer.path = (paths as! M13CheckboxSpiralPathPresets).pathForLongMark(toState).bezierPathByReversingPath().CGPath
            
            let checkMorphAnimation = animations.morphAnimation(paths.path(toState)!.bezierPathByReversingPath(), toPath: (paths as! M13CheckboxSpiralPathPresets).pathForLongMark(toState).bezierPathByReversingPath())
            checkMorphAnimation.fillMode = kCAFillModeBackwards
            checkMorphAnimation.duration = checkMorphAnimation.duration / 4.0
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let checkStrokeAnimation = animations.strokeAnimation(true)
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 4.0
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            let boxStrokeAnimation = animations.strokeAnimation(true)
            boxStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2.0
            boxStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let quickOpacityAnimation = animations.quickOpacityAnimation(true)
            
            let checkQuickOpacityAnimation = animations.quickOpacityAnimation(true)
            checkQuickOpacityAnimation.duration = 0.001
            checkQuickOpacityAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
            })
            
            selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            markLayer.addAnimation(checkMorphAnimation, forKey: "path")
            markLayer.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")
            markLayer.addAnimation(checkQuickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")
            
            CATransaction.commit()
            
        } else {
            if fromState == .Unchecked {
                // Temporarly set to the long mark.
                markLayer.path = (paths as! M13CheckboxSpiralPathPresets).pathForLongMark(toState).bezierPathByReversingPath().CGPath
                
                let quickOpacityAnimation = animations.quickOpacityAnimation(false)
                
                let boxStrokeAnimation = animations.strokeAnimation(false)
                boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2.0
                boxStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                
                let checkQuickOpacityAnimation = animations.quickOpacityAnimation(false)
                checkQuickOpacityAnimation.duration = 0.001
                checkQuickOpacityAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
                
                let checkStrokeAnimation = animations.strokeAnimation(false)
                checkStrokeAnimation.duration = checkStrokeAnimation.duration / 4.0
                checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                checkStrokeAnimation.fillMode = kCAFillModeBackwards
                checkStrokeAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
                
                let checkMorphAnimation = animations.morphAnimation((paths as! M13CheckboxSpiralPathPresets).pathForLongMark(toState).bezierPathByReversingPath(), toPath: paths.path(toState)!.bezierPathByReversingPath())
                checkMorphAnimation.duration = checkMorphAnimation.duration / 4.0
                checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                checkMorphAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkStrokeAnimation.duration
                checkMorphAnimation.fillMode = kCAFillModeBackwards
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({ () -> Void in
                    self.resetLayersForState(toState)
                })
                
                selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
                selectedBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")
                markLayer.addAnimation(checkQuickOpacityAnimation, forKey: "opacity")
                markLayer.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")
                markLayer.addAnimation(checkMorphAnimation, forKey: "path")
                
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
        selectedBoxLayer.lineWidth = paths.boxLineWidth
        
        markLayer.strokeColor = tintColor.CGColor
        markLayer.lineWidth = paths.checkmarkLineWidth
        
        if state == .Unchecked {
            selectedBoxLayer.opacity = 0.0
            selectedBoxLayer.strokeEnd = 0.0
            
            markLayer.opacity = 0.0
            markLayer.strokeEnd = 0.0
            
        } else if state == .Checked {
            selectedBoxLayer.opacity = 1.0
            selectedBoxLayer.strokeEnd = 1.0
            
            markLayer.opacity = 1.0
            markLayer.strokeEnd = 1.0
        } else {
            selectedBoxLayer.opacity = 1.0
            selectedBoxLayer.strokeEnd = 1.0
            
            markLayer.opacity = 1.0
            markLayer.strokeEnd = 1.0
        }
        
        // Paths
        unselectedBoxLayer.path = paths.pathForBox().CGPath
        selectedBoxLayer.path = paths.pathForBox().CGPath
        markLayer.path = paths.path(state)?.CGPath
    }
    
}

