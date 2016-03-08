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
    public enum Animation: RawRepresentable {
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
    
    private func sharedSetup() {
        
        // Add the layers.
        layer.addSublayer(unselectedBoxLayer)
        layer.addSublayer(selectedBoxLayer)
        layer.addSublayer(checkmarkLayer)
        
        let newActions = [
            "opacity": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull()
        ]
        
        // Setup the unselected box layer
        unselectedBoxLayer.lineWidth = boxLineWidth
        unselectedBoxLayer.strokeColor = secondaryTintColor?.CGColor
        unselectedBoxLayer.fillColor = nil
        unselectedBoxLayer.lineCap = kCALineCapRound
        unselectedBoxLayer.rasterizationScale = UIScreen.mainScreen().scale
        unselectedBoxLayer.shouldRasterize = true
        unselectedBoxLayer.actions = newActions
        
        // Setup the selected box layer.
        selectedBoxLayer.lineWidth = boxLineWidth
        selectedBoxLayer.fillColor = nil
        selectedBoxLayer.lineCap = kCALineCapRound
        selectedBoxLayer.strokeColor = tintColor.CGColor
        selectedBoxLayer.rasterizationScale = UIScreen.mainScreen().scale
        selectedBoxLayer.shouldRasterize = true
        selectedBoxLayer.opacity = 0.0
        selectedBoxLayer.actions = newActions
        
        // Setup the checkmark layer.
        checkmarkLayer.lineWidth = checkmarkLineWidth
        checkmarkLayer.strokeColor = tintColor.CGColor
        checkmarkLayer.fillColor = nil
        checkmarkLayer.lineCap = kCALineCapRound
        checkmarkLayer.lineJoin = kCALineJoinRound
        checkmarkLayer.rasterizationScale = UIScreen.mainScreen().scale
        checkmarkLayer.shouldRasterize = true
        checkmarkLayer.opacity = 0.0
        checkmarkLayer.actions = newActions
        
        setNeedsLayout()
        updateColorsForAnimation(stateChangeAnimation)
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
        _checkState = checkState
        
        switch checkState {
        case .Checked:
            if animated {
                addFromUncheckedAnimation()
            } else {
                resetLayers()
                updateColorsForAnimation(stateChangeAnimation)
            }
            break
        case .Unchecked:
            if animated {
                addToUncheckedAnimation()
            } else {
                resetLayers()
                updateColorsForAnimation(stateChangeAnimation)
                checkmarkLayer.opacity = 0.0
                selectedBoxLayer.opacity = 0.0
            }
            break
        case .Mixed:
            if animated {
                
            } else {
                resetLayers()            }
            break
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
            updateColorsForAnimation(stateChangeAnimation)
            
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
        
        resetLayers()
        
        switch stateChangeAnimation {
        case .Stroke:
            
            let strokeAnimation = animationManager.strokeAnimation(false)
            strokeAnimation.delegate = self
            let quickOpacityAnimation = animationManager.quickOpacityAnimation(false)
            
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
            break
            
        case .Fill:
            
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: false)
            let opacityAnimation = animationManager.opacityAnimation(false)
            
            selectedBoxLayer.addAnimation(wiggleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            break
            
        case .Bounce:
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: false)
            wiggleAnimation.delegate = self
            
            let opacityAnimation = animationManager.opacityAnimation(false)
            opacityAnimation.duration = opacityAnimation.duration / 1.4
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(wiggleAnimation, forKey: "transform")
            break
            
        case .Expand:
            
            let boxAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: false)
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let checkAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: false)
            checkAnimation.delegate = self
            
            selectedBoxLayer.addAnimation(boxAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(checkAnimation, forKey: "transform")
            
            break
            
        case .Flat:
            checkmarkLayer.path = pathManager.pathForMixedMark().CGPath
            
            let morphAnimation = animationManager.morphAnimation(pathManager.pathForMixedMark(), toPath: pathManager.pathForMark())
            morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            let opacityAnimation = animationManager.opacityAnimation(false)
            opacityAnimation.delegate = self
            
            let lineWidthAnimation = animationManager.quickLineWidthAnimation(pathManager.checkmarkLineWidth, reverse: false)
            morphAnimation.beginTime = CACurrentMediaTime() + lineWidthAnimation.duration
            morphAnimation.duration = morphAnimation.duration - lineWidthAnimation.duration
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(morphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(lineWidthAnimation, forKey: "lineWidth")
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
            checkMorphAnimation.delegate = self
            
            selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")
            checkmarkLayer.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")
            checkmarkLayer.addAnimation(checkMorphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(checkQuickOpacityAnimation, forKey: "opacity")
            break
            
        case .Fade:
            let opacityAnimation = animationManager.opacityAnimation(false)
            opacityAnimation.delegate = self
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            break
            
        case let .Dot(style):
            let scaleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: false)
            scaleAnimation.delegate = self
            
            let opacityAnimation = animationManager.opacityAnimation(false)
            
            if style == .Stroke {
                let quickOpacityAnimation = animationManager.quickOpacityAnimation(true)
                quickOpacityAnimation.beginTime = CACurrentMediaTime()
                unselectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            }
            selectedBoxLayer.addAnimation(scaleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            
            break
        }
    }
    
    /// Creates and adds an animation to transition to the unchecked state.
    private func addToUncheckedAnimation() {
        // Check if we need to animate.
        if animationDuration == 0.0 {
            return
        }
        
        resetLayers()
        
        switch stateChangeAnimation {
        case .Stroke:
            let strokeAnimation = animationManager.strokeAnimation(true)
            strokeAnimation.delegate = self
            let quickOpacityAnimation = animationManager.quickOpacityAnimation(true)
            
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
            break
            
        case .Fill:
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: true)
            wiggleAnimation.delegate = self
            let opacityAnimation = animationManager.opacityAnimation(true)
            
            selectedBoxLayer.addAnimation(wiggleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            break
            
        case .Bounce:
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let wiggleAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: true)
            let opacityAnimation = animationManager.opacityAnimation(true)
            opacityAnimation.delegate = self
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(wiggleAnimation, forKey: "transform")
            break
            
        case .Expand:
            let boxAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: true)
            let amplitude: CGFloat = boxType == .Square ? 0.20 : 0.35
            let checkAnimation = animationManager.fillAnimation(1, amplitude: amplitude, reverse: true)
            checkAnimation.delegate = self
            
            selectedBoxLayer.addAnimation(boxAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(checkAnimation, forKey: "transform")
            
            break
            
        case .Flat:
            let morphAnimation = animationManager.morphAnimation(pathManager.pathForMark(), toPath: pathManager.pathForMixedMark())
            morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            let opacityAnimation = animationManager.opacityAnimation(true)
            opacityAnimation.delegate = self
            
            let lineWidthAnimation = animationManager.quickLineWidthAnimation(pathManager.checkmarkLineWidth, reverse: true)
            morphAnimation.duration = morphAnimation.duration - lineWidthAnimation.duration
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(morphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(lineWidthAnimation, forKey: "lineWidth")
            break
            
        case .Spiral:
            // Temporarily set the path of the checkmark to the long checkmark
            checkmarkLayer.path = pathManager.pathForLongCheckmark().bezierPathByReversingPath().CGPath
            
            let checkMorphAnimation = animationManager.morphAnimation(pathManager.pathForMark(), toPath: pathManager.pathForLongCheckmark())
            checkMorphAnimation.delegate = self
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
            boxStrokeAnimation.delegate = self
            boxStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let quickOpacityAnimation = animationManager.quickOpacityAnimation(true)
            
            let checkQuickOpacityAnimation = animationManager.quickOpacityAnimation(true)
            checkQuickOpacityAnimation.duration = 0.001
            checkQuickOpacityAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            
            selectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(checkMorphAnimation, forKey: "path")
            checkmarkLayer.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")
            checkmarkLayer.addAnimation(checkQuickOpacityAnimation, forKey: "opacity")
            selectedBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")
            
            break
            
        case .Fade:
            let opacityAnimation = animationManager.opacityAnimation(true)
            opacityAnimation.delegate = self
            
            selectedBoxLayer.addAnimation(opacityAnimation, forKey: "opacity")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            break
            
        case let .Dot(style):
            
            let scaleAnimation = animationManager.fillAnimation(1, amplitude: 0.18, reverse: true)
            scaleAnimation.delegate = self
            
            let opacityAnimation = animationManager.opacityAnimation(true)
            
            if style == .Stroke {
                unselectedBoxLayer.opacity = 0.0
                let quickOpacityAnimation = animationManager.quickOpacityAnimation(false)
                quickOpacityAnimation.beginTime = CACurrentMediaTime() + scaleAnimation.duration - quickOpacityAnimation.duration
                unselectedBoxLayer.addAnimation(quickOpacityAnimation, forKey: "opacity")
            }
            selectedBoxLayer.addAnimation(scaleAnimation, forKey: "transform")
            checkmarkLayer.addAnimation(opacityAnimation, forKey: "opacity")
            break
        }
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            switch checkState {
            case .Unchecked:
                
                break
            case .Checked:
                
                break
            case .Mixed:
                
                break
            }
        }
    }
    
    private func resetLayers() {
        unselectedBoxLayer.opacity = 1.0
        unselectedBoxLayer.transform = CATransform3DIdentity
        unselectedBoxLayer.strokeEnd = 1.0
        
        checkmarkLayer.opacity = 1.0
        checkmarkLayer.transform = CATransform3DIdentity
        checkmarkLayer.strokeEnd = 1.0
        
        selectedBoxLayer.opacity = 1.0
        selectedBoxLayer.transform = CATransform3DIdentity
        checkmarkLayer.strokeEnd = 1.0
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
            updateColorsForAnimation(stateChangeAnimation)
        }
    }
    
    /// The color of the checkmark when it is displayed against a filled background.
    @IBInspectable public var secondaryCheckmarkTintColor: UIColor? = UIColor.whiteColor() {
        didSet {
            updateColorsForAnimation(stateChangeAnimation)
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
            
            if markType == .Radio && stateChangeAnimation == .Spiral {
                pathManager.markType = .Checkmark
                print("WARNING: The spiral animation is currently unsupported with a radio mark.")
            }
            
            updateColorsForAnimation(stateChangeAnimation)
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
        updateColorsForAnimation(stateChangeAnimation)
    }
    
    /**
     Sets the colors of the layers based on the animaitons that will be preformed.
     */
    private func updateColorsForAnimation(animation: Animation) {
        
        // Unselected layer
        switch animation {
        case .Dot:
            unselectedBoxLayer.strokeColor = nil
            unselectedBoxLayer.fillColor = secondaryTintColor?.CGColor
            break
        default:
            unselectedBoxLayer.strokeColor = secondaryTintColor?.CGColor
            unselectedBoxLayer.fillColor = nil
            break
        }
        
        // Selected and checkmark layers
        switch animation {
        case .Stroke, .Spiral:
            switch pathManager.markType {
            case .Checkmark:
                updateColorsForStyle(.Stroke)
                break
            case .Radio:
                updateRadioColorForStyle(.Fill)
                break
            }
            break
        case let .Bounce(style):
            switch pathManager.markType {
            case .Checkmark:
                updateColorsForStyle(style)
                break
            case .Radio:
                updateRadioColorForStyle(style)
                break
            }
            break
        case let .Expand(style):
            switch pathManager.markType {
            case .Checkmark:
                updateColorsForStyle(style)
                break
            case .Radio:
                updateRadioColorForStyle(style)
                break
            }
            break
        case let .Flat(style):
            updateColorsForStyle(style)
            break
        case let .Fade(style):
            switch pathManager.markType {
            case .Checkmark:
                updateColorsForStyle(style)
                break
            case .Radio:
                updateRadioColorForStyle(style)
                break
            }
        case .Fill:
            switch pathManager.markType {
            case .Checkmark:
                updateColorsForStyle(.Fill)
                break
            case .Radio:
                updateRadioColorForStyle(.Fill)
                checkmarkLayer.fillColor = secondaryCheckmarkTintColor?.CGColor
                checkmarkLayer.strokeColor = nil
                break
            }
            break
        case let .Dot(style):
            updateColorsForStyle(style)
            break
        }
    }
    
    func updateColorsForStyle(style: AnimationStyle) {
        switch style {
        case .Stroke:
            selectedBoxLayer.strokeColor = tintColor.CGColor
            selectedBoxLayer.fillColor = nil
            checkmarkLayer.strokeColor = tintColor.CGColor
            checkmarkLayer.fillColor = nil
            break
        case .Fill:
            selectedBoxLayer.strokeColor = tintColor.CGColor
            selectedBoxLayer.fillColor = tintColor.CGColor
            checkmarkLayer.strokeColor = secondaryCheckmarkTintColor?.CGColor
            checkmarkLayer.fillColor = nil
            break
        }
    }
    
    func updateRadioColorForStyle(style: AnimationStyle) {
        switch style {
        case .Stroke:
            selectedBoxLayer.strokeColor = tintColor.CGColor
            selectedBoxLayer.fillColor = nil
            checkmarkLayer.strokeColor = tintColor.CGColor
            checkmarkLayer.fillColor = nil
            break
        case .Fill:
            selectedBoxLayer.strokeColor = tintColor.CGColor
            selectedBoxLayer.fillColor = nil
            checkmarkLayer.strokeColor = nil
            checkmarkLayer.fillColor = tintColor.CGColor
            break
        }
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
