//
//  M13CheckboxPathManager.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/27/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit



internal class M13CheckboxPathPresets {
    
    //----------------------------
    // MARK: - Structures
    //----------------------------
    
    /// Contains the geometry information needed to generate the checkmark, as well as generates the locations of the feature points.
    struct CheckmarkProperties {
        
        /// The angle between the x-axis, and the line created between the origin, and the location where the extended long arm of the checkmark meets the box. (Diagram: Θ)
        var longArmBoxIntersectionAngle: CGFloat = 45.0 * CGFloat(M_PI / 180.0)
        
        /// The distance from the center the long arm of the checkmark draws to, as a percentage of size. (Diagram: S)
        var longArmRadius: (circle: CGFloat, box: CGFloat) = (circle: 0.22, box: 0.33)
        
        /// The distance from the center of the middle/bottom point of the checkbox, as a percentage of size. (Diagram: T)
        var middlePointRadius: (circle: CGFloat, box: CGFloat) = (circle: 0.133, box: 0.1995)
        
        /// The distance between the horizontal center and the middle point of the checkbox.
        var middlePointOffset: (circle: CGFloat, box: CGFloat) = (circle: -0.04, box: -0.06)
        
        /// The distance from the center of the left most point of the checkmark, as a percentage of size.
        var shortArmRadius: (circle: CGFloat, box: CGFloat) = (circle: 0.17, box: 0.255)
        
        /// The distance between the vertical center and the left most point of the checkmark, as a percentage of size.
        var shortArmOffset: (circle: CGFloat, box: CGFloat) = (circle: 0.02, box: 0.03)
    }
    
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
    
    /// The parameters that define the checkmark.
    var checkmarkProperties: CheckmarkProperties = CheckmarkProperties()
    
    //----------------------------
    // MARK: - Points of Intrest
    //----------------------------
    
    /// The intersection point between the extended long checkmark arm, and the box.
    var checkmarkLongArmBoxIntersectionPoint: CGPoint {
        
        let radius = (size - boxLineWidth) / 2.0
        let theta = checkmarkProperties.longArmBoxIntersectionAngle
        
        if boxType == .Circle {
            // Basic trig to get the location of the point on the circle.
            return CGPoint(x: (size / 2.0) + (radius * cos(theta)), y: (size / 2.0) - (radius * sin(theta)))
        } else {
            // We need to differentiate between the box edges and the rounded corner.
            let lineOffset = boxLineWidth / 2.0
            let circleOrigin = CGPoint(x: size - lineOffset - cornerRadius, y: 0.0 + lineOffset + cornerRadius)
            let edgeX = (size / 2.0) + (0.5 * (size - boxLineWidth) * (1.0 / tan(theta)))
            let edgeY = (size / 2.0) - (0.5 * (size - boxLineWidth) * tan(theta));
            
            if edgeX <= circleOrigin.x {
                // On the top edge.
                return CGPoint(x: edgeX, y: lineOffset)
            } else if edgeY >= circleOrigin.y {
                // On the right edge.
                return CGPoint(x: size - lineOffset, y: edgeY)
            } else {
                // On the corner
                let a = size * (3.0 + cos(2.0 * theta) + sin(2.0 * theta))
                let b = -2.0 * cornerRadius * (cos(theta) + sin(theta))
                let c = (((4.0 * cornerRadius) - size) * size) + (pow((-2.0 * cornerRadius) + size, 2.0) * sin(2.0 * theta))
                let d = size * cos(theta) * (cos(theta) - sin(theta))
                let e = 2.0 * cornerRadius * sin(theta) * (cos(theta) + sin(theta))
                
                let x = 0.25 * (a + (2.0 * (b + sqrt(c)) * cos(theta)))
                let y = 0.50 * (d + e - (sqrt(c) * sin(theta)))
                
                return CGPoint(x: x, y: y)
            }
        }
    }
    
