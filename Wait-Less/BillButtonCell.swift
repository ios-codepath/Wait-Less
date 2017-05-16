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
        self.backgroundColor = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.70)
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        delegate?.billButtonCell(self, action: BillButtons.clear)
    }

    @IBAction func didTapPayBillButton(_ sender: Any) {
        delegate?.billButtonCell(self, action: BillButtons.pay)
    }
}
