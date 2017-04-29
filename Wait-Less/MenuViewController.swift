//
//  MenuViewController.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/25/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    enum Section: Int {
        case order
        case pending
    }
    
    
    @IBOutlet weak var menuTableView: UITableView!
    var selectedIndexPath: IndexPath?
    
    var clearButton: UIButton!
    var orderButton: UIButton!
    
    var menuTestData = [MenuItem(name: "Some really long description", price: 9.99),
                        MenuItem(name: "Spaghetti", price: 7.99),
                        MenuItem(name: "Chicken Milano", price: 12.99),
                        MenuItem(name: "Chicken Marsala", price: 12.99),
                        MenuItem(name: "Pancetta", price: 8.99),
                        MenuItem(name: "Mushroom Risotto", price: 11.99)]
    var pendingItems = [MenuItem]()
    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndexPath = selectedIndexPath {
            menuTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenuDetailViewController" {
            let destination = segue.destination as! MenuDetailViewController
            
            if let selectedIndexPath = selectedIndexPath {
                destination.menuItem = menuTestData[selectedIndexPath.row]
            }
        }
    }
    
    func handleClear(_ sender: UIButton) {
        print("clear")
    }
    
    func handleOrder(_ sender: UIButton) {
        print("order")
    }
}

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.order.rawValue {
            return menuTestData.count
        } else {
            return pendingItems.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
        cell.delegate = self
        cell.numberFormatter = numberFormatter
        
        if indexPath.section == Section.order.rawValue {
            cell.isAdding = true
            cell.menuItem = menuTestData[indexPath.row]
            return cell
        } else {
            cell.isAdding = false
            cell.menuItem = pendingItems[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.order.rawValue {
            return ""
        } else {
            return "Selected Items"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == Section.order.rawValue {
            return nil
        }
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        clearButton = UIButton(type: .roundedRect)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(MenuViewController.handleClear(_:)), for: .touchUpInside)
        footer.addSubview(clearButton)
        
        orderButton = UIButton(type: .roundedRect)
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButton.setTitle("Order", for: .normal)
        orderButton.addTarget(self, action: #selector(MenuViewController.handleOrder(_:)), for: .touchUpInside)
        footer.addSubview(orderButton)
        
        let views: [String: AnyObject] = ["clearButton" : clearButton,
                                          "orderButton" : orderButton,
                                          "view": view]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[clearButton(==orderButton)]-[orderButton]-|", options: [NSLayoutFormatOptions.alignAllFirstBaseline], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[clearButton]-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)

        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == Section.order.rawValue {
            return 0
        }
        
        return 100
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        performSegue(withIdentifier: "showMenuDetailViewController", sender: self)
    }
}

extension MenuViewController: MenuItemTableViewCellDelegate {
    func menuItemTableViewCellDelegate(_ cell: MenuItemTableViewCell, didOrder menuItem: MenuItem) {
        if cell.orderButton.title(for: .normal) == "+" {
            let totalPending = pendingItems.count
            let newIndexPath = IndexPath(row: totalPending, section: 1)
            pendingItems.append(menuItem)
            menuTableView.insertRows(at: [newIndexPath], with: .fade)
        } else {
            if let indexPath = menuTableView.indexPath(for: cell) {
                pendingItems.remove(at: indexPath.row)
                menuTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        print(menuItem.price)
        print(menuItem.name)
    }
}
