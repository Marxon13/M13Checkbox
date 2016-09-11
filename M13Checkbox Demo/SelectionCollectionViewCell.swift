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
        selectionButton?.layer.borderColor = selectionButton?.tintColor.cgColor
        selectionButton?.layer.borderWidth = 1.0
    }
    
    override func prepareForReuse() {
        selectionButton?.removeTarget(nil, action: nil, for: .allEvents)
    }
}
