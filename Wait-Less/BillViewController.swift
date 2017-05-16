//
//  BillViewController.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/4/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import NotificationBannerSwift

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class BillViewController: UIViewController {

    var order: Order!
    
    var bill: Bill!
    
    var billItems: [BillItem] = []
    
    let billItemCellId = "BillItemCell"
    
    let billActionCellId = "BillButtonCell"
    
    let billInputCellId = "BillInputCell"
    
    let taxRate: Double = 0.09
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billItems = order.menuItems.map {
            return BillItem(name: $0.name, price: $0.price)
        }
        bill = Bill(order: order)
        
        let subtotal = bill.getSubTotal()
        
        billItems.append(BillItem(name: "Subtotal", price: subtotal))
        billItems.append(BillItem(name: "Total", price: (subtotal * (1+taxRate)).roundTo(places: 2)))
        
        setupTableView()
        tableView.reloadData()
        tableView.backgroundColor = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.70)
        tableView.backgroundView = UIImageView.init(image: UIImage(named: "background.jpg"))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let billItemCellNib = UINib(nibName: "BillItemCell", bundle: Bundle.main)
        tableView.register(billItemCellNib, forCellReuseIdentifier: billItemCellId)
        
        let billActionCellNib = UINib(nibName: "BillButtonCell", bundle: Bundle.main)
        tableView.register(billActionCellNib, forCellReuseIdentifier: billActionCellId)
        
        let billInputCellNib = UINib(nibName: "BillInputFieldCell", bundle: Bundle.main)
        tableView.register(billInputCellNib, forCellReuseIdentifier: billInputCellId)
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension BillViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BillViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return billItems.count
        } else {
            return 1 // for button, input cells
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
          return "Ordered Items"
        } else if section == 4 {
            return "Ready to pay?"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: billItemCellId, for: indexPath) as! BillItemCell
            
            cell.billItem = billItems[indexPath.row]
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: billInputCellId, for: indexPath) as! BillInputFieldCell
            cell.creditCardField.isHidden = true
            cell.name = "Tip:"
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: billInputCellId, for: indexPath) as! BillInputFieldCell
            cell.inputField.isHidden = true
            cell.name = "Credit Card:"
            cell.delegate = self
            return cell
        default:
            // button cell as default
            let cell = tableView.dequeueReusableCell(withIdentifier: billActionCellId, for: indexPath) as! BillButtonCell
            cell.delegate = self
            return cell
        }
    }
}

extension BillViewController: BillInputFieldCellDelegate, BillButtonCellDelegate {
    func billInputFieldCell(_ cell: BillInputFieldCell, text changedTo: String?) {
        let amount = changedTo ?? "00"
        print("amount: \(amount)")
    }
    
    func billButtonCell(_ cell: BillButtonCell, action: BillButtons) {
        if action == .clear {
            tableView.reloadData()
        } else if action == .pay {

            bill.isPaid = true
            bill.saveInBackground(block: { (success, error) in
                if error != nil {
                    let errorMsg = NotificationBanner(title: "Error in processing bill", subtitle: nil, leftView: nil, rightView: nil, style: BannerStyle.warning, colors: nil)
                    errorMsg.show()
                    return
                }
                if success {
                    let successMsg = NotificationBanner(title: "Bill Paid, Thank you!", subtitle: nil, leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                    successMsg.show()
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
}
