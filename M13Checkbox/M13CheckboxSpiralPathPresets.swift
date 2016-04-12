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
        
        path.moveToPoint(checkmarkShortArmEndPoint)
        path.addLineToPoint(checkmarkMiddlePoint)
        path.addLineToPoint(checkmarkLongArmBoxIntersectionPoint)
        
        return path
    }
    
    /**
     Creates a path object for the long mixed mark which is in contact with the box.
     - returns: A `UIBezierPath` representing the mixed mark.
     */
    func pathForLongMixedMark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Left point
        path.moveToPoint(CGPoint(x: size * 0.25, y: size * 0.5))
        // Right point
        path.addLineToPoint(CGPoint(x: size, y: size * 0.5))
        
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
