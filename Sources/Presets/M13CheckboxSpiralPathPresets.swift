//
//  M13CheckboxSpiralPathPresets.swift
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

internal class M13CheckboxSpiralPathPresets: M13CheckboxPathPresets {
    
    /**
     Creates a path object for the long checkmark which is in contact with the box.
     - returns: A `UIBezierPath` representing the checkmark.
     */
    func pathForLongCheckmark() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: checkmarkShortArmEndPoint)
        path.addLine(to: checkmarkMiddlePoint)
        path.addLine(to: checkmarkLongArmBoxIntersectionPoint)
        
        return path
    }
    
    /**
     Creates a path object for the long mixed mark which is in contact with the box.
     - returns: A `UIBezierPath` representing the mixed mark.
     */
    func pathForLongMixedMark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Left point
        path.move(to: CGPoint(x: size * 0.25, y: size / 2.0))
        // Middle point
        path.addLine(to: CGPoint(x: size * 0.5, y: size / 2.0))
        // Right point
        path.addLine(to: CGPoint(x: size - boxLineWidth, y: size * 0.5))
        
        return path
    }
    
    /** 
    Creates a path object for the long radio mark.
    - returns: A `UIBezierPath` representing the radio mark.
    */
    func pathForLongRadioMark() -> UIBezierPath {
        return pathForBox()
    }
    
    final func pathForLongMark(_ state: M13Checkbox.CheckState) -> UIBezierPath {
            switch state {
            case .unchecked:
                if markType == .checkmark {
                    return pathForLongCheckmark()
                } else {
                    return pathForLongRadioMark()
                }
            case .checked:
                if markType == .checkmark {
                    return pathForLongCheckmark()
                } else {
                    return pathForLongRadioMark()
                }
            case .mixed:
                return pathForLongMixedMark()
            }
    }
    
}
