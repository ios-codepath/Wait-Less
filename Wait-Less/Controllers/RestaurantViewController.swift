//
//  ViewController.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/23/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

enum Section: Int {
    case order
    case pending
}

class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource, TableCellDelegate {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var clearButton: UIButton!
    var orderButton: UIButton!
    var pendingItems = [Menu]()
    var menuItems = [Menu]()
    var tables = [Table]()
    let numberFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        loadTables()
        loadMenuItems()
    }

    @IBAction func onToggle(_ sender: UISegmentedControl) {
        if collectionView.isHidden {
            menuTableView.isHidden = true
            collectionView.isHidden = false
            loadTables()
        } else {
            menuTableView.isHidden = false
            collectionView.isHidden = true
            loadMenuItems()
        }
    }

    private func loadTables() {
        Table().getTables(success: { tables in
            self.tables = tables
            self.collectionView.reloadData()
        }, failure: { error in
            print(error)
        })
    }

    private func loadMenuItems() {
        Menu().getMenuItems(success: {
            menuItems in
            self.menuItems = menuItems
            self.menuTableView.reloadData()
            print(self.menuItems)
        }, failure: {
            error in
            print(error)
        })
    }

    @IBAction func onSummon(_ sender: UIBarButtonItem) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenuDetailViewController" {
            let destination = segue.destination as! MenuDetailViewController
            let cell = sender as! MenuItemTableViewCell
            let indexPath = menuTableView.indexPath(for: cell)
            destination.menuItem = menuItems[(indexPath?.row)!]
            destination.numberFormatter = numberFormatter
        }
    }

    @objc private func handleClear(_ sender: UIButton) {
        let itemCount = pendingItems.count
        pendingItems.removeAll()
        
        menuTableView.beginUpdates()
        for index in 0..<itemCount {
            print(index)
            let indexPath = IndexPath(row: index, section: Section.pending.rawValue)
            menuTableView.deleteRows(at: [indexPath], with: .fade)
        }
        menuTableView.endUpdates()
    }

    @objc private func handleOrder(_ sender: UIButton) {
        print("order")
    }

    //MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.order.rawValue {
            return menuItems.count
        } else {
            return pendingItems.count
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == Section.order.rawValue {
            return 0
        }
        return 100
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.order.rawValue {
            return ""
        } else {
            return "Selected Items"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
        cell.delegate = self
        cell.numberFormatter = numberFormatter

        if indexPath.section == Section.order.rawValue {
            cell.isAdding = true
            cell.menuItem = menuItems[indexPath.row]
            return cell
        } else {
            cell.isAdding = false
            cell.menuItem = pendingItems[indexPath.row]
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == Section.order.rawValue {
            return nil
        }

        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        clearButton = UIButton(type: .roundedRect)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(handleClear(_:)), for: .touchUpInside)
        footer.addSubview(clearButton)

        orderButton = UIButton(type: .roundedRect)
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButton.setTitle("Order", for: .normal)
        orderButton.addTarget(self, action: #selector(handleOrder(_:)), for: .touchUpInside)
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

    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tables.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableCell", for: indexPath) as! TableCell
        cell.tableData = tables[indexPath.row]
        cell.delegate = self
        return cell
    }

    func tableCellUpdate(cell: TableCell) {
        let indexPath = collectionView.indexPath(for: cell)
        collectionView.reloadItems(at: [indexPath!])
    }
}

extension RestaurantViewController: MenuItemTableViewCellDelegate {
    func menuItemTableViewCellDelegate(_ cell: MenuItemTableViewCell, didOrder menuItem: Menu) {
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

