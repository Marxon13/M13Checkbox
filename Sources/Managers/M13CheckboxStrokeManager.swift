//
//  M13CheckboxStrokeManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/27/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

internal class M13CheckboxStrokeManager: M13CheckboxManager {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    override var tintColor: UIColor {
        didSet {
            selectedBoxLayer.strokeColor = tintColor.cgColor
            markLayer.strokeColor = tintColor.cgColor
        }
    }
    
    override var secondaryTintColor: UIColor? {
        didSet {
            unselectedBoxLayer.strokeColor = secondaryTintColor?.cgColor
        }
    }
    
    override var hideBox: Bool {
        didSet {
            selectedBoxLayer.isHidden = hideBox
            unselectedBoxLayer.isHidden = hideBox
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
        unselectedBoxLayer.rasterizationScale = UIScreen.main.scale
        unselectedBoxLayer.shouldRasterize = true
        unselectedBoxLayer.actions = newActions
        
        unselectedBoxLayer.opacity = 1.0
        unselectedBoxLayer.strokeEnd = 1.0
        unselectedBoxLayer.transform = CATransform3DIdentity
        unselectedBoxLayer.fillColor = nil
        
        // Setup the selected box layer.
        selectedBoxLayer.lineCap = kCALineCapRound
        selectedBoxLayer.rasterizationScale = UIScreen.main.scale
        selectedBoxLayer.shouldRasterize = true
        selectedBoxLayer.actions = newActions
        
        selectedBoxLayer.transform = CATransform3DIdentity
        selectedBoxLayer.fillColor = nil
        
        // Setup the checkmark layer.
        markLayer.lineCap = kCALineCapRound
        markLayer.lineJoin = kCALineJoinRound
        markLayer.rasterizationScale = UIScreen.main.scale
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
    
    override func animate(_ fromState: M13Checkbox.CheckState, toState: M13Checkbox.CheckState) {
        super.animate(fromState, toState: toState)
        
        if toState == .unchecked {
            let strokeAnimation = animations.strokeAnimation(true)
            let quickOpacityAnimation = animations.quickOpacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                self.resetLayersForState(self.state)
                })
            
            markLayer.add(strokeAnimation, forKey: "strokeEnd")
            markLayer.add(quickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.add(strokeAnimation, forKey: "strokeEnd")
            selectedBoxLayer.add(quickOpacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            
        } else {
            if fromState == .unchecked {
                markLayer.path = paths.path(toState)?.cgPath
                
                let strokeAnimation = animations.strokeAnimation(false)
                let quickOpacityAnimation = animations.quickOpacityAnimation(false)
                
                CATransaction.begin()
                CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                    self.resetLayersForState(self.state)
                    })
                
                markLayer.add(strokeAnimation, forKey: "strokeEnd")
                markLayer.add(quickOpacityAnimation, forKey: "opacity")
                selectedBoxLayer.add(strokeAnimation, forKey: "strokeEnd")
                selectedBoxLayer.add(quickOpacityAnimation, forKey: "opacity")
                
                CATransaction.commit()
            } else {
                if paths.markType != .radio {
                    let fromPath = paths.path(fromState)
                    let toPath = paths.path(toState)
                    
                    let morphAnimation = animations.morphAnimation(fromPath!, toPath: toPath!)
                    
                    CATransaction.begin()
                    CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                        self.resetLayersForState(self.state)
                        })
                    
                    markLayer.add(morphAnimation, forKey: "path")
                    
                    CATransaction.commit()
                } else {
                    
                    var compressionAnimation: CAAnimation? = nil
                    if toState == .mixed {
                        let toPath = paths.path(fromState)
                        let scale: CGFloat = 0.5 / 0.665
                        toPath?.apply(CGAffineTransform(scaleX: scale, y: 0.002))
                        toPath?.apply(CGAffineTransform(translationX: ((paths.size * 0.665) - (paths.size * 0.5)) * scale, y: (paths.size / 2.0) - (paths.boxLineWidth * 0.5 * scale)))
                        compressionAnimation = animations.morphAnimation(paths.path(fromState)!, toPath: toPath!)
                    } else {
                        let fromPath = paths.path(toState)
                        let scale: CGFloat = 0.5 / 0.665
                        fromPath?.apply(CGAffineTransform(scaleX: scale, y: 0.002))
                        fromPath?.apply(CGAffineTransform(translationX: ((paths.size * 0.665) - (paths.size * 0.5)) * scale, y: (paths.size / 2.0) - (paths.boxLineWidth * 0.5 * scale)))
                        compressionAnimation = animations.morphAnimation(fromPath!, toPath: paths.path(toState)!)
                    }
                    
                    CATransaction.begin()
                    CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                        self.resetLayersForState(self.state)
                        })

                    markLayer.add(compressionAnimation!, forKey: "path")
                    
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
        unselectedBoxLayer.frame = CGRect(x: 0.0, y: 0.0, width: paths.size, height: paths.size)
        selectedBoxLayer.frame = CGRect(x: 0.0, y: 0.0, width: paths.size, height: paths.size)
        markLayer.frame = CGRect(x: 0.0, y: 0.0, width: paths.size, height: paths.size)
        // Paths
        unselectedBoxLayer.path = paths.pathForBox().cgPath
        selectedBoxLayer.path = paths.pathForBox().cgPath
        markLayer.path = paths.path(state)?.cgPath
    }
    
    //----------------------------
    // MARK: - Display
    //----------------------------
    
    override func resetLayersForState(_ state: M13Checkbox.CheckState) {
        super.resetLayersForState(state)
        // Remove all remnant animations. They will interfere with each other if they are not removed before a new round of animations start.
        unselectedBoxLayer.removeAllAnimations()
        selectedBoxLayer.removeAllAnimations()
        markLayer.removeAllAnimations()
        
        // Set the properties for the final states of each necessary property of each layer.
        unselectedBoxLayer.strokeColor = secondaryTintColor?.cgColor
        unselectedBoxLayer.lineWidth = paths.boxLineWidth
        
        selectedBoxLayer.strokeColor = tintColor.cgColor
        selectedBoxLayer.lineWidth = paths.boxLineWidth
        
        markLayer.strokeColor = tintColor.cgColor
        markLayer.lineWidth = paths.checkmarkLineWidth
        
        if state == .unchecked {
            selectedBoxLayer.opacity = 0.0
            selectedBoxLayer.strokeEnd = 0.0
            
            markLayer.opacity = 0.0
            markLayer.strokeEnd = 0.0
            
        } else if state == .checked {
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
        unselectedBoxLayer.path = paths.pathForBox().cgPath
        selectedBoxLayer.path = paths.pathForBox().cgPath
        markLayer.path = paths.path(state)?.cgPath
    }
    
}
