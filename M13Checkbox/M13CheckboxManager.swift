//
//  M13CheckboxManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/18/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

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
    var state: M13Checkbox.CheckState = .Unchecked
    
    /// The current tint color.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var tintColor: UIColor = UIColor.blackColor()
    
    /// The secondary tint color.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var secondaryTintColor: UIColor? = UIColor.lightGrayColor()
    
    /// The secondary color of the mark.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var secondaryCheckmarkTintColor: UIColor? = UIColor.whiteColor()
    
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
    func animate(fromState: M13Checkbox.CheckState, toState: M13Checkbox.CheckState) {
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
    func resetLayersForState(state: M13Checkbox.CheckState) {
        self.state = state
        layoutLayers()
    }
    
}
