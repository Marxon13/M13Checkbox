//
//  M13CheckboxPathGenerator.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 10/6/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

/// The base class that generates the paths for the different mark types.
internal class M13CheckboxPathGenerator {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// The maximum width or height the path will be generated with.
    var size: CGFloat = 0.0
    
    /// The line width of the created checkmark.
    var checkmarkLineWidth: CGFloat = 1.0
    
    /// The line width of the created box.
    var boxLineWidth: CGFloat = 1.0
    
    /// The corner radius of the box.
    var cornerRadius: CGFloat = 3.0
    
    /// The box type to create.
    var boxType: M13Checkbox.BoxType = DefaultValues.boxType
    
    //----------------------------
    // MARK: - Box Paths
    //----------------------------
    
    /**
     Creates a path object for the box.
     - returns: A `UIBezierPath` representing the box.
     */
    final func pathForBox() -> UIBezierPath? {
        switch boxType {
        case .circle:
            return pathForCircle()
        case .square:
            return pathForRoundedRect()
        }
    }
    
    /**
     Creates a circular path for the box. The path starts at the top center point of the box.
     - returns: A `UIBezierPath` representing the box.
    */
    func pathForCircle() -> UIBezierPath? {
        let radius = (size - boxLineWidth) / 2.0
        // Create a circle that starts in the top right hand corner.
        return UIBezierPath(arcCenter: CGPoint(x: size / 2.0, y: size / 2.0),
                            radius: radius,
                            startAngle: -(CGFloat.pi / 2),
                            endAngle: CGFloat((2 * Double.pi) - (Double.pi / 2)),
                            clockwise: true)
    }
    
    /**
     Creates a rounded rect path for the box. The path starts at the top center point of the box.
     - returns: A `UIBezierPath` representing the box.
     */
    func pathForRoundedRect() -> UIBezierPath? {
        let path = UIBezierPath()
        let lineOffset: CGFloat = boxLineWidth / 2.0
        
        let trX: CGFloat = size - lineOffset - cornerRadius
        let trY: CGFloat = 0.0 + lineOffset + cornerRadius
        let tr = CGPoint(x: trX, y: trY)
        
        let brX: CGFloat = size - lineOffset - cornerRadius
        let brY: CGFloat = size - lineOffset - cornerRadius
        let br = CGPoint(x: brX, y: brY)
        
        let blX: CGFloat = 0.0 + lineOffset + cornerRadius
        let blY: CGFloat = size - lineOffset - cornerRadius
        let bl = CGPoint(x: blX, y: blY)
        
        let tlX: CGFloat = 0.0 + lineOffset + cornerRadius
        let tlY: CGFloat = 0.0 + lineOffset + cornerRadius
        let tl = CGPoint(x: tlX, y: tlY)
        
        path.move(to: CGPoint(x: (tl.x + tr.x) / 2.0, y: ((tl.y + tr.y) / 2.0) - cornerRadius))
        
        // Top side.
        let trYCr: CGFloat = tr.y - cornerRadius
        path.addLine(to: CGPoint(x: tr.x, y: trYCr))
        
        // Right arc
        if cornerRadius != 0 {
            path.addArc(withCenter: tr,
                        radius: cornerRadius,
                        startAngle: -(CGFloat.pi / 2),
                        endAngle: 0.0,
                        clockwise: true)
        }
        // Right side.
        let brXCr: CGFloat = br.x + cornerRadius
        path.addLine(to: CGPoint(x: brXCr, y: br.y))
        
        // Bottom right arc.
        if cornerRadius != 0 {
            path.addArc(withCenter: br,
                        radius: cornerRadius,
                        startAngle: 0.0,
                        endAngle: CGFloat.pi / 2,
                        clockwise: true)
        }
        // Bottom side.
        let blYCr: CGFloat = bl.y + cornerRadius
        path.addLine(to: CGPoint(x: bl.x , y: blYCr))
        // Bottom left arc.
        if cornerRadius != 0 {
            path.addArc(withCenter: bl,
                        radius: cornerRadius,
                        startAngle: CGFloat.pi / 2,
                        endAngle: CGFloat.pi,
                        clockwise: true)
        }
        
        // Left side.
        let tlXCr: CGFloat = tl.x - cornerRadius
        path.addLine(to: CGPoint(x: tlXCr, y: tl.y))
        // Top left arc.
        if cornerRadius != 0 {
            path.addArc(withCenter: tl,
                        radius: cornerRadius,
                        startAngle: CGFloat.pi,
                        endAngle: CGFloat(Double.pi + (Double.pi / 2)),
                        clockwise: true)
        }
        path.close()
        return path
    }
    
    /**
     Creates a small dot for the box.
     - returns: A `UIBezierPath` representing the dot.
     */
    func pathForDot() -> UIBezierPath? {
        let boxPath = pathForBox()
        let scale: CGFloat = 1.0 / 20.0
        boxPath?.apply(CGAffineTransform(scaleX: scale, y: scale))
        boxPath?.apply(CGAffineTransform(translationX: (size - (size * scale)) / 2.0, y: (size - (size * scale)) / 2.0))
        return boxPath
    }
    
    //----------------------------
    // MARK: - Check Generation
    //----------------------------
    
    /**
     Generates the path for the mark for the given state.
     - parameter state: The state to generate the mark path for.
     - returns: A `UIBezierPath` representing the mark.
    */
    final func pathForMark(_ state: M13Checkbox.CheckState?) -> UIBezierPath? {
        
        guard let state = state else {
            return nil
        }
        
        switch state {
        case .unchecked:
            return pathForUnselectedMark()
        case .checked:
            return pathForMark()
        case .mixed:
            return pathForMixedMark()
        }
    }
    
    /**
     Generates the path for the long mark for the given state used in the spiral animation.
     - parameter state: The state to generate the long mark path for.
     - returns: A `UIBezierPath` representing the long mark.
    */
    final func pathForLongMark(_ state: M13Checkbox.CheckState?) -> UIBezierPath? {
        
        guard let state = state else {
            return nil
        }
        
        switch state {
        case .unchecked:
            return pathForLongUnselectedMark()
        case .checked:
            return pathForLongMark()
        case .mixed:
            return pathForLongMixedMark()
        }
    }
    
    /**
     Creates a path object for the mark.
     - returns: A `UIBezierPath` representing the mark.
     */
    func pathForMark() -> UIBezierPath? {
        return nil
    }
    
    /**
     Creates a path object for the long mark.
     - returns: A `UIBezierPath` representing the long mark.
     */
    func pathForLongMark() -> UIBezierPath? {
        return nil
    }
    
    /**
     Creates a path object for the mixed mark.
     - returns: A `UIBezierPath` representing the mixed mark.
     */
    func pathForMixedMark() -> UIBezierPath? {
        return nil
    }
    
    /**
     Creates a path object for the long mixed mark.
     - returns: A `UIBezierPath` representing the long mixed mark.
     */
    func pathForLongMixedMark() -> UIBezierPath? {
        return nil
    }
    
    /**
     Creates a path object for the unselected mark.
     - returns: A `UIBezierPath` representing the unselected mark.
     */
    func pathForUnselectedMark() -> UIBezierPath? {
        return nil
    }
    
    /**
     Creates a path object for the long unselected mark.
     - returns: A `UIBezierPath` representing the long unselected mark.
     */
    func pathForLongUnselectedMark() -> UIBezierPath? {
        return nil
    }
    
}
