//
//  SegmentedControlCollectionViewCell.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class SegmentedControlCollectionViewCell: BaseCollectionViewCell { 
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    override func prepareForReuse() {
        segmentedControl?.removeTarget(nil, action: nil, for: .allEvents)
    }
}
