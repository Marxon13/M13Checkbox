//
//  M13CheckboxDotController.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/1/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

internal class M13CheckboxDotController: M13CheckboxController {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    override var tintColor: UIColor {
        didSet {
            selectedBoxLayer.strokeColor = tintColor.cgColor
            if style == .stroke {
                markLayer.strokeColor = tintColor.cgColor
                if markType == .radio {
                    markLayer.fillColor = tintColor.cgColor
                }
            } else {
                selectedBoxLayer.fillColor = tintColor.cgColor
            }
        }
    }
    
    override var secondaryTintColor: UIColor? {
        didSet {
            unselectedBoxLayer.strokeColor = secondaryTintColor?.cgColor
        }
    }
    
    override var secondaryCheckmarkTintColor: UIColor? {
        didSet {
            if style == .fill {
                markLayer.strokeColor = secondaryCheckmarkTintColor?.cgColor
            }
        }
    }
    
    override var hideBox: Bool {
        didSet {
            selectedBoxLayer.isHidden = hideBox
            unselectedBoxLayer.isHidden = hideBox
        }
    }
    
    fileprivate var style: M13Checkbox.AnimationStyle = .stroke
    
    init(style: M13Checkbox.AnimationStyle) {
        self.style = style
        super.init()
        sharedSetup()
    }
    
    override init() {
        super.init()
        sharedSetup()
    }
    
    fileprivate func sharedSetup() {
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
        unselectedBoxLayer.lineCap = CAShapeLayerLineCap.round
        unselectedBoxLayer.rasterizationScale = UIScreen.main.scale
        unselectedBoxLayer.shouldRasterize = true
        unselectedBoxLayer.actions = newActions
        
        unselectedBoxLayer.transform = CATransform3DIdentity
        unselectedBoxLayer.fillColor = nil
        
        // Setup the selected box layer.
        selectedBoxLayer.lineCap = CAShapeLayerLineCap.round
        selectedBoxLayer.rasterizationScale = UIScreen.main.scale
        selectedBoxLayer.shouldRasterize = true
        selectedBoxLayer.actions = newActions
        
        selectedBoxLayer.fillColor = nil
        selectedBoxLayer.transform = CATransform3DIdentity
        
        // Setup the checkmark layer.
        markLayer.lineCap = CAShapeLayerLineCap.round
        markLayer.lineJoin = CAShapeLayerLineJoin.round
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
    
    override func animate(_ fromState: M13Checkbox.CheckState?, toState: M13Checkbox.CheckState?, completion: (() -> Void)?) {
        super.animate(fromState, toState: toState)
        
        if pathGenerator.pathForMark(toState) == nil && pathGenerator.pathForMark(fromState) != nil {
            let scaleAnimation = animationGenerator.fillAnimation(1, amplitude: 0.18, reverse: true)
            let opacityAnimation = animationGenerator.opacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
                completion?()
            })
            
            if style == .stroke {
                unselectedBoxLayer.opacity = 0.0
                let quickOpacityAnimation = animationGenerator.quickOpacityAnimation(false)
                quickOpacityAnimation.beginTime = CACurrentMediaTime() + scaleAnimation.duration - quickOpacityAnimation.duration
                unselectedBoxLayer.add(quickOpacityAnimation, forKey: "opacity")
            }
            selectedBoxLayer.add(scaleAnimation, forKey: "transform")
            markLayer.add(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
        } else if pathGenerator.pathForMark(toState) != nil && pathGenerator.pathForMark(fromState) == nil {
            markLayer.path = pathGenerator.pathForMark(toState)?.cgPath
            
            let scaleAnimation = animationGenerator.fillAnimation(1, amplitude: 0.18, reverse: false)
            let opacityAnimation = animationGenerator.opacityAnimation(false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
                completion?()
            })
            
            if style == .stroke {
                let quickOpacityAnimation = animationGenerator.quickOpacityAnimation(true)
                quickOpacityAnimation.beginTime = CACurrentMediaTime()
                unselectedBoxLayer.add(quickOpacityAnimation, forKey: "opacity")
            }
            selectedBoxLayer.add(scaleAnimation, forKey: "transform")
            markLayer.add(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
        } else {
            let fromPath = pathGenerator.pathForMark(fromState)
            let toPath = pathGenerator.pathForMark(toState)
            
            let morphAnimation = animationGenerator.morphAnimation(fromPath, toPath: toPath)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                self.resetLayersForState(self.state)
                completion?()
                })
            
            markLayer.add(morphAnimation, forKey: "path")
            
            CATransaction.commit()
        }
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    override func layoutLayers() {
        // Frames
        unselectedBoxLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        selectedBoxLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        markLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        // Paths
        unselectedBoxLayer.path = pathGenerator.pathForDot()?.cgPath
        selectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        markLayer.path = pathGenerator.pathForMark(state)?.cgPath
    }
    
    //----------------------------
    // MARK: - Display
    //----------------------------
    
    override func resetLayersForState(_ state: M13Checkbox.CheckState?) {
        super.resetLayersForState(state)
        // Remove all remnant animations. They will interfere with each other if they are not removed before a new round of animations start.
        unselectedBoxLayer.removeAllAnimations()
        selectedBoxLayer.removeAllAnimations()
        markLayer.removeAllAnimations()
        
        // Set the properties for the final states of each necessary property of each layer.
        unselectedBoxLayer.strokeColor = secondaryTintColor?.cgColor
        unselectedBoxLayer.lineWidth = pathGenerator.boxLineWidth
        
        selectedBoxLayer.strokeColor = tintColor.cgColor
        selectedBoxLayer.lineWidth = pathGenerator.boxLineWidth
        
        if style == .stroke {
            selectedBoxLayer.fillColor = nil
            markLayer.strokeColor = tintColor.cgColor
            if markType != .radio {
                markLayer.fillColor = nil
            } else {
                markLayer.fillColor = tintColor.cgColor
            }
        } else {
            selectedBoxLayer.fillColor = tintColor.cgColor
            markLayer.strokeColor = secondaryCheckmarkTintColor?.cgColor
        }
        
        markLayer.lineWidth = pathGenerator.checkmarkLineWidth
        
        if pathGenerator.pathForMark(state) != nil {
            unselectedBoxLayer.opacity = 0.0
            selectedBoxLayer.transform = CATransform3DIdentity
            markLayer.opacity = 1.0
        } else {
            unselectedBoxLayer.opacity = 1.0
            selectedBoxLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            markLayer.opacity = 0.0
        }
        
        // Paths
        unselectedBoxLayer.path = pathGenerator.pathForDot()?.cgPath
        selectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        markLayer.path = pathGenerator.pathForMark(state)?.cgPath
    }
    
}

