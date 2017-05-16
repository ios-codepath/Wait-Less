//
//  TableCell.swift
//  Wait-Less
//
//  Created by Waseem Mohd on 4/27/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

@objc protocol TableCellDelegate {
    @objc optional func tableCellUpdate(tableData: Table2) -> Void
}

class TableCell: UICollectionViewCell {
    
    @IBOutlet weak var tableItem: UIView!
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!

    weak var delegate: TableCellDelegate?

    var tableData: Table2! {
        didSet {
            updateCell(withTableData: tableData)
        }
    }

    private func updateCell(withTableData: Table2) {
        tableItem.layer.cornerRadius = 3
        tableItem.clipsToBounds = true
        tableItem.layer.backgroundColor = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.70).cgColor
        tableNumberLabel.text = tableData.tableNumber
        statusLabel.text = tableData.status ? "Available" : "Reserved"
        capacityLabel.text = String(format: "Capacity: %@", tableData.capacity)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    override func awakeFromNib() {
        reserveButton.layer.cornerRadius = 4
    }

    @objc func onTap() {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        UIView.transition(with: self.tableItem, duration: 1.0, options: transitionOptions, animations: {
            self.tableImageView.isHidden = !self.tableImageView.isHidden
            self.statusLabel.isHidden = !self.statusLabel.isHidden
            self.capacityLabel.isHidden = !self.capacityLabel.isHidden
            self.reserveButton.isHidden = !self.reserveButton.isHidden
        })
    }
    
    @IBAction func reserveButtonTapped(_ sender: UIButton) {
        delegate?.tableCellUpdate!(tableData: tableData)
    }
}
