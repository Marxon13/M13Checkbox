//
//  AnimationSelectionTableViewController.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/11/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

protocol AnimationSelectionTableViewControllerDelegate {
    func selectedAnimation(animation: M13Checkbox.Animation)
}

class AnimationSelectionTableViewController: UITableViewController {
    
    let animations: [M13Checkbox.Animation] = [.Stroke, .Fill, .Bounce(.Stroke), .Expand(.Stroke), .Flat(.Stroke), .Spiral, .Fade(.Stroke), .Dot(.Stroke)]
    var delegate: AnimationSelectionTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView?.backgroundColor = UIColor.clearColor()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("animationCell", forIndexPath: indexPath)

        let animation = animations[indexPath.row]
        
        switch animation {
        case .Stroke:
            cell.textLabel?.text = "Stroke"
            cell.imageView?.image = UIImage(named: "Stroke")
        case .Fill:
            cell.textLabel?.text = "Fill"
            cell.imageView?.image = UIImage(named: "Fill")
        case .Bounce:
            cell.textLabel?.text = "Bounce"
            cell.imageView?.image = UIImage(named: "Bounce")
        case .Expand:
            cell.textLabel?.text = "Expand"
            cell.imageView?.image = UIImage(named: "Expand")
        case .Flat:
            cell.textLabel?.text = "Flat"
            cell.imageView?.image = UIImage(named: "Flat")
        case .Spiral:
            cell.textLabel?.text = "Spiral"
            cell.imageView?.image = UIImage(named: "Spiral")
        case .Fade:
            cell.textLabel?.text = "Fade"
            cell.imageView?.image = UIImage(named: "Fade")
        case .Dot:
            cell.textLabel?.text = "Dot"
            cell.imageView?.image = UIImage(named: "Dot")
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.selectedAnimation(animations[indexPath.row])
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}

@IBDesignable
class AnimationCell: UITableViewCell {

    @IBInspectable var imageSize: CGSize = CGSizeZero
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
        imageView.frame = CGRectMake(imageView.frame.origin.x, (frame.size.height - imageSize.height) / 2.0, imageSize.width, imageSize.height)
        }
    }
    
}
