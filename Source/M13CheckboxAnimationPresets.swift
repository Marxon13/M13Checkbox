//
//  M13CheckboxAnimationPresets.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/11/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

//----------------------------
// MARK: - Constants
//----------------------------

/**
Defines a preset of what color to show.
*/
internal enum ColorPreset {
    case None
    case Main
    case Secondary
}

/**
 A structure to store the properties of the control's layers before and after animations.
 */
internal struct LayerPropertiesPreset {
    let opacity: Float
    let strokeEnd: CGFloat
    let transform: CATransform3D
    let fill: ColorPreset
    let stroke: ColorPreset
    let lineWidth: Bool
}

/**
 A structure to store the presets of multiple layers.
 */
internal struct AnimationPropertiesPreset {
    let unselectedBoxLayer: LayerPropertiesPreset
    let selectedBoxLayer: LayerPropertiesPreset
    let markLayer: LayerPropertiesPreset
}

/**
 A structure to store the unselected and selected presets for animations.
 */
internal struct AnimationEndPoint {
    let unselected: AnimationPropertiesPreset
    let selected: AnimationPropertiesPreset
}


//----------------------------
// MARK: - Preset
//----------------------------

internal class M13CheckboxAnimationPresets {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// Contains the unselected and selected presets for all layers for all animations.
    internal let animationPresets: [M13Checkbox.Animation: AnimationEndPoint] = [
        
        //----------------------------
        // MARK: - Stroke
        //----------------------------
        
        .Stroke: AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Fill
        //----------------------------
        
        .Fill: AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Bounce
        //----------------------------
        
        .Bounce(.Stroke): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            )
        ),
        
        .Bounce(.Fill): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Expand
        //----------------------------
        
        .Expand(.Stroke): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            )
        ),
        
        .Expand(.Fill): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Flat
        //----------------------------
        
        .Flat(.Stroke): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            )
        ),
        
        .Flat(.Fill): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: false)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Spiral
        //----------------------------
        
        .Spiral: AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Fade
        //----------------------------
        
        .Fade(.Stroke): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            )
        ),
        
        .Fade(.Fill): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Dot
        //----------------------------
        
        .Dot(.Stroke): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true)
            )
        ),
        
        .Dot(.Fill): AnimationEndPoint(
            unselected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            ),
            selected: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Main,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .Main,
                    stroke: .Main,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: .None,
                    stroke: .Secondary,
                    lineWidth: true)
            )
        )
    ]
    
    
}
