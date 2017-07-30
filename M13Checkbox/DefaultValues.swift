//
//  ConstantValues.swift
//  M13Checkbox
//
//  Created by Andrea Antonioni on 30/07/17.
//  Copyright © 2017 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

// A set of default values used to initialize the object
struct DefaultValues {
    
    static let animation: M13Checkbox.Animation = .stroke
    static let markType: M13Checkbox.MarkType = .checkmark
    static let boxType: M13Checkbox.BoxType = .circle
    static let checkState: M13Checkbox.CheckState = .unchecked
    static let controller: M13CheckboxController = M13CheckboxStrokeController()
    
}
