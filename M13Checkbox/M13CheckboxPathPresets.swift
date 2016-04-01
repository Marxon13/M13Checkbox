//
//  M13CheckboxPathManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/27/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class M13CheckboxPathPresets {
    
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
    var boxType: M13Checkbox.BoxType = .Circle
    
    /// The type of checkmark to create.
    var markType: M13Checkbox.MarkType = .Checkmark
    
    /**
     Creates a path object for the box.
     - returns: A `UIBezierPath` representing the box.
     */
    final func pathForBox() -> UIBezierPath {
        switch boxType {
        case .Circle:
            return pathForCircle()
        case .Square:
            return pathForRoundedRect()
        }
    }
    
    func pathForCircle() -> UIBezierPath {
        let radius = (size - boxLineWidth) / 2.0
        // Create a circle that starts in the top right hand corner.
        return UIBezierPath(arcCenter: CGPointMake(radius, radius),
                            radius: radius,
                            startAngle: CGFloat(-M_PI_4),
                            endAngle: CGFloat((2 * M_PI) - M_PI_4),
                            clockwise: true)
    }
    
    func pathForRoundedRect() -> UIBezierPath {
        let path = UIBezierPath()
        let lineOffset = boxLineWidth / 2.0
        let tr = CGPoint(x: size - lineOffset - cornerRadius, y: 0.0 + lineOffset + cornerRadius)
        let br = CGPoint(x: size - lineOffset - cornerRadius, y: size - lineOffset - cornerRadius)
        let bl = CGPoint(x: 0.0 + lineOffset + cornerRadius, y: size - lineOffset - cornerRadius)
        let tl = CGPoint(x: 0.0 + lineOffset + cornerRadius, y: 0.0 + lineOffset + cornerRadius)
        
        // Start in the top right corner.
        let offset: CGFloat = ((cornerRadius * sqrt(2)) / 2.0)
        path.moveToPoint(CGPoint(x: tr.x + offset, y: tr.y - offset))
        // Bottom of top right arc.12124
        if cornerRadius != 0 {
            path.addArcWithCenter(tr,
                                  radius: cornerRadius,
                                  startAngle: CGFloat(-M_PI_4),
                                  endAngle: 0.0,
                                  clockwise: true)
        }
        // Right side.
        path.addLineToPoint(CGPoint(x: br.x + cornerRadius, y: br.y))
        
        // Bottom right arc.
        if cornerRadius != 0 {
            path.addArcWithCenter(br,
                                  radius: cornerRadius,
                                  startAngle: 0.0,
                                  endAngle: CGFloat(M_PI_2),
                                  clockwise: true)
        }
        // Bottom side.
        path.addLineToPoint(CGPoint(x: bl.x , y: bl.y + cornerRadius))
        // Bottom left arc.
        if cornerRadius != 0 {
            path.addArcWithCenter(bl,
                                  radius: cornerRadius,
                                  startAngle: CGFloat(M_PI_2),
                                  endAngle: CGFloat(M_PI),
                                  clockwise: true)
        }
        // Left side.
        path.addLineToPoint(CGPoint(x: tl.x - cornerRadius, y: tl.y))
        // Top left arc.
        if cornerRadius != 0 {
            path.addArcWithCenter(tl,
                                  radius: cornerRadius,
                                  startAngle: CGFloat(M_PI),
                                  endAngle: CGFloat(M_PI + M_PI_2),
                                  clockwise: true)
        }
        // Top side.
        path.addLineToPoint(CGPoint(x: tr.x, y: tr.y - cornerRadius))
        // Top of top right arc
        if cornerRadius != 0 {
            path.addArcWithCenter(tr,
                                  radius: cornerRadius,
                                  startAngle: CGFloat(M_PI + M_PI_2),
                                  endAngle: CGFloat(M_PI + M_PI_2 + M_PI_4),
                                  clockwise: true)
        }
        path.closePath()
        return path
    }
    
    //----------------------------
    // MARK: - Check Generation
    //----------------------------
    
    final func path(state: M13Checkbox.CheckState) -> UIBezierPath? {
        switch state {
        case .Unchecked:
            return pathForUnselectedMark()
        case .Checked:
            return pathForMark()
        case .Mixed:
            return pathForMixedMark()
        }
    }
    
    final func pathForMark() -> UIBezierPath {
        switch markType {
        case .Checkmark:
            return pathForCheckmark()
        case .Radio:
            return pathForRadio()
        }
    }
    
    /**
     Creates a path object for the checkmark.
     - returns: A `UIBezierPath` representing the checkmark.
     */
    func pathForCheckmark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Scale up the checkmark if a square box type.
        if boxType == .Square {
            // Add the three points. Draw based on scale to draw at any size.
            path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
            path.addLineToPoint(CGPoint(x: size / 2.0618, y: size / 1.57894))
            path.addLineToPoint(CGPoint(x: size / 1.3953, y: size / 2.7272))
            // Scale
            path.applyTransform(CGAffineTransformMakeScale(1.5, 1.5))
            // Recenter
            path.applyTransform(CGAffineTransformMakeTranslation(-size / 4.0, -size / 4.0))
        } else {
            // Add the three points. Draw based on scale to draw at any size.
            path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
            path.addLineToPoint(CGPoint(x: size / 2.0618, y: size / 1.57894))
            path.addLineToPoint(CGPoint(x: size / 1.3953, y: size / 2.7272))
            
            print(size)
            print("A: ", CGPoint(x: size / 3.1578, y: size / 2.0), " B: ", CGPoint(x: size / 2.0618, y: size / 1.57894), " C: ", CGPoint(x: size / 1.3953, y: size / 2.7272))
        }
        
        return path
    }
    
    func pathForRadio() -> UIBezierPath {
        let transform = CGAffineTransformMakeScale(0.665, 0.665)
        let translate = CGAffineTransformMakeTranslation(size * 0.1675, size * 0.1675)
        let path = pathForBox()
        path.applyTransform(transform)
        path.applyTransform(translate)
        return path
    }
    
    //----------------------------
    // MARK: - Mixed Mark Generation
    //----------------------------
    
    /**
     Creates a path object for the mixed mark.
     - returns: A `UIBezierPath` representing the mixed mark.
     */
    final func pathForMixedMark() -> UIBezierPath {
        switch markType {
        case .Checkmark:
            return pathForMixedCheckmark()
        case .Radio:
            return pathForMixedRadio()
        }
    }
    
    func pathForMixedCheckmark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Left point
        path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
        // Middle point
        path.addLineToPoint(CGPoint(x: size / 2.0, y: size / 2.0))
        // Right point
        path.addLineToPoint(CGPoint(x: size / 1.3953, y: size / 2.0))
        
        return path
    }
    
    func pathForMixedRadio() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
        path.addLineToPoint(CGPoint(x: size / 1.3953, y: size / 2.0))
        path.bezierPathByReversingPath()
        return path
    }
    
    //----------------------------
    // MARK: - Unselected Mark Generation
    //----------------------------
    
    /**
     Creates a path object for the mixed mark.
     - returns: A `UIBezierPath` representing the mixed mark.
     */
    final func pathForUnselectedMark() -> UIBezierPath? {
        switch markType {
        case .Checkmark:
            return pathForUnselectedCheckmark()
        case .Radio:
            return pathForUnselectedRadio()
        }
    }
    
    func pathForUnselectedCheckmark() -> UIBezierPath? {
        return pathForCheckmark()
    }
    
    func pathForUnselectedRadio() -> UIBezierPath? {
        return pathForRadio()
    }
}