//
//  M13CheckboxRadioPathGenerator.swift
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

internal class M13CheckboxRadioPathGenerator: M13CheckboxPathGenerator {
    
    //----------------------------
    // MARK: - Mark Generation
    //----------------------------
    
    override func pathForMark() -> UIBezierPath? {
        let transform = CGAffineTransform(scaleX: 0.665, y: 0.665)
        let translate = CGAffineTransform(translationX: size * 0.1675, y: size * 0.1675)
        let path = pathForBox()
        path?.apply(transform)
        path?.apply(translate)
        return path
    }
    
    override func pathForLongMark() -> UIBezierPath? {
        return pathForBox()
    }

    override func pathForMixedMark() -> UIBezierPath? {
        return pathForMark()
    }
    
    override func pathForLongMixedMark() -> UIBezierPath? {
        return pathForBox()
    }

    override func pathForUnselectedMark() -> UIBezierPath? {
        return nil
    }
    
    override func pathForLongUnselectedMark() -> UIBezierPath? {
        return nil
    }
}

