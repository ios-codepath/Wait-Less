//
//  MenuItemCell.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/7/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var menuItem: Menu2! {
        didSet {
            itemName.text = menuItem.name
            priceLabel.text = "$\(menuItem.price)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.70)
    }
}
