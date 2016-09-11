//
//  M13CheckboxGestureRecognizer.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/12/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import UIKit.UIGestureRecognizerSubclass

internal class M13CheckboxGestureRecognizer: UILongPressGestureRecognizer {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        // Set the minimium press duration to 0.0 to allow for basic taps.
        minimumPressDuration = 0.0
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        // Check whether the touch is outside of the M13Checkbox's bounds, and fail to recognize if so.
        if let anyTouch = touches.first, let view = view {
            let touchPoint = anyTouch.location(in: view)
            if !view.bounds.contains(touchPoint) {
                state = .failed
            }
        }
        
        // If `self.state` is not yet set, the superclass implementation of this method will set it as it sees fit.
        super.touchesEnded(touches, with: event)
    }
}
