//
//  M13CheckboxGestureRecognizer.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/12/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class M13CheckboxGestureRecognizer: UILongPressGestureRecognizer {
    
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        // Set the minimium press duration to 0.0 to allow for basic taps.
        minimumPressDuration = 0.0
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        // Check whether the touch is outside of the M13Checkbox's bounds, and fail to recognize if so.
        if let anyTouch = touches.first, let view = view {
            let touchPoint = anyTouch.locationInView(view)
            if !CGRectContainsPoint(view.bounds, touchPoint) {
                state = .Failed
            }
        }
        
        // If `self.state` is not yet set, the superclass implementation of this method will set it as it sees fit.
        super.touchesEnded(touches, withEvent: event)
    }
}
