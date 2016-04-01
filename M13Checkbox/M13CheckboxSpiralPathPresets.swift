//
//  M13CheckboxSpiralPathPresets.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/1/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class M13CheckboxSpiralPathPresets: M13CheckboxPathPresets {
    
    /**
     Creates a path object for the long checkmark which is in contact with the box.
     - returns: A `UIBezierPath` representing the checkmark.
     */
    func pathForLongCheckmark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Scale up the checkmark if a square box type.
        if boxType == .Square {
            // Add the three points. Draw based on scale to draw at any size.
            path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
            path.addLineToPoint(CGPoint(x: size / 2.0, y: size / 1.57894))
            // Add last point
            path.addLineToPoint(CGPoint(x: size / 1.2053, y: size / 4.5272))
            // Scale
            path.applyTransform(CGAffineTransformMakeScale(1.5, 1.5))
            // Recenter
            path.applyTransform(CGAffineTransformMakeTranslation(-size / 4.0, -size / 4.0))
        } else {
            // Add the three points. Draw based on scale to draw at any size.
            let circleRadius: CGFloat = (size - boxLineWidth) / 2.0
            path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
            path.addLineToPoint(CGPoint(x: size / 2.0, y: size / 1.57894))
            // Add last point
            path.addLineToPoint(CGPoint(x: circleRadius * cos(CGFloat(M_PI_4)), y: circleRadius * sin(CGFloat(M_PI_4))))
        }
        
        return path
    }
    
    /**
     Creates a path object for the long mixed mark which is in contact with the box.
     - returns: A `UIBezierPath` representing the mixed mark.
     */
    func pathForLongMixedMark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Left point
        path.moveToPoint(CGPoint(x: size / 3.0, y: size / 2.0))
        // Right point
        path.addLineToPoint(CGPoint(x: size, y: size / 2.0))
        
        return path
    }
    
    /** 
    Creates a path object for the long radio mark.
    - returns: A `UIBezierPath` representing the radio mark.
    */
    func pathForLongRadioMark() -> UIBezierPath {
        return pathForBox()
    }
    
    final func pathForLongMark(state: M13Checkbox.CheckState) -> UIBezierPath {
            switch state {
            case .Unchecked:
                if markType == .Checkmark {
                    return pathForLongCheckmark()
                } else {
                    return pathForLongRadioMark()
                }
            case .Checked:
                if markType == .Checkmark {
                    return pathForLongCheckmark()
                } else {
                    return pathForLongRadioMark()
                }
            case .Mixed:
                return pathForLongMixedMark()
            }
    }
    
}