    var checkmarkLongArmEndPoint: CGPoint {
        // Known variables
        let boxEndPoint = checkmarkLongArmBoxIntersectionPoint
        let x2 = boxEndPoint.x
        let y2 = boxEndPoint.y
        let midPoint = checkmarkMiddlePoint
        let x1 = midPoint.x
        let y1 = midPoint.y
        let r = boxType == .Circle ? size * checkmarkProperties.longArmRadius.circle : size * checkmarkProperties.longArmRadius.box
        
        let a1 = (size * pow(x1, 2.0)) - (2.0 * size * x1 * x2) + (size * pow(x2, 2.0)) + (size * x1 * y1) - (size * x2 * y1)
        let a2 = (2.0 * x2 * pow(y1, 2.0)) - (size * x1 * y2) + (size * x2 * y2) - (2.0 * x1 * y1 * y2) - (2.0 * x2 * y1 * y2) + (2.0 * x1 * pow(y2, 2.0))
        let b = -16.0 * (pow(x1, 2.0) - (2.0 * x1 * x2) + pow(x2, 2.0) + pow(y1, 2.0) - (2.0 * y1 * y2) + pow(y2, 2.0))
        let c1 = pow(r, 2.0) * ((-pow(x1, 2.0)) + (2.0 * x1 * x2) - pow(x2, 2.0))
        let c2 = pow(size, 2.0) * ((0.5 * pow(x1, 2.0)) - (x1 * x2) + (0.5 * pow(x2, 2.0)))
        let d1 = (pow(x2, 2.0) * pow(y1, 2.0)) - (2.0 * x1 * x2 * y1 * y2) + (pow(x1, 2.0) * pow(y2, 2.0))
        let d2 = size * ((x1 * x2 * y1) - (pow(x2, 2.0) * y1) - (pow(x1, 2.0) * y2) + (x1 * x2 * y2))
        let cd = c1 + c2 + d1 + d2
        let e1 = (x1 * ((4.0 * y1) - (4.0 * y2)) * y2) + (x2 * y1 * ((-4.0 * y1) + (4.0 * y2)))
        let e2 = size * ((-2.0 * pow(x1, 2.0)) + (x2 * ((-2.0 * x2) + (2.0 * y1) - (2.0 * y2))) + (x1 * (4.0 * x2 - (2.0 * y1) + (2.0 * y2))))
        let f = pow(x1, 2.0) - (2.0 * x1 * x2) + pow(x2, 2.0) + pow(y1, 2.0) - (2.0 * y1 * y2) + pow(y2, 2)
        let g1 = (0.5 * size * x1 * y1) - (0.5 * size * x2 * y1) - (x1 * x2 * y1) + (pow(x2, 2.0) * y1) + (0.5 * size * pow(y1, 2.0))
        let g2 = (-0.5 * size * x1 * y2) + (pow(x1, 2.0) * y2) + (0.5 * size * x2 * y2) - (x1 * x2 * y2) - (size * y1 * y2) + (0.5 * size * pow(y2, 2.0))
        let h1 = (-4.0 * pow(x2, 2.0) * y1) - (4.0 * pow(x1, 2.0) * y2) + (x1 * x2 * ((4.0 * y1) + (4.0 * y2)))
        let h2 = size * ((-2.0 * x1 * y1) + (2.0 * x2 * y1) - (2.0 * pow(y1, 2.0)) + (2.0 * x1 * y2) - (2.0 * x2 * y2) + (4.0 * y1 * y2) - (2.0 * pow(y2, 2.0)))
        let i = (pow(r, 2.0) * (-pow(y1, 2.0) + (2.0 * y1 * y2) - pow(y2, 2.0))) + (pow(size, 2.0) * ((0.5 * pow(y1, 2.0)) - (y1 * y2) + (0.5 * pow(y2, 2.0))))
        let j = size * ((x1 * (y1 - y2) * y2) + (x2 * y1 * (-y1 + y2)))
        
        let x = (0.5 * (a1 + a2 + (0.5 * sqrt((b * cd) + pow(e1 + e2, 2.0))))) / f
        let y = (g1 + g2 - (0.25 * sqrt(pow(h1 + h2, 2.0) + (b * (d1 + i + j))))) / f
        
        return CGPoint(x: x, y: y)
    }
    
    var checkmarkMiddlePoint: CGPoint {
        let r = boxType == .Circle ? checkmarkProperties.middlePointRadius.circle : checkmarkProperties.middlePointRadius.box
        let o = boxType == .Circle ? checkmarkProperties.middlePointOffset.circle : checkmarkProperties.middlePointOffset.box
        return CGPointMake((size / 2.0) + (size * o), (size / 2.0 ) + (size * r))
    }
    
    var checkmarkShortArmEndPoint: CGPoint {
        let r = boxType == .Circle ? checkmarkProperties.shortArmRadius.circle : checkmarkProperties.shortArmRadius.box
        let o = boxType == .Circle ? checkmarkProperties.shortArmOffset.circle : checkmarkProperties.shortArmOffset.box
        return CGPointMake((size / 2.0) - (size * r), (size / 2.0) + (size * o))
    }
    
    //----------------------------
    // MARK: - Paths
    //----------------------------
    
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
                            startAngle: -checkmarkProperties.longArmBoxIntersectionAngle,
                            endAngle: CGFloat(2 * M_PI) - checkmarkProperties.longArmBoxIntersectionAngle,
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
        
        path.moveToPoint(checkmarkShortArmEndPoint)
        path.addLineToPoint(checkmarkMiddlePoint)
        path.addLineToPoint(checkmarkLongArmEndPoint)
        
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
        path.moveToPoint(CGPoint(x: size * 0.25, y: size / 2.0))
        // Middle point
        path.addLineToPoint(CGPoint(x: size * 0.5, y: size / 2.0))
        // Right point
        path.addLineToPoint(CGPoint(x: size * 0.75, y: size / 2.0))
        
        return path
    }
    
    func pathForMixedRadio() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: size * 0.25, y: size / 2.0))
        path.addLineToPoint(CGPoint(x: size * 0.75, y: size / 2.0))
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