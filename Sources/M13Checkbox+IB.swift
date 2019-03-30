//
//  M13Checkbox+IB.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 2/24/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public extension M13Checkbox {
    
    /// A proxy to set the box type compatible with interface builder.
    @IBInspectable var _IBStateChangeAnimation: String {
        get {
            return stateChangeAnimation.rawValue
        }
        set {
            if let type = Animation(rawValue: newValue) {
                stateChangeAnimation = type
            } else {
                stateChangeAnimation = DefaultValues.animation
            }
        }
    }
    
    /// A proxy to set the mark type compatible with interface builder.
    @IBInspectable var _IBMarkType: String {
        get {
            return markType.rawValue
        }
        set {
            if let type = MarkType(rawValue: newValue) {
                markType = type
            } else {
                markType = DefaultValues.markType
            }
        }
    }
    
    /// A proxy to set the box type compatible with interface builder.
    @IBInspectable var _IBBoxType: String {
        get {
            return boxType.rawValue
        }
        set {
            if let type = BoxType(rawValue: newValue) {
                boxType = type
            } else {
                boxType = DefaultValues.boxType
            }
        }
    }
    
    /// A proxy to set the check state compatible with interface builder.
    @IBInspectable var _IBCheckState: String {
        get {
            return checkState.rawValue
        }
        set {
            if let temp = CheckState(rawValue: newValue) {
                checkState = temp
            } else {
                checkState = DefaultValues.checkState
            }
        }
    }
    
}
