//
//  TableCell.swift
//  Wait-Less
//
//  Created by Waseem Mohd on 4/27/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class TableCell: UICollectionViewCell {
    
    @IBOutlet weak var tableItem: UIView!
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!

    func updateCell() {
        tableItem.layer.cornerRadius = 3
        tableItem.clipsToBounds = true
        tableItem.layer.shadowOffset = CGSize(width: 0, height: 1)
        tableItem.layer.shadowOpacity = 0.25
        tableItem.layer.shadowRadius = 2
    }
}
