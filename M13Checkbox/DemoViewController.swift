//
//  DemoViewController.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit
import Color_Picker_for_iOS
import PBDCarouselCollectionViewLayout

class DemoViewController: UIViewController, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout, AnimationSelectionTableViewControllerDelegate {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    @IBOutlet weak var checkbox: M13Checkbox?
    
    private weak var currentColorButton: UIButton?
    
    private var collectionView: UICollectionView?
    private var layout: CollectionViewLayout = CollectionViewLayout()
    private var maskLayer: CAGradientLayer = CAGradientLayer()
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //----------------------------
    // MARK: - Collection View Data Source
    //----------------------------
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if indexPath.item == 0 {
            // States cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("segmentedControlCell", forIndexPath: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "CheckboxState")
            cell.titleLabel?.text = "Checkbox State"
            cell.bodyLabel?.text = "The checkbox has three possible states: Unchecked, Checked, and Mixed."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegmentWithTitle("Unchecked", atIndex: 0, animated: false)
            cell.segmentedControl?.insertSegmentWithTitle("Checked", atIndex: 1, animated: false)
            cell.segmentedControl?.insertSegmentWithTitle("Mixed", atIndex: 2, animated: false)
            
            if let state = checkbox?.checkState {
                switch state {
                case .Unchecked:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    break
                case .Checked:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    break
                case .Mixed:
                    cell.segmentedControl?.selectedSegmentIndex = 2
                    break
                }
            }
            cell.segmentedControl?.enabled = true
            
            cell.segmentedControl?.addTarget(self, action: "updateCheckboxState:", forControlEvents: .ValueChanged)
            
        } else if indexPath.item == 1 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionCell", forIndexPath: indexPath)
            guard let cell = cell as? SelectionCollectionViewCell else {
                fatalError()
            }

            cell.iconView?.image = UIImage(named: "Animation")
            cell.titleLabel?.text = "Animation"
            cell.bodyLabel?.text = "Several animations are available for switching between states."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            switch checkbox!.stateChangeAnimation {
            case .Stroke:
                cell.selectionButton?.setTitle("Stroke", forState: .Normal)
            case .Fill:
                cell.selectionButton?.setTitle("Fill", forState: .Normal)
            case .Bounce:
                cell.selectionButton?.setTitle("Bounce", forState: .Normal)
            case .Expand:
                cell.selectionButton?.setTitle("Expand", forState: .Normal)
            case .Flat:
                cell.selectionButton?.setTitle("Flat", forState: .Normal)
            case .Spiral:
                cell.selectionButton?.setTitle("Spiral", forState: .Normal)
            case .Fade:
                cell.selectionButton?.setTitle("fade", forState: .Normal)
            case .Dot:
                cell.selectionButton?.setTitle("Dot", forState: .Normal)
            }
            
