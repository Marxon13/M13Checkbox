//
//  M13CheckboxPathManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 2/24/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

/// Generates the paths needed by `M13Checkbox`
internal class M13CheckboxPathManager {
    
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
    
    //----------------------------
    // MARK: - Generation
    //----------------------------
    
    /**
    Creates a path object for the box.
    - returns: A `UIBezierPath` representing the box.
    */
    func pathForBox() -> UIBezierPath {
        switch boxType {
        case .Circle:
            let radius = size / 2.0
            // Create a circle that starts in the top right hand corner.
            return UIBezierPath(arcCenter: CGPointMake(radius, radius),
                radius: radius - (boxLineWidth / 2.0),
                startAngle: CGFloat(-M_PI_4),
                endAngle: CGFloat((2 * M_PI) - M_PI_4),
                clockwise: true)
        case .Square:
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
    }
    
    /**
     Creates a small dot.
     - returns: A `UIBezierPath` representing the dot.
     */
    func pathForDot() -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPointMake(size / 2.0, size / 2.0),
            radius: size / 20.0,
            startAngle: 0.0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true)
    }
    
    func pathForMark() -> UIBezierPath {
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
    private func pathForCheckmark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Add the three points. Draw based on scale to draw at any size.
        path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
        path.addLineToPoint(CGPoint(x: size / 2.0618, y: size / 1.57894))
        path.addLineToPoint(CGPoint(x: size / 1.3953, y: size / 2.7272))
        
        // Scale up the checkmark if a square box type.
        if boxType == .Square {
            // Scale
            path.applyTransform(CGAffineTransformMakeScale(1.5, 1.5))
            // Recenter
            path.applyTransform(CGAffineTransformMakeTranslation(-size / 4.0, -size / 4.0))
        }
        
        return path
    }
    
    private func pathForRadio() -> UIBezierPath {
        let transform = CGAffineTransformMakeScale(0.665, 0.665)
        let translate = CGAffineTransformMakeTranslation(size * 0.1675, size * 0.1675)
        let path = pathForBox()
        path.applyTransform(transform)
        path.applyTransform(translate)
        return path
    }
    
    /**
     Creates a path object for the long checkmark which is in contact with the box.
     - returns: A `UIBezierPath` representing the checkmark.
     */
    func pathForLongCheckmark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Add the three points. Draw based on scale to draw at any size.
        path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
        path.addLineToPoint(CGPoint(x: size / 2.0618, y: size / 1.57894))
        
        // Scale up the checkmark if a square box type.
        if boxType == .Square {
            // Add last point
            path.addLineToPoint(CGPoint(x: size / 1.2053, y: size / 4.5272))
            // Scale
            path.applyTransform(CGAffineTransformMakeScale(1.5, 1.5))
            // Recenter
            path.applyTransform(CGAffineTransformMakeTranslation(-size / 4.0, -size / 4.0))
        } else {
            // Add last point
            path.addLineToPoint(CGPoint(x: size / 1.1553, y: size / 5.9272))
        }
        
        return path
    }
    
    /**
     Creates a path object for the mixed mark.
     - returns: A `UIBezierPath` representing the mixed mark.
     */
    func pathForMixedMark() -> UIBezierPath {
        switch markType {
        case .Checkmark:
            return pathForMixedCheckmark()
        case .Radio:
            return pathForMixedRadio()
        }
    }
    
    private func pathForMixedCheckmark() -> UIBezierPath {
        let path = UIBezierPath()
        
        // Left point
        path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
        // Middle point
        path.addLineToPoint(CGPoint(x: size / 2.0618, y: size / 2.0))
        // Right point
        path.addLineToPoint(CGPoint(x: size / 1.3953, y: size / 2.0))
        
        return path
    }
    
    private func pathForMixedRadio() -> UIBezierPath {
        /*let radius = size / 3.0
        
        let path = UIBezierPath(arcCenter: CGPoint(x: size - radius - (checkmarkLineWidth / 2.0), y: size / 2.0),
            radius: checkmarkLineWidth / 2.0,
            startAngle: CGFloat(-M_PI_2),
            endAngle: CGFloat(M_PI_2),
            clockwise: true)
        path.addLineToPoint(CGPoint(x: radius + (checkmarkLineWidth / 2.0), y: (size / 2.0) + (checkmarkLineWidth / 2.0)))
        path.addArcWithCenter(CGPoint(x: radius + (checkmarkLineWidth / 2.0), y: size / 2.0), radius: checkmarkLineWidth / 2.0, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI + M_PI_2), clockwise: true)
        path.closePath()*/
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: size / 3.1578, y: size / 2.0))
        path.addLineToPoint(CGPoint(x: size / 1.3953, y: size / 2.0))
        path.bezierPathByReversingPath()
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
    
}
