//
//  MenuViewController.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/25/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menuTestData.count
        } else {
            return pendingItems.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
        cell.delegate = self
        cell.numberFormatter = numberFormatter
        
        if indexPath.section == 0 {
            cell.orderButton.setTitle("+", for: .normal)
            cell.orderButton.setTitle("+", for: .highlighted)
            cell.orderButton.setTitle("+", for: .selected)
            
            cell.menuItem = menuTestData[indexPath.row]
            return cell
        } else {
            cell.orderButton.setTitle("-", for: .normal)
            cell.orderButton.setTitle("-", for: .highlighted)
            cell.orderButton.setTitle("-", for: .selected)
            
            cell.menuItem = pendingItems[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return "Selected Items"
        }
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MenuViewController: MenuItemTableViewCellDelegate {
    func menuItemTableViewCellDelegate(_ cell: MenuItemTableViewCell, didOrder menuItem: MenuItem) {
        if cell.orderButton.title(for: .normal) == "+" {
            
            
            pendingItems.append(menuItem)
        } else {
            if let indexPath = menuTableView.indexPath(for: cell) {
                pendingItems.remove(at: indexPath.row)
            }
        }
        
        menuTableView.reloadData()
        print(menuItem.price)
        print(menuItem.name)
    }
}