            cell.selectionButton?.addTarget(self, action: "updateAnimation:", forControlEvents: .TouchUpInside)
            
        }  else if indexPath.item == 2 {
            // States cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("segmentedControlCell", forIndexPath: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "AnimationStyle")
            cell.titleLabel?.text = "Animation Style"
            cell.bodyLabel?.text = "Some animations have multiple styles."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegmentWithTitle("Stroke", atIndex: 0, animated: false)
            cell.segmentedControl?.insertSegmentWithTitle("Fill", atIndex: 1, animated: false)
            
            if let animation = checkbox?.stateChangeAnimation {
                switch animation {
                case .Stroke:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    cell.segmentedControl?.enabled = false
                case .Fill:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    cell.segmentedControl?.enabled = false
                case let .Bounce(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .Stroke ? 0 : 1
                    cell.segmentedControl?.enabled = true
                case let .Expand(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .Stroke ? 0 : 1
                    cell.segmentedControl?.enabled = true
                case let .Flat(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .Stroke ? 0 : 1
                    cell.segmentedControl?.enabled = true
                case .Spiral:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    cell.segmentedControl?.enabled = false
                case let .Fade(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .Stroke ? 0 : 1
                    cell.segmentedControl?.enabled = true
                case let .Dot(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .Stroke ? 0 : 1
                    cell.segmentedControl?.enabled = true
                }
            }
            
            cell.segmentedControl?.addTarget(self, action: "updateAnimationStyle:", forControlEvents: .ValueChanged)
            
        } else if indexPath.item == 3 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sliderCell", forIndexPath: indexPath)
            guard let cell = cell as? SliderCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "AnimationDuration")
            cell.titleLabel?.text = "Animation Duration"
            cell.bodyLabel?.text = "The length of the animation duration. If the duration is set to 0.0, no animation will be preformed."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.slider?.minimumValue = 0.0
            cell.slider?.maximumValue = 2.0
            if let duration = checkbox?.animationDuration {
                cell.slider?.value = Float(duration)
            }
            cell.slider?.addTarget(self, action: "updateAnimationDuration:", forControlEvents: .ValueChanged)
        } else if indexPath.item == 4 {
            // States cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("segmentedControlCell", forIndexPath: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "MarkType")
            cell.titleLabel?.text = "Mark Type"
            cell.bodyLabel?.text = "The checkbox can double as a radio by switching the mark type to \"Radio\""
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegmentWithTitle("Checkmark", atIndex: 0, animated: false)
            cell.segmentedControl?.insertSegmentWithTitle("Radio", atIndex: 1, animated: false)
            
            if let state = checkbox?.boxType {
                switch state {
                case .Circle:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    break
                case .Square:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    break
                }
            }
            cell.segmentedControl?.enabled = true
            
            cell.segmentedControl?.addTarget(self, action: "updateMarkType:", forControlEvents: .ValueChanged)
            
        }  else if indexPath.item == 5 {
            // States cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("segmentedControlCell", forIndexPath: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "BoxShape")
            cell.titleLabel?.text = "Box Shape"
            cell.bodyLabel?.text = "The box can either be a circle or a square. If the box is a square, its corner radius can be changed."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegmentWithTitle("Circle", atIndex: 0, animated: false)
            cell.segmentedControl?.insertSegmentWithTitle("Square", atIndex: 1, animated: false)
            
            if let state = checkbox?.boxType {
                switch state {
                case .Circle:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    break
                case .Square:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    break
                }
            }
            cell.segmentedControl?.enabled = true
            
            cell.segmentedControl?.addTarget(self, action: "updateBoxShape:", forControlEvents: .ValueChanged)
            
        } else if indexPath.item == 6 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sliderCell", forIndexPath: indexPath)
            guard let cell = cell as? SliderCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "CheckLineWidth")
            cell.titleLabel?.text = "Mark Line Width"
            cell.bodyLabel?.text = "The line width of the checkmark or radio button can be adjusted."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.slider?.minimumValue = 1.0
            cell.slider?.maximumValue = 10.0
            if let lineWidth = checkbox?.checkmarkLineWidth {
                cell.slider?.value = Float(lineWidth)
            }
            cell.slider?.addTarget(self, action: "updateMarkLineWidth:", forControlEvents: .ValueChanged)
        } else if indexPath.item == 7 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sliderCell", forIndexPath: indexPath)
            guard let cell = cell as? SliderCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "BoxLineWidth")
            cell.titleLabel?.text = "Box Line Width"
            cell.bodyLabel?.text = "The line width of the box can be adjusted separately from the mark's line width."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.slider?.minimumValue = 1.0
            cell.slider?.maximumValue = 10.0
            if let lineWidth = checkbox?.boxLineWidth {
                cell.slider?.value = Float(lineWidth)
            }
            cell.slider?.addTarget(self, action: "updateBoxLineWidth:", forControlEvents: .ValueChanged)
        } else if indexPath.item == 8 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("colorCell", forIndexPath: indexPath)
            guard let cell = cell as? ColorCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "Colors")
            cell.titleLabel?.text = "Colors"
            cell.bodyLabel?.text = "The checkbox has three customizable colors, the tint color, secondary tint color, and the secondary check tint color."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.tintColorButton?.backgroundColor = checkbox?.tintColor
            cell.tintColorButton?.addTarget(self, action: "updateColorPopover:", forControlEvents: .TouchUpInside)
            cell.tintColorButton?.tag = 0
            cell.secondaryTintColorButton?.backgroundColor = checkbox?.secondaryTintColor
            cell.secondaryTintColorButton?.addTarget(self, action: "updateColorPopover:", forControlEvents: .TouchUpInside)
            cell.secondaryTintColorButton?.tag = 1
            cell.secondaryCheckTintColorButton?.backgroundColor = checkbox?.secondaryCheckmarkTintColor
            cell.secondaryCheckTintColorButton?.addTarget(self, action: "updateColorPopover:", forControlEvents: .TouchUpInside)
            cell.secondaryCheckTintColorButton?.tag = 2
            cell.backgroundColorButton?.backgroundColor = view.backgroundColor
            cell.backgroundColorButton?.addTarget(self, action: "updateColorPopover:", forControlEvents: .TouchUpInside)
            cell.backgroundColorButton?.tag = 3
        }
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(min(collectionView.frame.size.width, 280), collectionView.frame.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if let size = (collectionView.delegate as! UICollectionViewDelegateFlowLayout).collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: section)) {
            if layout.scrollDirection == .Horizontal {
                return max((collectionView.bounds.size.width - size.width) / 3.0, 20.0)
            } else {
                return max((collectionView.bounds.size.height - size.height) / 3.0, 20.0)
            }
        }
        return 20.0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let attributes = layout.layoutAttributesForItemAtIndexPath(indexPath) {
            let center = (layout.scrollDirection == .Horizontal ? collectionView.frame.size.width : collectionView.frame.size.height ) / 2.0
            let cellCenter = (layout.scrollDirection == .Horizontal ? attributes.frame.size.width : attributes.frame.size.height) / 2.0
            let cellPosition = layout.scrollDirection == .Horizontal ? attributes.frame.origin.x : attributes.frame.origin.y
            if layout.scrollDirection == .Horizontal {
                print("Tap: ", indexPath.item, " Offset: ", cellPosition + cellCenter - center)
                collectionView.setContentOffset(CGPoint(x: cellPosition + cellCenter - center, y: 0.0), animated: true)
            } else {
                collectionView.setContentOffset(CGPoint(x: 0.0, y: cellPosition + cellCenter - center), animated: true)
            }
        }
        
        
        
        let position: UICollectionViewScrollPosition = layout.scrollDirection == .Horizontal ? .CenteredHorizontally : .CenteredVertically
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: position, animated: true)
    }
    
    //----------------------------
    // MARK: - Navigation
    //----------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedCollectionViewSegue" {
            if let destination = segue.destinationViewController as? UICollectionViewController {
                collectionView = destination.collectionView
                if let collectionView = collectionView {
                    collectionView.dataSource = self
                    collectionView.delegate = self
                    collectionView.setCollectionViewLayout(layout, animated: false)
                }
            }
        } else if segue.identifier == "colorPickerPopover" {
            let destination = segue.destinationViewController
            destination.modalPresentationStyle = .Popover
            destination.popoverPresentationController?.delegate = self
            if let popoverPresentationController = destination.popoverPresentationController {
                popoverPresentationController.sourceView = sender as! UIButton
                popoverPresentationController.sourceRect = (sender as! UIButton).bounds
            }
            if let colorControl = destination.view as? HRColorPickerView {
                colorControl.tag = (sender as! UIButton).tag
                colorControl.color = (sender as! UIButton).backgroundColor
                colorControl.addTarget(self, action: "updateColor:", forControlEvents: .ValueChanged)
                colorControl.colorMapView.layer.cornerRadius = 3.0
            }
            currentColorButton = sender as? UIButton
        } else if segue.identifier == "animaitonPickerPopover" {
            let destination = segue.destinationViewController
            destination.modalPresentationStyle = .Popover
            destination.popoverPresentationController?.delegate = self
            (destination as? AnimationSelectionTableViewController)?.delegate = self
            if let popoverPresentationController = destination.popoverPresentationController {
                popoverPresentationController.sourceView = sender as! UIButton
                popoverPresentationController.sourceRect = (sender as! UIButton).bounds
            }
            currentColorButton = sender as? UIButton
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    //----------------------------
    // MARK: - Actions
    //----------------------------
    
    func updateCheckboxState(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            checkbox?.setCheckState(.Unchecked, animated: true)
        } else if sender.selectedSegmentIndex == 1 {
            checkbox?.setCheckState(.Checked, animated: true)
        } else {
            checkbox?.setCheckState(.Mixed, animated: true)
        }
    }
    
    func updateAnimationDuration(sender: UISlider) {
        checkbox?.animationDuration = NSTimeInterval(sender.value)
    }
    
    func updateMarkLineWidth(sender: UISlider) {
        checkbox?.checkmarkLineWidth = CGFloat(sender.value)
    }
    
    func updateBoxLineWidth(sender: UISlider) {
        checkbox?.boxLineWidth = CGFloat(sender.value)
    }
    
    func updateBoxShape(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            checkbox?.boxType = .Circle
        } else {
            checkbox?.boxType = .Square
        }
    }
    
    func updateMarkType(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            checkbox?.markType = .Checkmark
        } else {
            checkbox?.markType = .Radio
        }
    }
    
    func updateAnimation(sender: UIButton) {
        performSegueWithIdentifier("animaitonPickerPopover", sender: sender)
    }
    
    func selectedAnimation(animation: M13Checkbox.Animation) {
        checkbox?.stateChangeAnimation = animation
        collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forItem: 2, inSection: 0)])
    }
    
    func updateAnimationStyle(sender: UISegmentedControl) {
        if let animation = checkbox?.stateChangeAnimation {
            switch animation {
            case .Bounce:
                checkbox?.stateChangeAnimation = .Bounce(sender.selectedSegmentIndex == 0 ? .Stroke : .Fill)
                break
            case .Expand:
                checkbox?.stateChangeAnimation = .Expand(sender.selectedSegmentIndex == 0 ? .Stroke : .Fill)
                break
            case .Flat:
                checkbox?.stateChangeAnimation = .Flat(sender.selectedSegmentIndex == 0 ? .Stroke : .Fill)
                break
            case .Fade:
                checkbox?.stateChangeAnimation = .Fade(sender.selectedSegmentIndex == 0 ? .Stroke : .Fill)
                break
            case .Dot:
                checkbox?.stateChangeAnimation = .Dot(sender.selectedSegmentIndex == 0 ? .Stroke : .Fill)
                break
            default:
                break
            }
        }
    }
    
    func updateColorPopover(sender: UIButton) {
        performSegueWithIdentifier("colorPickerPopover", sender: sender)
    }
    
    func updateColor(sender: HRColorPickerView) {
        currentColorButton?.backgroundColor = sender.color
        if sender.tag == 0 {
            checkbox?.tintColor = sender.color
        } else if sender.tag == 1 {
            checkbox?.secondaryTintColor = sender.color
        } else if sender.tag == 2 {
            checkbox?.secondaryCheckmarkTintColor = sender.color
        } else if sender.tag == 3 {
            view.backgroundColor = sender.color
        }
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}
