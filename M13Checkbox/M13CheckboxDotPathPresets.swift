//
//  M13CheckboxDotPathPresets.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/1/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class M13CheckboxDotPathPresets: M13CheckboxPathPresets {
    
    /**
     Creates a small dot.
     - returns: A `UIBezierPath` representing the dot.
     */
    func pathForDot() -> UIBezierPath {
        let boxPath = pathForBox()
        let scale: CGFloat = 1.0 / 20.0
        boxPath.applyTransform(CGAffineTransformMakeScale(scale, scale))
        boxPath.applyTransform(CGAffineTransformMakeTranslation((size - (size * scale)) / 2.0, (size - (size * scale)) / 2.0))
        return boxPath
    }
    
}
