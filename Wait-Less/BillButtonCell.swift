//
//  BillButtonCell.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/07/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

@objc public enum BillButtons: Int {
    case clear = 0
    case pay = 1
}

@objc protocol BillButtonCellDelegate: class {
    func billButtonCell(_ cell: BillButtonCell, action: BillButtons)
}

class BillButtonCell: UITableViewCell {

    weak var delegate: BillButtonCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // not selectable
        super.setSelected(false, animated: animated)
        
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        delegate?.billButtonCell(self, action: BillButtons.clear)
    }
    
    
    @IBAction func didTapPayBillButton(_ sender: Any) {
        delegate?.billButtonCell(self, action: BillButtons.pay)
    }
    
    
}
