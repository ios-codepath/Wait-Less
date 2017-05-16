//
//  BillInputFieldCell.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/07/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

@objc protocol BillInputFieldCellDelegate: class {
    func billInputFieldCell(_ cell: BillInputFieldCell, text changedTo: String?)
}

class BillInputFieldCell: UITableViewCell {

    var name: String! {
        didSet {
            self.nameLabel.text = name
            inputField.text = "$"
            creditCardField.text = ""
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var inputField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var creditCardField: SkyFloatingLabelTextField!
    
    weak var delegate: BillInputFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.70)
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        inputField.addTarget(self, action: #selector(self.textDidChange(sender:)), for: UIControlEvents.editingChanged)
        creditCardField.addTarget(self, action: #selector(self.textDidChange(sender:)), for: UIControlEvents.editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func textDidChange(sender: UITextField) {
        delegate?.billInputFieldCell(self, text: sender.text)
    }
}
