//
//  MenuItemTableViewCell.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/25/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

protocol MenuItemTableViewCellDelegate: class {
    func menuItemTableViewCellDelegate(_ cell: MenuItemTableViewCell, didOrder menuItem: Menu2)
}

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    var numberFormatter: NumberFormatter?
    weak var delegate: MenuItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var menuItem: Menu2! {
        didSet {
            menuItemLabel.text = menuItem.name
            
            if let formatted = numberFormatter?.string(from: menuItem.price as NSNumber) {
                priceLabel.text = formatted
            }
        }
    }
    
    var isAdding: Bool = false {
        didSet {
            if isAdding {
                orderButton.setTitle("+", for: .normal)
                orderButton.setTitle("+", for: .highlighted)
                orderButton.setTitle("+", for: .selected)
            } else {
                orderButton.setTitle("-", for: .normal)
                orderButton.setTitle("-", for: .highlighted)
                orderButton.setTitle("-", for: .selected)
            }
        }
    }
    
    @IBAction func onOrderButton(_ sender: Any) {
        delegate?.menuItemTableViewCellDelegate(self, didOrder: menuItem)
    }
}
