//
//  M13CheckboxAnimationPresets.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/11/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

internal class M13CheckboxAnimationPresets {
    
    //----------------------------
    // MARK: - Constants
    //----------------------------
    
    /**
     A structure to store the properties of the control's layers before and after animations.
     */
    internal struct LayerPropertiesPreset {
        let opacity: CGFloat
        let strokeEnd: CGFloat
        let transform: CATransform3D
        let fill: Bool
        let stroke: Bool
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
     A structure to store the start and end presets for animations.
     */
    internal struct AnimationEndPoint {
        let start: AnimationPropertiesPreset
        let end: AnimationPropertiesPreset
    }
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// Contains the start and end presets for all layers for all animations.
    internal static let animationPresets: [M13Checkbox.Animation: AnimationEndPoint] = [
        
        //----------------------------
        // MARK: - Stroke
        //----------------------------
        
        .Stroke: AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Fill
        //----------------------------
        
        .Fill: AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Bounce
        //----------------------------
        
        .Bounce(.Stroke): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        .Bounce(.Fill): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Expand
        //----------------------------
        
        .Expand(.Stroke): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        .Expand(.Fill): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Flat
        //----------------------------
        
        .Flat(.Stroke): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: false)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        .Flat(.Fill): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: false)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Spiral
        //----------------------------
        
        .Spiral: AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 0.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Fade
        //----------------------------
        
        .Fade(.Stroke): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        .Fade(.Fill): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        //----------------------------
        // MARK: - Dot
        //----------------------------
        
        .Dot(.Stroke): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        ),
        
        .Dot(.Fill): AnimationEndPoint(
            start: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DMakeScale(0.0, 0.0, 0.0),
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 0.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            ),
            end: AnimationPropertiesPreset(
                unselectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true),
                selectedBoxLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: true,
                    stroke: true,
                    lineWidth: true),
                markLayer: LayerPropertiesPreset(
                    opacity: 1.0,
                    strokeEnd: 1.0,
                    transform: CATransform3DIdentity,
                    fill: false,
                    stroke: true,
                    lineWidth: true)
            )
        )
    ]
    
    
}
