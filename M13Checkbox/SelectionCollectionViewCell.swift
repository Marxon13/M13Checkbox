//
//  SelectionCollectionViewCell.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/8/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class SelectionCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var selectionButton: UIButton?
    
    override func awakeFromNib() {
        selectionButton?.layer.cornerRadius = 4.0
        selectionButton?.layer.borderColor = selectionButton?.tintColor.CGColor
        selectionButton?.layer.borderWidth = 1.0
    }
}