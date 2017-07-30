//
//  M13CheckboxController.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/18/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

internal class M13CheckboxController {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// The path presets for the manager.
    var pathGenerator: M13CheckboxPathGenerator = M13CheckboxCheckPathGenerator()
    
    /// The animation presets for the manager.
    var animationGenerator: M13CheckboxAnimationGenerator = M13CheckboxAnimationGenerator()
    
    /// The current state of the checkbox.
    var state: M13Checkbox.CheckState = DefaultValues.checkState
    
    /// The current tint color.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var tintColor: UIColor = UIColor.black
    
    /// The secondary tint color.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var secondaryTintColor: UIColor? = UIColor.lightGray
    
    /// The secondary color of the mark.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var secondaryCheckmarkTintColor: UIColor? = UIColor.white
    
    /// Whether or not to hide the box.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var hideBox: Bool = false
    
    /// Whether or not to allow morphong between states.
    var enableMorphing: Bool = true
    
    // The type of mark to display.
    var markType: M13Checkbox.MarkType {
        get {
            return _markType
        }
        set {
            setMarkType(type: newValue, animated: false)
        }
    }
    
    private var _markType: M13Checkbox.MarkType = DefaultValues.markType
    
    func setMarkType(type: M13Checkbox.MarkType, animated: Bool) {
        guard type != _markType else {
            return
        }
        _setMarkType(type: type, animated: animated)
        _markType = type
    }
    
    private func _setMarkType(type: M13Checkbox.MarkType, animated: Bool) {
        var newPathGenerator: M13CheckboxPathGenerator
        switch type {
        case .checkmark:
            newPathGenerator = M13CheckboxCheckPathGenerator()
        case .radio:
            newPathGenerator = M13CheckboxRadioPathGenerator()
        case .addRemove:
            newPathGenerator = M13CheckboxAddRemovePathGenerator()
        case .disclosure:
            newPathGenerator = M13CheckboxDisclosurePathGenerator()
        }
        
        newPathGenerator.boxLineWidth = pathGenerator.boxLineWidth
        newPathGenerator.boxType = pathGenerator.boxType
        newPathGenerator.checkmarkLineWidth = pathGenerator.checkmarkLineWidth
        newPathGenerator.cornerRadius = pathGenerator.cornerRadius
        newPathGenerator.size = pathGenerator.size
        
        // Animate the change.
        if pathGenerator.pathForMark(state) != nil && animated {
            let previousState = state
            animate(state, toState: nil, completion: { [weak self] in
                self?.pathGenerator = newPathGenerator
                self?.resetLayersForState(previousState)
                if self?.pathGenerator.pathForMark(previousState) != nil {
                    self?.animate(nil, toState: previousState)
                }
            })
        } else if newPathGenerator.pathForMark(state) != nil && animated {
            let previousState = state
            pathGenerator = newPathGenerator
            resetLayersForState(nil)
            animate(nil, toState: previousState)
        } else {
            pathGenerator = newPathGenerator
            resetLayersForState(state)
        }
    }
    
    //----------------------------
    // MARK: - Layers
    //----------------------------
    
    /// The layers to display in the checkbox. The top layer is the last layer in the array.
    var layersToDisplay: [CALayer] {
        return []
    }
    
    //----------------------------
    // MARK: - Animations
    //----------------------------
    
    /**
     Animates the layers between the two states.
     - parameter fromState: The previous state of the checkbox.
     - parameter toState: The new state of the checkbox.
     */
    func animate(_ fromState: M13Checkbox.CheckState?, toState: M13Checkbox.CheckState?, completion: (() -> Void)? = nil) {
        if let toState = toState {
            state = toState
        }
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    /// Layout the layers.
    func layoutLayers() {
        
    }
    
    //----------------------------
    // MARK: - Display
    //----------------------------
    
    /**
     Reset the layers to be in the given state.
     - parameter state: The new state of the checkbox.
     */
    func resetLayersForState(_ state: M13Checkbox.CheckState?) {
        if let state = state {
            self.state = state
        }
        layoutLayers()
    }
    
}
