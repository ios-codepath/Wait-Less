//
//  BillItemCell.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/14/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class BillItemCell: UITableViewCell {

    var billItem: BillItem! {
        didSet {
            self.itemNameLabel.text = "\(billItem.name)"
            self.priceLabel.text = "$\(billItem.price)"
        }
    }
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.70)
    }
}
