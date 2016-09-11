//
//  M13Checkbox.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 2/23/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

/// A customizable checkbox control for iOS.
@IBDesignable
public class M13Checkbox: UIControl {
    
    //----------------------------
    // MARK: - Constants
    //----------------------------
    
    /**
    The possible states the check can be in.
    
    - Unchecked: No check is shown.
    - Checked: A checkmark is shown.
    - Mixed: A dash is shown.
    */
    public enum CheckState: String, RawRepresentable {
        /// No check is shown.
        case unchecked = "Unchecked"
        /// A checkmark is shown.
        case checked = "Checked"
        /// A dash is shown.
        case mixed = "Mixed"
    }
    
    /**
     The possible shapes of the box.
     
     - Square: The box is square with optional rounded corners.
     - Circle: The box is a circle.
     */
    public enum BoxType: String, RawRepresentable {
        /// The box is a circle.
        case circle = "Circle"
        /// The box is square with optional rounded corners.
        case square = "Square"
    }
    
    /**
     The possible shapes of the mark.
     
     - Checkmark: The mark is a standard checkmark.
     - Radio: The mark is a radio style fill.
     */
    public enum MarkType: String, RawRepresentable {
        /// The mark is a standard checkmark.
        case checkmark = "Checkmark"
        /// The mark is a radio style fill.
        case radio = "Radio"
    }
    
    /**
     The possible animations for switching to and from the unchecked state.
     */
    public enum Animation: RawRepresentable, Hashable {
        /// Animates the stroke of the box and the check as if they were drawn.
        case stroke
        /// Animates the checkbox with a bouncey fill effect.
        case fill
        /// Animates the check mark with a bouncy effect.
        case bounce(AnimationStyle)
        /// Animates the checkmark and fills the box with a bouncy effect.
        case expand(AnimationStyle)
        /// Morphs the checkmark from a line.
        case flat(AnimationStyle)
        /// Animates the box and check as if they were drawn in one continuous line.
        case spiral
        /// Fades checkmark in or out. (opacity).
        case fade(AnimationStyle)
        /// Start the box as a dot, and expand the box.
        case dot(AnimationStyle)
        
        public init?(rawValue: String) {
            // Map the integer values to the animation types.
            // This is only for interface builder support. I would like this to be removed eventually.
            switch rawValue {
            case "Stroke":
                self = .stroke
                break
            case "Fill":
                self = .fill
                break
            case "BounceStroke":
                self = .bounce(.stroke)
                break
            case "BounceFill":
                self = .bounce(.fill)
                break
            case "ExpandStroke":
                self = .expand(.stroke)
                break
            case "ExpandFill":
                self = .expand(.fill)
                break
            case "FlatStroke":
                self = .flat(.stroke)
                break
            case "FlatFill":
                self = .flat(.fill)
                break
            case "Spiral":
                self = .spiral
                break
            case "FadeStroke":
                self = .fade(.stroke)
                break
            case "FadeFill":
                self = .fade(.fill)
                break
            case "DotStroke":
                self = .dot(.stroke)
                break
            case "DotFill":
                self = .dot(.fill)
                break
            default:
                return nil
            }
        }
        
        public var rawValue: String {
            // Map the animation types to integer values.
            // This is only for interface builder support. I would like this to be removed eventually.
            switch self {
            case .stroke:
                return "Stroke"
            case .fill:
                return "Fill"
            case let .bounce(style):
                switch style {
                case .stroke:
                    return "BounceStroke"
                case .fill:
                    return "BounceFill"
                }
            case let .expand(style):
                switch style {
                case .stroke:
                    return "ExpandStroke"
                case .fill:
                    return "ExpandFill"
                }
            case let .flat(style):
                switch style {
                case .stroke:
                    return "FlatStroke"
                case .fill:
                    return "FlatFill"
                }
            case .spiral:
                return "Spiral"
            case let .fade(style):
                switch style {
                case .stroke:
                    return "FadeStroke"
                case .fill:
                    return "FadeFill"
                }
            case let .dot(style):
                switch style {
                case .stroke:
                    return "DotStroke"
                case .fill:
                    return "DotFill"
                }
            }
        }
        
