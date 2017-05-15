//
//  BillInputFieldCell.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/07/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

@objc protocol BillInputFieldCellDelegate: class {
    
    func billInputFieldCell(_ cell: BillInputFieldCell, text changedTo: String?)
    
    @objc optional func billInputFieldCell(change textTo: String?) -> Bool
    
}

class BillInputFieldCell: UITableViewCell {

    var name: String! {
        didSet {
            self.nameLabel.text = name
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var inputField: UITextField!
    
    weak var delegate: BillInputFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputField.addTarget(self, action: #selector(self.textDidChange(sender:)), for: UIControlEvents.editingChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func textDidChange(sender: UITextField) {
        delegate?.billInputFieldCell(self, text: sender.text)
    }
}
