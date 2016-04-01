//
//  M13CheckboxDotManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/1/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class M13CheckboxDotManager: M13CheckboxManager {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    override var tintColor: UIColor {
        didSet {
            selectedBoxLayer.strokeColor = tintColor.CGColor
            if style == .Stroke {
                markLayer.strokeColor = tintColor.CGColor
            } else {
                selectedBoxLayer.fillColor = tintColor.CGColor
            }
        }
    }
    
    override var secondaryTintColor: UIColor? {
        didSet {
            unselectedBoxLayer.strokeColor = secondaryTintColor?.CGColor
        }
    }
    
    override var secondaryCheckmarkTintColor: UIColor? {
        didSet {
            if style == .Fill {
                markLayer.strokeColor = secondaryCheckmarkTintColor?.CGColor
            }
        }
    }
    
    override var hideBox: Bool {
        didSet {
            selectedBoxLayer.hidden = hideBox
            unselectedBoxLayer.hidden = hideBox
        }
    }
    
    private var style: M13Checkbox.AnimationStyle = .Stroke
    
    init(style: M13Checkbox.AnimationStyle) {
        self.style = style
        super.init()
        sharedSetup()
    }
    
    override init() {
        super.init()
        sharedSetup()
    }
    
    private func sharedSetup() {
        // Set the path presets to the subclass
        paths = M13CheckboxDotPathPresets()
        
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

        unselectedBoxLayer.transform = CATransform3DIdentity
        unselectedBoxLayer.fillColor = nil
        
        // Setup the selected box layer.
        selectedBoxLayer.lineCap = kCALineCapRound
        selectedBoxLayer.rasterizationScale = UIScreen.mainScreen().scale
        selectedBoxLayer.shouldRasterize = true
        selectedBoxLayer.actions = newActions
        
        selectedBoxLayer.fillColor = nil
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
            let scaleAnimation = animations.fillAnimation(1, amplitude: 0.18, reverse: true)
            let opacityAnimation = animations.opacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
            })
            
            if style == .Stroke {
                unselectedBoxLayer.opacity = 0.0
                let quickOpacityAnimation = animations.quickOpacityAnimation(false)
                quickOpacityAnimation.beginTime = CACurrentMediaTime() + scaleAnimation.duration - quickOpacityAnimation.duration
                unselectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            }
            selectedBoxLayer.addAnimation(scaleAnimation, forKey: "transform")
            markLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            
        } else {
            if fromState == .Unchecked {
                markLayer.path = paths.path(toState)?.CGPath
                
                let scaleAnimation = animations.fillAnimation(1, amplitude: 0.18, reverse: false)
                let opacityAnimation = animations.opacityAnimation(false)
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({ () -> Void in
                    self.resetLayersForState(toState)
                })
                
                if style == .Stroke {
                    let quickOpacityAnimation = animations.quickOpacityAnimation(true)
                    quickOpacityAnimation.beginTime = CACurrentMediaTime()
                    unselectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
                }
                selectedBoxLayer.addAnimation(scaleAnimation, forKey: "transform")
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
        unselectedBoxLayer.path = (paths as! M13CheckboxDotPathPresets).pathForDot().CGPath
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
        
        if style == .Stroke {
            selectedBoxLayer.fillColor = nil
            markLayer.strokeColor = tintColor.CGColor
            if paths.markType == .Checkmark {
                markLayer.fillColor = nil
            } else {
                markLayer.fillColor = tintColor.CGColor
            }
        } else {
            selectedBoxLayer.fillColor = tintColor.CGColor
            markLayer.strokeColor = secondaryCheckmarkTintColor?.CGColor
        }
        
        markLayer.lineWidth = paths.checkmarkLineWidth
        
        if state == .Unchecked {
            unselectedBoxLayer.opacity = 1.0
            selectedBoxLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            markLayer.opacity = 0.0
        } else if state == .Checked {
            unselectedBoxLayer.opacity = 0.0
            selectedBoxLayer.transform = CATransform3DIdentity
            markLayer.opacity = 1.0
        } else {
            unselectedBoxLayer.opacity = 0.0
            selectedBoxLayer.transform = CATransform3DIdentity
            markLayer.opacity = 1.0
        }
        
        // Paths
        unselectedBoxLayer.path = (paths as! M13CheckboxDotPathPresets).pathForDot().CGPath
        selectedBoxLayer.path = paths.pathForBox().CGPath
        markLayer.path = paths.path(state)?.CGPath
    }
    
}
