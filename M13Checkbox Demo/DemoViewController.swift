//
//  DemoViewController.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit
import M13Checkbox
import Color_Picker_for_iOS
import PBDCarouselCollectionViewLayout

class DemoViewController: UIViewController, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, UICollectionViewDelegateFlowLayout, AnimationSelectionTableViewControllerDelegate {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    @IBOutlet weak var checkbox: M13Checkbox?
    
    fileprivate weak var currentColorButton: UIButton?
    
    fileprivate var collectionView: UICollectionView?
    fileprivate var layout: CollectionViewLayout = CollectionViewLayout()
    fileprivate var maskLayer: CAGradientLayer = CAGradientLayer()
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //----------------------------
    // MARK: - Collection View Data Source
    //----------------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if (indexPath as NSIndexPath).item == 0 {
            // States cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentedControlCell", for: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "CheckboxState")
            cell.titleLabel?.text = "Checkbox State"
            cell.bodyLabel?.text = "The checkbox has three possible states: Unchecked, Checked, and Mixed."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegment(withTitle: "Unchecked", at: 0, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "Checked", at: 1, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "Mixed", at: 2, animated: false)
            
            if let state = checkbox?.checkState {
                switch state {
                case .unchecked:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    break
                case .checked:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    break
                case .mixed:
                    cell.segmentedControl?.selectedSegmentIndex = 2
                    break
                }
            }
            cell.segmentedControl?.isEnabled = true
            
