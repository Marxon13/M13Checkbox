//
//  M13Checkbox+IB.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 2/24/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

extension M13Checkbox {
    
    /// A proxy to set the box type compatible with interface builder.
    @IBInspectable public var _IBStateChangeAnimation: Int {
        get {
            return stateChangeAnimation.rawValue
        }
        set {
            if let type = Animation(rawValue: newValue) {
                stateChangeAnimation = type
            } else {
                stateChangeAnimation = .Stroke
            }
        }
    }
    
    /// A proxy to set the mark type compatible with interface builder.
    @IBInspectable public var _IBMarkType: Int {
        get {
            return markType.rawValue
        }
        set {
            if let type = MarkType(rawValue: newValue) {
                markType = type
            } else {
                markType = .Checkmark
            }
        }
    }
    
    /// A proxy to set the box type compatible with interface builder.
    @IBInspectable public var _IBBoxType: Int {
        get {
            return boxType.rawValue
        }
        set {
            if let type = BoxType(rawValue: newValue) {
                boxType = type
            } else {
                boxType = .Circle
            }
        }
    }
    
    /// A proxy to set the check state compatible with interface builder.
    @IBInspectable public var _IBCheckState: Int {
        get {
            return checkState.rawValue
        }
        set {
            if let temp = CheckState(rawValue: newValue) {
                checkState = temp
            } else {
                checkState = .Unchecked
            }
        }
    }
    
}