        /// The manager for the specific animation type.
        fileprivate var manager: M13CheckboxManager {
            switch self {
            case .stroke:
                return M13CheckboxStrokeManager()
            case .fill:
                return M13CheckboxFillManager()
            case let .bounce(style):
                return M13CheckboxBounceManager(style: style)
            case let .expand(style):
                return M13CheckboxExpandManager(style: style)
            case let .flat(style):
                return M13CheckboxFlatManager(style: style)
            case .spiral:
                return M13CheckboxSpiralManager()
            case let .fade(style):
                return M13CheckboxFadeManager(style: style)
            case let .dot(style):
                return M13CheckboxDotManager(style: style)
            }
        }
        
        public var hashValue: Int {
            return self.rawValue.hashValue
        }
    }
    
    /**
     The possible animation styles.
     - Note: Not all animations support all styles.
     */
    public enum AnimationStyle: String {
        // The animation will focus on the stroke.
        case stroke = "Stroke"
        // The animation will focus on the fill.
        case fill = "Fill"
    }
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// The manager that manages display and animations of the checkbox.
    /// The default animation is a stroke.
    fileprivate var manager: M13CheckboxManager = M13CheckboxStrokeManager()
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    /// The setup shared between initalizers.
    fileprivate func sharedSetup() {
        // Set up the inital state.
        for aLayer in manager.layersToDisplay {
            layer.addSublayer(aLayer)
        }
        manager.tintColor = tintColor
        manager.resetLayersForState(.unchecked)
        
        let longPressGesture = M13CheckboxGestureRecognizer(target: self, action: #selector(M13Checkbox.handleLongPress(_:)))
        addGestureRecognizer(longPressGesture)
    }
    
    //----------------------------
    // MARK: - Values
    //----------------------------
    
    /// The object to return from `value` when the checkbox is checked.
    public var checkedValue: Any?
    
    /// The object to return from `value` when the checkbox is unchecked.
    public var uncheckedValue: Any?
    
    /// The object to return from `value` when the checkbox is mixed.
    public var mixedValue: Any?
    
    /**
     Returns one of the three "value" properties depending on the checkbox state.
     - returns: The value coresponding to the checkbox state.
     - note: This is a convenience method so that if one has a large group of checkboxes, it is not necessary to write: if (someCheckbox == thatCheckbox) { if (someCheckbox.checkState == ...
     */
    public var value: Any? {
        switch checkState {
        case .unchecked:
            return uncheckedValue
        case .checked:
            return checkedValue
        case .mixed:
            return mixedValue
        }
    }
    
    //----------------------------
    // MARK: - State
    //----------------------------
    
    /// The current state of the checkbox.
    public var checkState: CheckState {
        get {
            return manager.state
        }
        set {
            setCheckState(newValue, animated: false)
        }
    }
    
    /**
     Change the check state.
     - parameter checkState: The new state of the checkbox.
     - parameter animated: Whether or not to animate the change.
     */
    public func setCheckState(_ newState: CheckState, animated: Bool) {
        if checkState == newState {
            return
        }
        
        if animated {
            manager.animate(checkState, toState: newState)
        } else {
            manager.resetLayersForState(newState)
        }
    }
    
    /**
     Toggle the check state between unchecked and checked.
     - parameter animated: Whether or not to animate the change. Defaults to false.
     - note: If the checkbox is mixed, it will return to the unchecked state.
     */
    public func toggleCheckState(_ animated: Bool = false) {
        switch checkState {
        case .checked:
            setCheckState(.unchecked, animated: animated)
            break
        case .unchecked:
            setCheckState(.checked, animated: animated)
            break
        case .mixed:
            setCheckState(.unchecked, animated: animated)
            break
        }
    }
    
    //----------------------------
    // MARK: - Animations
    //----------------------------
    
    /// The duration of the animation that occurs when the checkbox switches states. The default is 0.3 seconds.
    @IBInspectable public var animationDuration: TimeInterval {
        get {
            return manager.animations.animationDuration
        }
        set {
            manager.animations.animationDuration = newValue
        }
    }
    
    /// The type of animation to preform when changing from the unchecked state to any other state.
    public var stateChangeAnimation: Animation = .stroke {
        didSet {
            
            // Remove the sublayers
            if let layers = layer.sublayers {
                for sublayer in layers {
                    sublayer.removeAllAnimations()
                    sublayer.removeFromSuperlayer()
                }
            }
            
            // Set the manager
            let newManager = stateChangeAnimation.manager
            
            newManager.tintColor = tintColor
            newManager.secondaryTintColor = secondaryTintColor
            newManager.secondaryCheckmarkTintColor = secondaryCheckmarkTintColor
            newManager.hideBox = hideBox
            
            newManager.paths.boxLineWidth = manager.paths.boxLineWidth
            newManager.paths.boxType = manager.paths.boxType
            newManager.paths.checkmarkLineWidth = manager.paths.checkmarkLineWidth
            newManager.paths.cornerRadius = manager.paths.cornerRadius
            newManager.paths.markType = manager.paths.markType
            
            newManager.animations.animationDuration = manager.animations.animationDuration
            
            // Set up the inital state.
            for aLayer in newManager.layersToDisplay {
                layer.addSublayer(aLayer)
            }
            
            // Layout and reset
            newManager.resetLayersForState(checkState)
            manager = newManager
            
            // TODO: - Add support for missing animations.
            if markType == .radio && stateChangeAnimation == .spiral {
                stateChangeAnimation = .stroke
                print("WARNING: The spiral animation is currently unsupported with a radio mark.")
            }
        }
    }
    
    //----------------------------
    // MARK: - UIControl
    //----------------------------
    
    func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            isSelected = true
        } else {
            isSelected = false
            if sender.state == .ended {
                toggleCheckState(true)
                sendActions(for: .valueChanged)
            }
        }
    }
    
    //----------------------------
    // MARK: - Appearance
    //----------------------------
    
    /// The color of the checkbox's tint color when not in the unselected state. The tint color is is the main color used when not in the unselected state.
    @IBInspectable public var secondaryTintColor: UIColor? {
        get {
            return manager.secondaryTintColor
        }
        set {
            manager.secondaryTintColor = newValue
        }
    }
    
    /// The color of the checkmark when it is displayed against a filled background.
    @IBInspectable public var secondaryCheckmarkTintColor: UIColor? {
        get {
            return manager.secondaryCheckmarkTintColor
        }
        set {
            manager.secondaryCheckmarkTintColor = newValue
        }
    }
    
    /// The stroke width of the checkmark.
    @IBInspectable public var checkmarkLineWidth: CGFloat {
        get {
            return manager.paths.checkmarkLineWidth
        }
        set {
            manager.paths.checkmarkLineWidth = newValue
            manager.resetLayersForState(checkState)
        }
    }
    
    // The type of mark to display.
    @IBInspectable public var markType: MarkType {
        get {
            return manager.paths.markType
        }
        set {
            manager.paths.markType = newValue
            
            // TODO: - Add support for missing animations.
            if markType == .radio && stateChangeAnimation == .spiral {
                manager.paths.markType = .checkmark
                print("WARNING: The spiral animation is currently unsupported with a radio mark.")
            }
            
            manager.resetLayersForState(checkState)
            setNeedsLayout()
        }
    }
    
    /// The stroke width of the box.
    @IBInspectable public var boxLineWidth: CGFloat {
        get {
            return manager.paths.boxLineWidth
        }
        set {
            manager.paths.boxLineWidth = newValue
            manager.resetLayersForState(checkState)
        }
    }
    
    /// The corner radius of the box if the box type is square.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return manager.paths.cornerRadius
        }
        set {
            manager.paths.cornerRadius = newValue
            setNeedsLayout()
        }
    }
    
    /// The shape of the checkbox.
    public var boxType: BoxType {
        get {
            return manager.paths.boxType
        }
        set {
            manager.paths.boxType = newValue
            setNeedsLayout()
        }
    }
    
    /// Wether or not to hide the checkbox.
    @IBInspectable public var hideBox: Bool {
        get {
            return manager.hideBox
        }
        set {
            manager.hideBox = newValue
        }
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        manager.tintColor = tintColor
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Update size
        manager.paths.size = min(frame.size.width, frame.size.height)
        // Layout
        manager.layoutLayers()
    }
}
