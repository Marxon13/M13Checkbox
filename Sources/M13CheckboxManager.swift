//
//  M13CheckboxManager.swift
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

internal class M13CheckboxManager {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// The path presets for the manager.
    var paths: M13CheckboxPathPresets = M13CheckboxPathPresets()
    
    /// The animation presets for the manager.
    var animations: M13CheckboxAnimationPresets = M13CheckboxAnimationPresets()
    
    /// The current state of the checkbox.
    var state: M13Checkbox.CheckState = .unchecked
    
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
    func animate(_ fromState: M13Checkbox.CheckState, toState: M13Checkbox.CheckState) {
        state = toState
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
    func resetLayersForState(_ state: M13Checkbox.CheckState) {
        self.state = state
        layoutLayers()
    }
    
}
