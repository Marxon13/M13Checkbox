//
//  M13CheckboxAddRemovePathGenerator.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 10/7/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

internal class M13CheckboxAddRemovePathGenerator: M13CheckboxPathGenerator {
    
    //----------------------------
    // MARK: - Box Paths
    //----------------------------
    
    override func pathForCircle() -> UIBezierPath? {
        let radius = (size - boxLineWidth) / 2.0
        // Create a circle that starts in the middle left.
        return UIBezierPath(arcCenter: CGPoint(x: size / 2.0, y: size / 2.0),
                            radius: radius,
                            startAngle: -CGFloat.pi,
                            endAngle: CGFloat((2 * Double.pi) - Double.pi),
                            clockwise: true)
    }
    
    override func pathForRoundedRect() -> UIBezierPath? {
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
        
        path.move(to: CGPoint(x: ((tl.x + bl.x) / 2.0) - cornerRadius, y: (tl.y + bl.y) / 2.0))
        
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
        
        path.close()
        return path
    }
    
    //----------------------------
    // MARK: - Mark Generation
    //----------------------------
    
    override func pathForMark() -> UIBezierPath? {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: size * 0.75, y: size * 0.5))
        path.addLine(to: CGPoint(x: size * 0.25, y: size * 0.5))
        
        path.move(to: CGPoint(x: size / 2.0, y: size * 0.5))
        path.addLine(to: CGPoint(x: size / 2.0, y: size * 0.5))
        
        return path
    }
    
    override func pathForLongMark() -> UIBezierPath? {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: size * 0.75, y: size * 0.5))
        path.addLine(to: CGPoint(x: size * 0.25, y: size * 0.5))
        
        path.move(to: CGPoint(x: size / 2.0, y: size * 0.5))
        path.addLine(to: CGPoint(x: size / 2.0, y: size * 0.5))
        
        return path
    }
    
    override func pathForMixedMark() -> UIBezierPath? {
        return pathForUnselectedMark()
    }
    
    override func pathForLongMixedMark() -> UIBezierPath? {
        return pathForLongUnselectedMark()
    }
    
    override func pathForUnselectedMark() -> UIBezierPath? {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: size * 0.75, y: size * 0.5))
        path.addLine(to: CGPoint(x: size * 0.25, y: size * 0.5))
        
        path.move(to: CGPoint(x: size / 2.0, y: size * 0.25))
        path.addLine(to: CGPoint(x: size / 2.0, y: size * 0.75))
        
        return path
    }
    
    override func pathForLongUnselectedMark() -> UIBezierPath? {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: size * 0.75, y: size * 0.5))
        path.addLine(to: CGPoint(x: boxLineWidth, y: size * 0.5))
        
        path.move(to: CGPoint(x: size / 2.0, y: size * 0.25))
        path.addLine(to: CGPoint(x: size / 2.0, y: size * 0.75))
        
        return path
    }
}

