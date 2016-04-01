//
//  M13Checkbox.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 2/23/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

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
    public enum CheckState: Int, RawRepresentable {
        /// No check is shown.
        case Unchecked = 0
        /// A checkmark is shown.
        case Checked = 1
        /// A dash is shown.
        case Mixed = 2
    }
    
    /**
     The possible shapes of the box.
     
     - Square: The box is square with optional rounded corners.
     - Circle: The box is a circle.
     */
    public enum BoxType: Int, RawRepresentable {
        /// The box is a circle.
        case Circle = 0
        /// The box is square with optional rounded corners.
        case Square = 1
    }
    
    /**
     The possible shapes of the mark.
     
     - Checkmark: The mark is a standard checkmark.
     - Radio: The mark is a radio style fill.
     */
    public enum MarkType: Int, RawRepresentable {
        /// The mark is a standard checkmark.
        case Checkmark = 0
        /// The mark is a radio style fill.
        case Radio = 1
    }
    
    /**
     The possible animations for switching to and from the unchecked state.
     */
    public enum Animation: RawRepresentable, Hashable {
        /// Animates the stroke of the box and the check as if they were drawn.
        case Stroke
        /// Animates the checkbox with a bouncey fill effect.
        case Fill
        /// Animates the check mark with a bouncy effect.
        case Bounce(AnimationStyle)
        /// Animates the checkmark and fills the box with a bouncy effect.
        case Expand(AnimationStyle)
        /// Morphs the checkmark from a line.
        case Flat(AnimationStyle)
        /// Animates the box and check as if they were drawn in one continuous line.
        case Spiral
        /// Fades checkmark in or out. (opacity).
        case Fade(AnimationStyle)
        /// Start the box as a dot, and expand the box.
        case Dot(AnimationStyle)
        
        public init?(rawValue: Int) {
            // Map the integer values to the animation types.
            // This is only for interface builder support. I would like this to be removed eventually.
            switch rawValue {
            case 0:
                self = .Stroke
                break
            case 10:
                self = .Fill
                break
            case 20...21:
                self = rawValue == 20 ? .Bounce(.Stroke) : .Bounce(.Fill)
                break
            case 30...31:
                self = rawValue == 30 ? .Expand(.Stroke) : .Expand(.Fill)
            case 40...41:
                self = rawValue == 40 ? .Flat(.Stroke) : .Flat(.Fill)
                break
            case 50:
                self = .Spiral
                break
            case 60...61:
                self = rawValue == 50 ? .Fade(.Stroke) : .Fade(.Fill)
            case 70...71:
                self = rawValue == 70 ? .Dot(.Stroke) : .Dot(.Fill)
            default:
                return nil
            }
        }
        
        public var rawValue: Int {
            // Map the animation types to integer values.
            // This is only for interface builder support. I would like this to be removed eventually.
            switch self {
            case .Stroke:
                return 0
            case .Fill:
                return 10
            case let .Bounce(style):
                return style == .Stroke ? 20 : 21
            case let .Expand(style):
                return style == .Stroke ? 30 : 31
            case let .Flat(style):
                return style == .Stroke ? 40 : 41
            case .Spiral:
                return 50
            case let .Fade(style):
                return style == .Stroke ? 60 : 61
            case let .Dot(style):
                return style == .Stroke ? 70 : 71
            }
        }
        
        /// The manager for the specific animation type.
        private var manager: M13CheckboxManager {
            switch self {
            case .Stroke:
                return M13CheckboxStrokeManager()
            case .Fill:
                return M13CheckboxFillManager()
            case let .Bounce(style):
                return M13CheckboxBounceManager(style: style)
            case let .Expand(style):
                return M13CheckboxExpandManager(style: style)
            case let .Flat(style):
                return M13CheckboxFlatManager(style: style)
            case .Spiral:
                return M13CheckboxSpiralManager()
            case let .Fade(style):
                return M13CheckboxFadeManager(style: style)
            case let .Dot(style):
                return M13CheckboxDotManager(style: style)
            }
        }
        
        public var hashValue: Int {
            return self.rawValue
        }
    }
    
    /**
     The possible animation styles.
     - Note: Not all animations support all styles.
     */
    public enum AnimationStyle: Int {
        // The animation will focus on the stroke.
        case Stroke = 0
        // The animation will focus on the fill.
        case Fill = 1
    }
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// The manager that manages display and animations of the checkbox.
    /// The default animation is a stroke.
    private var manager: M13CheckboxManager = M13CheckboxStrokeManager()
    
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
    private func sharedSetup() {
        // Set up the inital state.
        for aLayer in manager.layersToDisplay {
            layer.addSublayer(aLayer)
        }
        manager.tintColor = tintColor
        manager.resetLayersForState(.Unchecked)
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
        case .Unchecked:
            return uncheckedValue
        case .Checked:
            return checkedValue
        case .Mixed:
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
    public func setCheckState(newState: CheckState, animated: Bool) {
        if checkState == newState {
            return
        }
        
        if animated {
            manager.animate(checkState, toState: newState)
        } else {
            manager.resetLayersForState(checkState)
        }
    }
    
    /**
     Toggle the check state between unchecked and checked.
     - parameter animated: Whether or not to animate the change. Defaults to false.
     - note: If the checkbox is mixed, it will return to the unchecked state.
     */
    public func toggleCheckState(animated: Bool = false) {
        switch checkState {
        case .Checked:
            setCheckState(.Unchecked, animated: animated)
            break
        case .Unchecked:
            setCheckState(.Checked, animated: animated)
            break
        case .Mixed:
            setCheckState(.Unchecked, animated: animated)
            break
        }
    }
    
    //----------------------------
    // MARK: - Animations
    //----------------------------
    
    /// The duration of the animation that occurs when the checkbox switches states. The default is 0.3 seconds.
    @IBInspectable public var animationDuration: NSTimeInterval {
        get {
            return manager.animations.animationDuration
        }
        set {
            manager.animations.animationDuration = newValue
        }
    }
    
    /// The type of animation to preform when changing from the unchecked state to any other state.
    public var stateChangeAnimation: Animation = .Stroke {
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
            if markType == .Radio && stateChangeAnimation == .Spiral {
                stateChangeAnimation = .Stroke
                print("WARNING: The spiral animation is currently unsupported with a radio mark.")
            }
        }
    }
    
    //----------------------------
    // MARK: - UIControl
    //----------------------------
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        // Become selected
        selected = true
        return true
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        selected = false
        toggleCheckState(true)
        sendActionsForControlEvents(.ValueChanged)
    }
    
    public override func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)
        selected = false
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
            if markType == .Radio && stateChangeAnimation == .Spiral {
                manager.paths.markType = .Checkmark
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
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return manager.paths.cornerRadius
        }
        set {
            manager.paths.cornerRadius = newValue
            setNeedsLayout()
        }
    }
    
    /// The shape of the checkbox
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
