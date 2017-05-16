//
//  OrderActionCell.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/7/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

@objc public enum OrderActionButton: Int {
    case billButton = 0
    case callWaiterButton = 1
}

@objc protocol OrderActionCellDelegate: class {
    
    func orderActionCell(_ cell: OrderActionCell, buttonType: OrderActionButton)
}

class OrderActionCell: UITableViewCell {

    weak var delegate: OrderActionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.70)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapPayBillButton(_ sender: Any) {
        delegate?.orderActionCell(self, buttonType: OrderActionButton.billButton)
    }
    
    
    @IBAction func didTapCallWaiterButton(_ sender: Any) {
        delegate?.orderActionCell(self, buttonType: OrderActionButton.callWaiterButton)
    }
}
