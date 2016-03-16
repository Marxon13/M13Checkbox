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
        
        // Add the layers.
        layer.addSublayer(unselectedBoxLayer)
        layer.addSublayer(selectedBoxLayer)
        layer.addSublayer(checkmarkLayer)
        
        // Disable som implicit animations.
        let newActions = [
            "opacity": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull(),
            "fillColor": NSNull(),
            "path": NSNull(),
            "lineWidth": NSNull()
        ]
        
        // Setup the unselected box layer
        unselectedBoxLayer.lineWidth = boxLineWidth
        unselectedBoxLayer.lineCap = kCALineCapRound
        unselectedBoxLayer.rasterizationScale = UIScreen.mainScreen().scale
        unselectedBoxLayer.shouldRasterize = true
        unselectedBoxLayer.actions = newActions
        
        // Setup the selected box layer.
        selectedBoxLayer.lineWidth = boxLineWidth
        selectedBoxLayer.lineCap = kCALineCapRound
        selectedBoxLayer.rasterizationScale = UIScreen.mainScreen().scale
        selectedBoxLayer.shouldRasterize = true
        selectedBoxLayer.actions = newActions
        
        // Setup the checkmark layer.
        checkmarkLayer.lineWidth = checkmarkLineWidth
        checkmarkLayer.lineCap = kCALineCapRound
        checkmarkLayer.lineJoin = kCALineJoinRound
        checkmarkLayer.rasterizationScale = UIScreen.mainScreen().scale
        checkmarkLayer.shouldRasterize = true
        checkmarkLayer.actions = newActions
        
        // Set up the inital state.
        setNeedsLayout()
        resetLayers()
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
    
    private var _checkState: CheckState = .Unchecked
    
    /// The current state of the checkbox.
    public var checkState: CheckState {
        get {
            return _checkState
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
    public func setCheckState(checkState: CheckState, animated: Bool) {
        if _checkState == checkState {
            return
        }
        
        // Set the state.
        _checkState = checkState
        
        if animated {
            switch checkState {
            case .Checked:
                addFromUncheckedAnimation()
                break
            case .Unchecked:
                addToUncheckedAnimation()
                break
            case .Mixed:
                
                break
            }
        } else {
            resetLayers()
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
            return animationManager.animationDuration
        }
        set {
            animationManager.animationDuration = newValue
        }
    }
    
    /// The type of animation to preform when changing from the unchecked state to any other state.
    public var stateChangeAnimation: Animation = .Stroke {
        didSet {
            setNeedsLayout()
            resetLayers()
            
            // TODO: - Add support for missing animations.
            if markType == .Radio && stateChangeAnimation == .Spiral {
                stateChangeAnimation = .Stroke
                print("WARNING: The spiral animation is currently unsupported with a radio mark.")
            }
        }
    }
    
    /// Creates and adds an animaiton to transition from the unselectedState
    private func addFromUncheckedAnimation() {
        // Check if we need to animate.
        if animationDuration == 0.0 {
            return
        }
        
        switch stateChangeAnimation {
        case .Stroke:
            
            let strokeAnimation = animationManager.strokeAnimation(false)
            let quickOpacityAnimation = animationManager.quickOpacityAnimation(false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            switch pathManager.markType {
            case .Checkmark:
                checkmarkLayer.addAnimation(strokeAnimation, forKey: "strokeEnd")
                checkmarkLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
                break
            case .Radio:
                let opacityAnimation = animationManager.opacityAnimation(false)
                checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
                break
            }
            
            selectedBoxLayer.addAnimation(strokeAnimation, forKey: "strokeEnd")
            selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")

            CATransaction.commit()
            
            break
            
        case .Fill:
            
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: false)
            let opacityAnimation = animationManager.opacityAnimation(false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(wiggleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
            
        case .Bounce:
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: false)
            
            let opacityAnimation = animationManager.opacityAnimation(false)
            opacityAnimation.duration = opacityAnimation.duration / 1.4
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(wiggleAnimation, forKey: "transform")
            
            CATransaction.commit()
            break
            
        case .Expand:
            
            let boxAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: false)
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let checkAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(boxAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(checkAnimation, forKey: "transform")
            
            CATransaction.commit()
            break
            
        case .Flat:
            checkmarkLayer.path = pathManager.pathForMixedMark().CGPath
            
            let morphAnimation = animationManager.morphAnimation(pathManager.pathForMixedMark(), toPath: pathManager.pathForMark())
            morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            let opacityAnimation = animationManager.opacityAnimation(false)
            
            let lineWidthAnimation = animationManager.quickLineWidthAnimation(pathManager.checkmarkLineWidth, reverse: false)
            morphAnimation.beginTime = CACurrentMediaTime() + lineWidthAnimation.duration
            morphAnimation.duration = morphAnimation.duration - lineWidthAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(morphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(lineWidthAnimation, forKey: "lineWidth")
            
            CATransaction.commit()
            break
            
        case .Spiral:
            
            // Temporarily set the path of the checkmark to the long checkmark
            checkmarkLayer.path = pathManager.pathForLongCheckmark().bezierPathByReversingPath().CGPath
            
            let quickOpacityAnimation = animationManager.quickOpacityAnimation(false)
            
            let boxStrokeAnimation = animationManager.strokeAnimation(false)
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2.0
            
            let checkQuickOpacityAnimation = animationManager.quickOpacityAnimation(false)
            checkQuickOpacityAnimation.duration = 0.001
            checkQuickOpacityAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkQuickOpacityAnimation.duration
            
            let checkStrokeAnimation = animationManager.strokeAnimation(false)
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 4.0
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            checkStrokeAnimation.fillMode = kCAFillModeBackwards
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
            
            let checkMorphAnimation = animationManager.morphAnimation(pathManager.pathForLongCheckmark(), toPath: pathManager.pathForMark())
            checkMorphAnimation.duration = checkMorphAnimation.duration / 4.0
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            checkMorphAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkStrokeAnimation.duration
            checkMorphAnimation.removedOnCompletion = false
            checkMorphAnimation.fillMode = kCAFillModeForwards
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")
            checkmarkLayer.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")
            checkmarkLayer.addAnimation(checkMorphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(checkQuickOpacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
            
        case .Fade:
            let opacityAnimation = animationManager.opacityAnimation(false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
            
        case let .Dot(style):
            let scaleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: false)
            
            let opacityAnimation = animationManager.opacityAnimation(false)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            if style == .Stroke {
                let quickOpacityAnimation = animationManager.quickOpacityAnimation(true)
                quickOpacityAnimation.beginTime = CACurrentMediaTime()
                unselectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            }
            selectedBoxLayer.addAnimation(scaleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
        }
    }
    
    /// Creates and adds an animation to transition to the unchecked state.
    private func addToUncheckedAnimation() {
        // Check if we need to animate.
        if animationDuration == 0.0 {
            return
        }
        
        switch stateChangeAnimation {
        case .Stroke:
            let strokeAnimation = animationManager.strokeAnimation(true)
            let quickOpacityAnimation = animationManager.quickOpacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            switch pathManager.markType {
            case .Checkmark:
                checkmarkLayer.addAnimation(strokeAnimation, forKey: "strokeEnd")
                checkmarkLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
                break
            case .Radio:
                let opacityAnimation = animationManager.opacityAnimation(true)
                checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
                break
            }
            selectedBoxLayer.addAnimation(strokeAnimation, forKey: "strokeEnd")
            selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
            
        case .Fill:
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: true)
            let opacityAnimation = animationManager.opacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(wiggleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
            
        case .Bounce:
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: true)
            let opacityAnimation = animationManager.opacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(wiggleAnimation, forKey: "transform")
            
            CATransaction.commit()
            break
            
        case .Expand:
            let boxAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: true)
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let checkAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(boxAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(checkAnimation, forKey: "transform")
            
            CATransaction.commit()
            break
            
        case .Flat:
            let morphAnimation = animationManager.morphAnimation(pathManager.pathForMark(), toPath: pathManager.pathForMixedMark())
            morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            let opacityAnimation = animationManager.opacityAnimation(true)
            
            let lineWidthAnimation = animationManager.quickLineWidthAnimation(pathManager.checkmarkLineWidth, reverse: true)
            morphAnimation.duration = morphAnimation.duration - lineWidthAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(morphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(lineWidthAnimation, forKey: "lineWidth")
            
            CATransaction.commit()
            break
            
        case .Spiral:
            // Temporarily set the path of the checkmark to the long checkmark
            checkmarkLayer.path = pathManager.pathForLongCheckmark().bezierPathByReversingPath().CGPath
            
            let checkMorphAnimation = animationManager.morphAnimation(pathManager.pathForMark(), toPath: pathManager.pathForLongCheckmark())
            checkMorphAnimation.fillMode = kCAFillModeBackwards
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6.0
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            let checkStrokeAnimation = animationManager.strokeAnimation(true)
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3.0
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            let boxStrokeAnimation = animationManager.strokeAnimation(true)
            boxStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2.0
            boxStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let quickOpacityAnimation = animationManager.quickOpacityAnimation(true)
            
            let checkQuickOpacityAnimation = animationManager.quickOpacityAnimation(true)
            checkQuickOpacityAnimation.duration = 0.001
            checkQuickOpacityAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(checkMorphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")
            checkmarkLayer.addAnimation(checkQuickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")
            
            CATransaction.commit()
            break
            
        case .Fade:
            let opacityAnimation = animationManager.opacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
            
        case let .Dot(style):
            
            let scaleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: true)
            
            let opacityAnimation = animationManager.opacityAnimation(true)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayers()
            })
            
            if style == .Stroke {
                unselectedBoxLayer.opacity = 0.0
                let quickOpacityAnimation = animationManager.quickOpacityAnimation(false)
                quickOpacityAnimation.beginTime = CACurrentMediaTime() + scaleAnimation.duration - quickOpacityAnimation.duration
                unselectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            }
            selectedBoxLayer.addAnimation(scaleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            CATransaction.commit()
            break
        }
    }
    
    private func resetLayers() {
        setNeedsLayout()
        
        // Get the preset for the curent animation and state.
        if let animationEndPoint = M13CheckboxAnimationPresets().animationPresets[stateChangeAnimation] {
            let animationPreset = checkState == .Unchecked ? animationEndPoint.unselected : animationEndPoint.selected
            
            // Update the unselected box layer
            checkmarkLayer.removeAllAnimations()
            reset(layer: checkmarkLayer, toPreset: animationPreset.markLayer)
            selectedBoxLayer.removeAllAnimations()
            reset(layer: selectedBoxLayer, toPreset: animationPreset.selectedBoxLayer)
            unselectedBoxLayer.removeAllAnimations()
            reset(layer: unselectedBoxLayer, toPreset: animationPreset.unselectedBoxLayer)
        }
    }
    
    private func reset(layer layer: CAShapeLayer, toPreset preset: LayerPropertiesPreset) {
        layer.opacity = preset.opacity
        layer.strokeEnd = preset.strokeEnd
        layer.transform = preset.transform
        
        if layer == unselectedBoxLayer {
            layer.fillColor = preset.fill == .Main ? secondaryTintColor?.CGColor : nil
        } else {
            layer.fillColor = preset.fill == .Main ? tintColor?.CGColor : nil
        }
        
        if layer == unselectedBoxLayer {
            layer.strokeColor = preset.stroke == .Main ? secondaryTintColor?.CGColor : nil
        } else if layer == checkmarkLayer {
            layer.strokeColor = preset.stroke == .Main ? tintColor.CGColor : preset.stroke == .Secondary ? secondaryCheckmarkTintColor?.CGColor : nil
        } else {
            layer.strokeColor = preset.stroke == .Main ? tintColor?.CGColor : nil
        }
        
        if layer == checkmarkLayer {
            layer.lineWidth = preset.lineWidth ? checkmarkLineWidth : 0.0
        } else {
            layer.lineWidth = preset.lineWidth ? boxLineWidth : 0.0
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
    @IBInspectable public var secondaryTintColor: UIColor? = UIColor.lightGrayColor() {
        didSet {
            resetLayers()
        }
    }
    
    /// The color of the checkmark when it is displayed against a filled background.
    @IBInspectable public var secondaryCheckmarkTintColor: UIColor? = UIColor.whiteColor() {
        didSet {
            resetLayers()
        }
    }
    
    /// The stroke width of the checkmark.
    @IBInspectable public var checkmarkLineWidth: CGFloat {
        get {
            return pathManager.checkmarkLineWidth
        }
        set {
            pathManager.checkmarkLineWidth = newValue
            checkmarkLayer.lineWidth = checkmarkLineWidth
        }
    }
    
    // The type of mark to display.
    @IBInspectable public var markType: MarkType {
        get {
            return pathManager.markType
        }
        set {
            pathManager.markType = newValue
            
            // TODO: - Add support for missing animations.
            if markType == .Radio && stateChangeAnimation == .Spiral {
                pathManager.markType = .Checkmark
                print("WARNING: The spiral animation is currently unsupported with a radio mark.")
            }
            
            resetLayers()
            setNeedsLayout()
        }
    }
    
    /// The stroke width of the box.
    @IBInspectable public var boxLineWidth: CGFloat {
        get {
            return pathManager.boxLineWidth
        }
        set {
            pathManager.boxLineWidth = newValue
            unselectedBoxLayer.lineWidth = boxLineWidth
            selectedBoxLayer.lineWidth = boxLineWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return pathManager.cornerRadius
        }
        set {
            pathManager.cornerRadius = newValue
            if boxType == .Square {
                setNeedsLayout()
            }
        }
    }
    
    /// Whether or not the checkbox is flat, without a glossy overlay. Defaults to true.
    @IBInspectable public var flat: Bool = true
    
    /// The shape of the checkbox
    public var boxType: BoxType {
        get {
            return pathManager.boxType
        }
        set {
            pathManager.boxType = newValue
            setNeedsLayout()
        }
    }
    
    /// Wether or not to hide the checkbox.
    @IBInspectable public var hideBox: Bool = false {
        didSet {
            selectedBoxLayer.hidden = hideBox
            unselectedBoxLayer.hidden = hideBox
        }
    }
    
    /// The layer that draws the box when in the unselected state.
    private var unselectedBoxLayer: CAShapeLayer = CAShapeLayer()
    
    /// The layer that draws the box when in the selected or mixed state.
    private var selectedBoxLayer: CAShapeLayer = CAShapeLayer()
    
    /// The layer that draws the checkmark.
    private var checkmarkLayer: CAShapeLayer = CAShapeLayer()
    
    /// The path manager.
    private var pathManager: M13CheckboxPathManager = M13CheckboxPathManager()
    
    /// The animation manager.
    private var animationManager: M13CheckboxAnimationManager = M13CheckboxAnimationManager()
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        resetLayers()
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Update size
        pathManager.size = min(frame.size.width, frame.size.height)
        // Update bounds
        unselectedBoxLayer.frame = self.bounds
        selectedBoxLayer.frame = self.bounds
        checkmarkLayer.frame = self.bounds
        // Update paths
        selectedBoxLayer.path = pathManager.pathForBox().CGPath
        checkmarkLayer.path = pathManager.pathForMark().CGPath
        switch stateChangeAnimation {
        case .Dot:
            unselectedBoxLayer.path = pathManager.pathForDot().CGPath
            break
        default:
            unselectedBoxLayer.path = pathManager.pathForBox().CGPath
            break
        }
        
    }
}
