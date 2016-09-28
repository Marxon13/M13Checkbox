//
//  AnimationSelectionTableViewController.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/11/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit
import M13Checkbox

protocol AnimationSelectionTableViewControllerDelegate {
    func selectedAnimation(_ animation: M13Checkbox.Animation)
}

class AnimationSelectionTableViewController: UITableViewController {
    
    let animations: [M13Checkbox.Animation] = [.stroke, .fill, .bounce(.stroke), .expand(.stroke), .flat(.stroke), .spiral, .fade(.stroke), .dot(.stroke)]
    var delegate: AnimationSelectionTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView?.backgroundColor = UIColor.clear
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animationCell", for: indexPath)

        let animation = animations[(indexPath as NSIndexPath).row]
        
        switch animation {
        case .stroke:
            cell.textLabel?.text = "Stroke"
            cell.imageView?.image = UIImage(named: "Stroke")
        case .fill:
            cell.textLabel?.text = "Fill"
            cell.imageView?.image = UIImage(named: "Fill")
        case .bounce:
            cell.textLabel?.text = "Bounce"
            cell.imageView?.image = UIImage(named: "Bounce")
        case .expand:
            cell.textLabel?.text = "Expand"
            cell.imageView?.image = UIImage(named: "Expand")
        case .flat:
            cell.textLabel?.text = "Flat"
            cell.imageView?.image = UIImage(named: "Flat")
        case .spiral:
            cell.textLabel?.text = "Spiral"
            cell.imageView?.image = UIImage(named: "Spiral")
        case .fade:
            cell.textLabel?.text = "Fade"
            cell.imageView?.image = UIImage(named: "Fade")
        case .dot:
            cell.textLabel?.text = "Dot"
            cell.imageView?.image = UIImage(named: "Dot")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedAnimation(animations[(indexPath as NSIndexPath).row])
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

@IBDesignable
class AnimationCell: UITableViewCell {

    @IBInspectable var imageSize: CGSize = CGSize.zero
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
        imageView.frame = CGRect(x: imageView.frame.origin.x, y: (frame.size.height - imageSize.height) / 2.0, width: imageSize.width, height: imageSize.height)
        }
    }
    
}
