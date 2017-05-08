//
//  OrderDetailViewController.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/4/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OrderActionCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let menuCellId = "MenuItemCell"
    
    let timeEstimateCellId = "TimeEstimateCell"
    
    let orderActionCellId = "OrderActionCell"
    
    var menuItems: [Menu2]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Order"
        setupTableview()
    }
    
    private func setupTableview() {
        if menuItems == nil {
            menuItems = [Menu2]()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let menuItemCellNib = UINib(nibName: "MenuItemCell", bundle: Bundle.main)
        tableView.register(menuItemCellNib, forCellReuseIdentifier: menuCellId)
        
        let timeEstimateCellNib = UINib(nibName: "TimeEstimateCell", bundle: Bundle.main)
        tableView.register(timeEstimateCellNib, forCellReuseIdentifier: timeEstimateCellId)
        
        let orderActionCellNib = UINib(nibName: "OrderActionCell", bundle: Bundle.main)
        
        tableView.register(orderActionCellNib, forCellReuseIdentifier: orderActionCellId)
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuItems?.count ?? 0
        }
        
        return 1 // for both section 1 and 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Ordered Items"
        case 1:
            return "Estimated Serve Time"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: menuCellId, for: indexPath) as! MenuItemCell
            cell.menuItem = menuItems![indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: timeEstimateCellId, for: indexPath) as! TimeEstimateCell
            
            cell.textLabel?.text = "5 Minutes Remaining..."
            return cell
        }
        
        let callWaiterCell = tableView.dequeueReusableCell(withIdentifier: orderActionCellId, for: indexPath) as! OrderActionCell
        
        callWaiterCell.delegate = self
        
        return callWaiterCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // TODO: handle select event here
        }
    }
    
    func orderActionCell(_ cell: OrderActionCell, buttonType: OrderActionButton) {
        if buttonType == .billButton {
            print("tapped bill button")
            if let billVC = storyboard?.instantiateViewController(withIdentifier: "BillViewBoard") as? BillViewController {
                self.navigationController?.pushViewController(billVC, animated: true)
            }
        } else if buttonType == .callWaiterButton {
            // TODO: present the call waiter view
            print("tapped call waiter button")
        }
    }
}
