//
//  M13CheckboxBounceManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/30/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

internal class M13CheckboxBounceManager: M13CheckboxManager {
    
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
            
            let amplitude: CGFloat = paths.boxType == .Square ? 0.20 : 0.35
            let wiggleAnimation = animations.fillAnimation(1, amplitude: amplitude, reverse: true)
            let opacityAnimation = animations.opacityAnimation(true)
            opacityAnimation.duration = opacityAnimation.duration / 1.5
            opacityAnimation.beginTime = CACurrentMediaTime() + animations.animationDuration - opacityAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(self.state)
            })
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            markLayer.addAnimation(wiggleAnimation, forKey: "transform")
            
            CATransaction.commit()
            
        } else {
            if fromState == .Unchecked {
                markLayer.path = paths.path(toState)?.CGPath
                
                let amplitude: CGFloat = paths.boxType == .Square ? 0.20 : 0.35
                let wiggleAnimation = animations.fillAnimation(1, amplitude: amplitude, reverse: false)
                
                let opacityAnimation = animations.opacityAnimation(false)
                opacityAnimation.duration = opacityAnimation.duration / 1.5
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({ () -> Void in
                    self.resetLayersForState(self.state)
                })
                
                selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
                markLayer.addAnimation(wiggleAnimation, forKey: "transform")
                
                CATransaction.commit()
            } else {
                if paths.markType != .Radio {
                    let fromPath = paths.path(fromState)
                    let toPath = paths.path(toState)
                    
                    let morphAnimation = animations.morphAnimation(fromPath!, toPath: toPath!)
                    
                    CATransaction.begin()
                    CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                        self.resetLayersForState(self.state)
                        })
                    
                    markLayer.addAnimation(morphAnimation, forKey: "path")
                    
                    CATransaction.commit()
                } else {
                    
                    var compressionAnimation: CAAnimation? = nil
                    if toState == .Mixed {
                        let toPath = paths.path(fromState)
                        let scale: CGFloat = 0.5 / 0.665
                        toPath?.applyTransform(CGAffineTransformMakeScale(scale, 0.002))
                        toPath?.applyTransform(CGAffineTransformMakeTranslation(((paths.size * 0.665) - (paths.size * 0.5)) * scale, (paths.size / 2.0) - (paths.boxLineWidth * 0.5 * scale)))
                        compressionAnimation = animations.morphAnimation(paths.path(fromState)!, toPath: toPath!)
                    } else {
                        let fromPath = paths.path(toState)
                        let scale: CGFloat = 0.5 / 0.665
                        fromPath?.applyTransform(CGAffineTransformMakeScale(scale, 0.002))
                        fromPath?.applyTransform(CGAffineTransformMakeTranslation(((paths.size * 0.665) - (paths.size * 0.5)) * scale, (paths.size / 2.0) - (paths.boxLineWidth * 0.5 * scale)))
                        compressionAnimation = animations.morphAnimation(fromPath!, toPath: paths.path(toState)!)
                    }
                    
                    CATransaction.begin()
                    CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                        self.resetLayersForState(self.state)
                        })
                    
                    markLayer.addAnimation(compressionAnimation!, forKey: "path")
                    
                    CATransaction.commit()
                }

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
            selectedBoxLayer.opacity = 0.0
            markLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        } else if state == .Checked {
            markLayer.transform = CATransform3DIdentity
            selectedBoxLayer.opacity = 1.0
        } else {
            markLayer.transform = CATransform3DIdentity
            selectedBoxLayer.opacity = 1.0
        }
        
        // Paths
        unselectedBoxLayer.path = paths.pathForBox().CGPath
        selectedBoxLayer.path = paths.pathForBox().CGPath
        markLayer.path = paths.path(state)?.CGPath
    }
    
}


