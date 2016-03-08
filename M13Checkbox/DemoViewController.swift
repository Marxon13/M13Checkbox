//
//  DemoViewController.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    @IBOutlet weak var checkbox: M13Checkbox?
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //----------------------------
    // MARK: - Collection View Data Source
    //----------------------------
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if indexPath.item == 0 {
            // States cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("segmentedControlCell", forIndexPath: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = nil
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
            
            cell.segmentedControl?.addTarget(self, action: "updateCheckboxState:", forControlEvents: .ValueChanged)
            
        } else if indexPath.item == 1 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionCell", forIndexPath: indexPath)
            guard let cell = cell as? SelectionCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = nil
            cell.titleLabel?.text = "Animation"
            cell.bodyLabel?.text = "Several animations are available for switching between states."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            var buttonTitle: String = "None"
            if let animation = checkbox?.stateChangeAnimation {
                switch animation {
                case .Stroke:
                    buttonTitle = "Stroke"
                case .Fill:
                    buttonTitle = "Fill"
                case .Bounce:
                    buttonTitle = "Bounce"
                case .Expand:
                     buttonTitle = "Expand"
                case .Flat:
                    buttonTitle = "Flat"
                case .Spiral:
                    buttonTitle = "Spiral"
                case .Fade:
                    buttonTitle = "Fade"
                case .Dot:
                    buttonTitle = "Dot"
                }
            }
            cell.selectionButton?.setTitle(buttonTitle, forState: .Normal)
            
            cell.selectionButton?.addTarget(self, action: "updateAnimation:", forControlEvents: .TouchUpInside)
            
        } else if indexPath.item == 2 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sliderCell", forIndexPath: indexPath)
            guard let cell = cell as? SliderCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = nil
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
        } else if indexPath.item == 3 {
            // States cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("segmentedControlCell", forIndexPath: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = nil
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
            
            cell.segmentedControl?.addTarget(self, action: "updateMarkType:", forControlEvents: .ValueChanged)
            
        }  else if indexPath.item == 4 {
            // States cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("segmentedControlCell", forIndexPath: indexPath)
            guard let cell = cell as? SegmentedControlCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = nil
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
            
            cell.segmentedControl?.addTarget(self, action: "updateBoxShape:", forControlEvents: .ValueChanged)
            
        } else if indexPath.item == 5 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sliderCell", forIndexPath: indexPath)
            guard let cell = cell as? SliderCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = nil
            cell.titleLabel?.text = "Mark Line Width"
            cell.bodyLabel?.text = "The line width of the checkmark or radio button can be changed."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.slider?.minimumValue = 1.0
            cell.slider?.maximumValue = 10.0
            if let lineWidth = checkbox?.checkmarkLineWidth {
                cell.slider?.value = Float(lineWidth)
            }
            cell.slider?.addTarget(self, action: "updateMarkLineWidth:", forControlEvents: .ValueChanged)
        } else if indexPath.item == 6 {
            // Animated cell
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("sliderCell", forIndexPath: indexPath)
            guard let cell = cell as? SliderCollectionViewCell else {
                fatalError()
            }
            cell.iconView?.image = nil
            cell.titleLabel?.text = "Box Line Width"
            cell.bodyLabel?.text = "The line width of the box can be changed."
            cell.bodyLabel?.sizeToFit()
            cell.setNeedsLayout()
            
            cell.slider?.minimumValue = 1.0
            cell.slider?.maximumValue = 10.0
            if let lineWidth = checkbox?.boxLineWidth {
                cell.slider?.value = Float(lineWidth)
            }
            cell.slider?.addTarget(self, action: "updateBoxLineWidth:", forControlEvents: .ValueChanged)
        }
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(min(collectionView.frame.size.width, 280), collectionView.frame.size.height)
    }
    
    //----------------------------
    // MARK: - Navigation
    //----------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedCollectionViewSegue" {
            if let destination = segue.destinationViewController as? UICollectionViewController {
                destination.collectionView?.dataSource = self
                destination.collectionView?.delegate = self
            }
        }
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
        
    }
}