            cell.segmentedControl?.addTarget(self, action: #selector(DemoViewController.updateCheckboxState(_:)), for: .valueChanged)
            
        } else if (indexPath as NSIndexPath).item == 1 {
            // Animated cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath)
            guard let cell = cell as? SelectionCollectionViewCell else {
                fatalError()
            }
            
            cell.iconView?.image = UIImage(named: "Animation")
            cell.titleLabel?.text = "Animation"
            cell.bodyLabel?.text = "Several animations are available for switching between states."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            switch checkbox!.stateChangeAnimation {
            case .stroke:
                cell.selectionButton?.setTitle("Stroke", for: UIControlState())
            case .fill:
                cell.selectionButton?.setTitle("Fill", for: UIControlState())
            case .bounce:
                cell.selectionButton?.setTitle("Bounce", for: UIControlState())
            case .expand:
                cell.selectionButton?.setTitle("Expand", for: UIControlState())
            case .flat:
                cell.selectionButton?.setTitle("Flat", for: UIControlState())
            case .spiral:
                cell.selectionButton?.setTitle("Spiral", for: UIControlState())
            case .fade:
                cell.selectionButton?.setTitle("Fade", for: UIControlState())
            case .dot:
                cell.selectionButton?.setTitle("Dot", for: UIControlState())
            }
            
            cell.selectionButton?.addTarget(self, action: #selector(DemoViewController.updateAnimation(_:)), for: .touchUpInside)
            
        }  else if (indexPath as NSIndexPath).item == 2 {
            // States cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentedControlCell", for: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "AnimationStyle")
            cell.titleLabel?.text = "Animation Style"
            cell.bodyLabel?.text = "Some animations have multiple styles."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegment(withTitle: "Stroke", at: 0, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "Fill", at: 1, animated: false)
            
            if let animation = checkbox?.stateChangeAnimation {
                switch animation {
                case .stroke:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    cell.segmentedControl?.isEnabled = false
                case .fill:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    cell.segmentedControl?.isEnabled = false
                case let .bounce(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .stroke ? 0 : 1
                    cell.segmentedControl?.isEnabled = true
                case let .expand(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .stroke ? 0 : 1
                    cell.segmentedControl?.isEnabled = true
                case let .flat(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .stroke ? 0 : 1
                    cell.segmentedControl?.isEnabled = true
                case .spiral:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    cell.segmentedControl?.isEnabled = false
                case let .fade(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .stroke ? 0 : 1
                    cell.segmentedControl?.isEnabled = true
                case let .dot(style):
                    cell.segmentedControl?.selectedSegmentIndex = style == .stroke ? 0 : 1
                    cell.segmentedControl?.isEnabled = true
                }
            }
            
            cell.segmentedControl?.addTarget(self, action: #selector(DemoViewController.updateAnimationStyle(_:)), for: .valueChanged)
            
        } else if (indexPath as NSIndexPath).item == 3 {
            // Animated cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath)
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
            cell.slider?.addTarget(self, action: #selector(DemoViewController.updateAnimationDuration(_:)), for: .valueChanged)
        } else if (indexPath as NSIndexPath).item == 4 {
            // States cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentedControlCell", for: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "Morph")
            cell.titleLabel?.text = "Morphing"
            cell.bodyLabel?.text = "The checkbox can either morph between states with marks, or it can animate the old mark out, and the new mark in."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegment(withTitle: "Enabled", at: 0, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "Disabled", at: 1, animated: false)
            
            if checkbox?.enableMorphing == true {
                cell.segmentedControl?.selectedSegmentIndex = 0
            } else {
                cell.segmentedControl?.selectedSegmentIndex = 1
            }
            cell.segmentedControl?.isEnabled = true

            cell.segmentedControl?.addTarget(self, action: #selector(DemoViewController.updateMorphEnabled(_:)), for: .valueChanged)
            
        } else if (indexPath as NSIndexPath).item == 5 {
            // States cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentedControlCell", for: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "MarkType")
            cell.titleLabel?.text = "Mark Type"
            cell.bodyLabel?.text = "The checkbox supports several mark combinations, including a radio style checkbox."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegment(withTitle: "Checkmark", at: 0, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "Radio", at: 1, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "+/-", at: 2, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "Disclosure", at: 3, animated: false)
            
            if let state = checkbox?.markType {
                switch state {
                case .checkmark:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    break
                case .radio:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    break
                case .addRemove:
                    cell.segmentedControl?.selectedSegmentIndex = 2
                    break
                case .disclosure:
                    cell.segmentedControl?.selectedSegmentIndex = 3
                    break
                }
            }
            cell.segmentedControl?.isEnabled = true
            
            cell.segmentedControl?.addTarget(self, action: #selector(DemoViewController.updateMarkType(_:)), for: .valueChanged)
            
        } else if (indexPath as NSIndexPath).item == 6 {
            // States cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentedControlCell", for: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "BoxShape")
            cell.titleLabel?.text = "Box Shape"
            cell.bodyLabel?.text = "The box can either be a circle or a square. If the box is a square, its corner radius can be changed."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.segmentedControl?.removeAllSegments()
            cell.segmentedControl?.insertSegment(withTitle: "Circle", at: 0, animated: false)
            cell.segmentedControl?.insertSegment(withTitle: "Square", at: 1, animated: false)
            
            if let state = checkbox?.boxType {
                switch state {
                case .circle:
                    cell.segmentedControl?.selectedSegmentIndex = 0
                    break
                case .square:
                    cell.segmentedControl?.selectedSegmentIndex = 1
                    break
                }
            }
            cell.segmentedControl?.isEnabled = true
            
            cell.segmentedControl?.addTarget(self, action: #selector(DemoViewController.updateBoxShape(_:)), for: .valueChanged)
            
        } else if (indexPath as NSIndexPath).item == 7 {
            // Animated cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath)
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
            cell.slider?.addTarget(self, action: #selector(DemoViewController.updateMarkLineWidth(_:)), for: .valueChanged)
        } else if (indexPath as NSIndexPath).item == 8 {
            // Animated cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath)
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
            cell.slider?.addTarget(self, action: #selector(DemoViewController.updateBoxLineWidth(_:)), for: .valueChanged)
        } else if (indexPath as NSIndexPath).item == 9 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
            guard let cell = cell as? ColorCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = UIImage(named: "Colors")
            cell.titleLabel?.text = "Colors"
            cell.bodyLabel?.text = "The checkbox has three customizable colors, the tint color, secondary tint color, and the secondary check tint color."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.tintColorButton?.backgroundColor = checkbox?.tintColor
            cell.tintColorButton?.addTarget(self, action: #selector(DemoViewController.updateColorPopover(_:)), for: .touchUpInside)
            cell.tintColorButton?.tag = 0
            cell.secondaryTintColorButton?.backgroundColor = checkbox?.secondaryTintColor
            cell.secondaryTintColorButton?.addTarget(self, action: #selector(DemoViewController.updateColorPopover(_:)), for: .touchUpInside)
            cell.secondaryTintColorButton?.tag = 1
            cell.secondaryCheckTintColorButton?.backgroundColor = checkbox?.secondaryCheckmarkTintColor
            cell.secondaryCheckTintColorButton?.addTarget(self, action: #selector(DemoViewController.updateColorPopover(_:)), for: .touchUpInside)
            cell.secondaryCheckTintColorButton?.tag = 2
            cell.backgroundColorButton?.backgroundColor = view.backgroundColor
            cell.backgroundColorButton?.addTarget(self, action: #selector(DemoViewController.updateColorPopover(_:)), for: .touchUpInside)
            cell.backgroundColorButton?.tag = 3
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: min(collectionView.frame.size.width, 280), height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let size = (collectionView.delegate as! UICollectionViewDelegateFlowLayout).collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: section)) {
            if layout.scrollDirection == .horizontal {
                return max((collectionView.bounds.size.width - size.width) / 3.0, 20.0)
            } else {
                return max((collectionView.bounds.size.height - size.height) / 3.0, 20.0)
            }
        }
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let attributes = layout.layoutAttributesForItem(at: indexPath) {
            let center = (layout.scrollDirection == .horizontal ? collectionView.frame.size.width : collectionView.frame.size.height ) / 2.0
            let cellCenter = (layout.scrollDirection == .horizontal ? attributes.frame.size.width : attributes.frame.size.height) / 2.0
            let cellPosition = layout.scrollDirection == .horizontal ? attributes.frame.origin.x : attributes.frame.origin.y
            if layout.scrollDirection == .horizontal {
                print("Tap: ", (indexPath as NSIndexPath).item, " Offset: ", cellPosition + cellCenter - center)
                collectionView.setContentOffset(CGPoint(x: cellPosition + cellCenter - center, y: 0.0), animated: true)
            } else {
                collectionView.setContentOffset(CGPoint(x: 0.0, y: cellPosition + cellCenter - center), animated: true)
            }
        }
        
        
        
        let position: UICollectionViewScrollPosition = layout.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        collectionView.scrollToItem(at: indexPath, at: position, animated: true)
    }
    
    //----------------------------
    // MARK: - Navigation
    //----------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedCollectionViewSegue" {
            if let destination = segue.destination as? UICollectionViewController {
                collectionView = destination.collectionView
                if let collectionView = collectionView {
                    collectionView.dataSource = self
                    collectionView.delegate = self
                    collectionView.setCollectionViewLayout(layout, animated: false)
                }
            }
        } else if segue.identifier == "colorPickerPopover" {
            let destination = segue.destination
            destination.modalPresentationStyle = .popover
            destination.popoverPresentationController?.delegate = self
            if let popoverPresentationController = destination.popoverPresentationController {
                popoverPresentationController.sourceView = sender as! UIButton
                popoverPresentationController.sourceRect = (sender as! UIButton).bounds
            }
            if let colorControl = destination.view as? HRColorPickerView {
                colorControl.tag = (sender as! UIButton).tag
                colorControl.color = (sender as! UIButton).backgroundColor
                colorControl.addTarget(self, action: #selector(DemoViewController.updateColor(_:)), for: .valueChanged)
                colorControl.colorMapView.layer.cornerRadius = 3.0
            }
            currentColorButton = sender as? UIButton
        } else if segue.identifier == "animaitonPickerPopover" {
            let destination = segue.destination
            destination.modalPresentationStyle = .popover
            destination.popoverPresentationController?.delegate = self
            (destination as? AnimationSelectionTableViewController)?.delegate = self
            if let popoverPresentationController = destination.popoverPresentationController {
                popoverPresentationController.sourceView = sender as! UIButton
                popoverPresentationController.sourceRect = (sender as! UIButton).bounds
            }
            currentColorButton = sender as? UIButton
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //----------------------------
    // MARK: - Actions
    //----------------------------
    
    @IBAction func checkboxValueChanged(_ sender: M13Checkbox) {
        if let cell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as? SegmentedControlCollectionViewCell {
            switch sender.checkState {
            case .unchecked:
                cell.segmentedControl?.selectedSegmentIndex = 0
                break
            case .checked:
                cell.segmentedControl?.selectedSegmentIndex = 1
                break
            case .mixed:
                cell.segmentedControl?.selectedSegmentIndex = 2
                break
            }
        }
    }
    
    func updateCheckboxState(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            checkbox?.setCheckState(.unchecked, animated: true)
        } else if sender.selectedSegmentIndex == 1 {
            checkbox?.setCheckState(.checked, animated: true)
        } else {
            checkbox?.setCheckState(.mixed, animated: true)
        }
    }
    
    func updateAnimationDuration(_ sender: UISlider) {
        checkbox?.animationDuration = TimeInterval(sender.value)
    }
    
    func updateMorphEnabled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            checkbox?.enableMorphing = true
        } else {
            checkbox?.enableMorphing = false
        }
    }
    
    func updateMarkLineWidth(_ sender: UISlider) {
        checkbox?.checkmarkLineWidth = CGFloat(sender.value)
    }
    
    func updateBoxLineWidth(_ sender: UISlider) {
        checkbox?.boxLineWidth = CGFloat(sender.value)
    }
    
    func updateBoxShape(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            checkbox?.boxType = .circle
        } else {
            checkbox?.boxType = .square
        }
    }
    
    func updateMarkType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            checkbox?.setMarkType(markType: .checkmark, animated: true)
        } else if sender.selectedSegmentIndex == 1 {
            checkbox?.setMarkType(markType: .radio, animated: true)
        } else if sender.selectedSegmentIndex == 2 {
            checkbox?.setMarkType(markType: .addRemove, animated: true)
        } else if sender.selectedSegmentIndex == 3 {
            checkbox?.setMarkType(markType: .disclosure, animated: true)
        }
    }
    
    func updateAnimation(_ sender: UIButton) {
        performSegue(withIdentifier: "animaitonPickerPopover", sender: sender)
    }
    
    func selectedAnimation(_ animation: M13Checkbox.Animation) {
        checkbox?.stateChangeAnimation = animation
        
        if let cell = collectionView?.cellForItem(at: IndexPath(item: 1, section: 0)) as? SelectionCollectionViewCell {
            switch animation {
            case .stroke:
                cell.selectionButton?.setTitle("Stroke", for: UIControlState())
            case .fill:
                cell.selectionButton?.setTitle("Fill", for: UIControlState())
            case .bounce:
                cell.selectionButton?.setTitle("Bounce", for: UIControlState())
            case .expand:
                cell.selectionButton?.setTitle("Expand", for: UIControlState())
            case .flat:
                cell.selectionButton?.setTitle("Flat", for: UIControlState())
            case .spiral:
                cell.selectionButton?.setTitle("Spiral", for: UIControlState())
            case .fade:
                cell.selectionButton?.setTitle("Fade", for: UIControlState())
            case .dot:
                cell.selectionButton?.setTitle("Dot", for: UIControlState())
            }
        }
        
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 0)])
    }
    
    func updateAnimationStyle(_ sender: UISegmentedControl) {
        if let animation = checkbox?.stateChangeAnimation {
            switch animation {
            case .bounce:
                checkbox?.stateChangeAnimation = .bounce(sender.selectedSegmentIndex == 0 ? .stroke : .fill)
                break
            case .expand:
                checkbox?.stateChangeAnimation = .expand(sender.selectedSegmentIndex == 0 ? .stroke : .fill)
                break
            case .flat:
                checkbox?.stateChangeAnimation = .flat(sender.selectedSegmentIndex == 0 ? .stroke : .fill)
                break
            case .fade:
                checkbox?.stateChangeAnimation = .fade(sender.selectedSegmentIndex == 0 ? .stroke : .fill)
                break
            case .dot:
                checkbox?.stateChangeAnimation = .dot(sender.selectedSegmentIndex == 0 ? .stroke : .fill)
                break
            default:
                break
            }
        }
    }
    
    func updateColorPopover(_ sender: UIButton) {
        performSegue(withIdentifier: "colorPickerPopover", sender: sender)
    }
    
    func updateColor(_ sender: HRColorPickerView) {
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
