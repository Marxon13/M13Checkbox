//
//  M13CheckboxSpiralController.swift
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

internal class M13CheckboxSpiralController: M13CheckboxController {
    
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
        super.init()
        
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
    
    override func animate(_ fromState: M13Checkbox.CheckState?, toState: M13Checkbox.CheckState?, completion: (() -> Void)?) {
        super.animate(fromState, toState: toState)
        
        if pathGenerator.pathForMark(toState) == nil && pathGenerator.pathForMark(fromState) != nil {
            // Temporarily set the path of the checkmark to the long checkmark
            markLayer.path = pathGenerator.pathForLongMark(fromState)?.reversing().cgPath
            
            let checkMorphAnimation = animationGenerator.morphAnimation(pathGenerator.pathForMark(fromState)?.reversing(), toPath: pathGenerator.pathForLongMark(fromState)?.reversing())
            checkMorphAnimation.fillMode = kCAFillModeBackwards
            checkMorphAnimation.duration = checkMorphAnimation.duration / 4.0
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let checkStrokeAnimation = animationGenerator.strokeAnimation(true)
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 4.0
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            let boxStrokeAnimation = animationGenerator.strokeAnimation(true)
            boxStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2.0
            boxStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let quickOpacityAnimation = animationGenerator.quickOpacityAnimation(true)
            
            let checkQuickOpacityAnimation = animationGenerator.quickOpacityAnimation(true)
            checkQuickOpacityAnimation.duration = 0.001
            checkQuickOpacityAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
                completion?()
            })
            
            selectedBoxLayer.add(quickOpacityAnimation, forKey: "opacity")
            markLayer.add(checkMorphAnimation, forKey: "path")
            markLayer.add(checkStrokeAnimation, forKey: "strokeEnd")
            markLayer.add(checkQuickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.add(boxStrokeAnimation, forKey: "strokeEnd")
            
            markLayer.strokeEnd = CGFloat((checkStrokeAnimation.fromValue as! NSNumber).floatValue)
            markLayer.opacity = (checkQuickOpacityAnimation.fromValue as! NSNumber).floatValue
            selectedBoxLayer.strokeEnd = CGFloat((checkStrokeAnimation.fromValue as! NSNumber).floatValue)
            
            CATransaction.commit()
        } else if pathGenerator.pathForMark(toState) != nil && pathGenerator.pathForMark(fromState) == nil {
            // Temporarly set to the long mark.
            markLayer.path = pathGenerator.pathForLongMark(toState)?.reversing().cgPath
            
            let quickOpacityAnimation = animationGenerator.quickOpacityAnimation(false)
            
            let boxStrokeAnimation = animationGenerator.strokeAnimation(false)
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2.0
            boxStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let checkQuickOpacityAnimation = animationGenerator.quickOpacityAnimation(false)
            checkQuickOpacityAnimation.duration = 0.001
            checkQuickOpacityAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
            
            let checkStrokeAnimation = animationGenerator.strokeAnimation(false)
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 4.0
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            checkStrokeAnimation.fillMode = kCAFillModeForwards
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
            
            let checkMorphAnimation = animationGenerator.morphAnimation(pathGenerator.pathForLongMark(toState)?.reversing(), toPath: pathGenerator.pathForMark(toState)?.reversing())
            checkMorphAnimation.duration = checkMorphAnimation.duration / 4.0
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            checkMorphAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkStrokeAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(toState)
                completion?()
            })
            
            selectedBoxLayer.add(quickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.add(boxStrokeAnimation, forKey: "strokeEnd")
            markLayer.add(checkQuickOpacityAnimation, forKey: "opacity")
            markLayer.add(checkStrokeAnimation, forKey: "strokeEnd")
            markLayer.add(checkMorphAnimation, forKey: "path")

            markLayer.strokeEnd = CGFloat((checkStrokeAnimation.fromValue as! NSNumber).floatValue)
            markLayer.opacity = (checkQuickOpacityAnimation.fromValue as! NSNumber).floatValue
            markLayer.path = pathGenerator.pathForLongMark(toState)?.reversing().cgPath
            
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
        unselectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
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
        unselectedBoxLayer.fillColor = nil
        
        selectedBoxLayer.strokeColor = tintColor.cgColor
        selectedBoxLayer.lineWidth = pathGenerator.boxLineWidth
        
        markLayer.strokeColor = tintColor.cgColor
        markLayer.lineWidth = pathGenerator.checkmarkLineWidth
        markLayer.fillColor = nil
        
        if pathGenerator.pathForMark(state) != nil {
            selectedBoxLayer.opacity = 1.0
            selectedBoxLayer.strokeEnd = 1.0
            
            markLayer.opacity = 1.0
            markLayer.strokeEnd = 1.0
        } else {
            selectedBoxLayer.opacity = 0.0
            selectedBoxLayer.strokeEnd = 0.0
            
            markLayer.opacity = 0.0
            markLayer.strokeEnd = 0.0
        }
        
        // Paths
        unselectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        selectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        markLayer.path = pathGenerator.pathForMark(state)?.cgPath
    }
    
}

