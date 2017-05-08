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
