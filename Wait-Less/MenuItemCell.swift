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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
