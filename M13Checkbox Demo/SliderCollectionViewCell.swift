//
//  SwitchCollectionViewCell.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class SliderCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var slider: UISlider?
    
    override func prepareForReuse() {
        slider?.removeTarget(nil, action: nil, for: .allEvents)
    }
}

