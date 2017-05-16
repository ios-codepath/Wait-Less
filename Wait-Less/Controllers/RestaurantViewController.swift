//
//  ViewController.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/23/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

enum Section: Int {
    case order
    case pending
}

class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,
UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, TableCellDelegate, CustomerViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var clearButton: UIButton!
    var orderButton: UIButton!
    var pendingItems = [Menu2]()
    var menuItems = [Menu2]()
    var tables = [Table2]()
    var tableToReserve: Table2?
    let numberFormatter = NumberFormatter()
    var selectedIndexPath: IndexPath?
    var progress: UInt8 = 0
    @IBOutlet weak var toggleSegmentedControl: UISegmentedControl!

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        collectionView.backgroundView = UIImageView.init(image: UIImage(named: "background.jpg"))
        NotificationCenter.default.addObserver(self, selector: #selector(onSummon(_:)), name: Notification.Name("SummonWaiter"), object: nil)
        loadTables()
        loadMenuItems()
        
        menuTableView.rowHeight = 200
        menuTableView.backgroundColor = UIColor.white
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: "MenuItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MenuItemTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = selectedIndexPath {
            menuTableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @IBAction func onToggle(_ sender: UISegmentedControl) {
        if collectionView.isHidden {
            menuTableView.isHidden = true
            collectionView.isHidden = false
        } else {
            menuTableView.isHidden = false
            collectionView.isHidden = true
        }
    }

    private func loadTables() {
        Table2().getTables(success: { tables in
            self.tables = tables
            self.collectionView.reloadData()
            print("tables count: \(self.tables.count)")
        }, failure: { error in
            print(error)
        })
    }

    private func loadMenuItems() {
        Menu2().getMenuItems(success: { (menuItems) in
            self.menuItems = menuItems
            self.menuTableView.reloadData()
            print("self.menuItems: \(self.menuItems)")
        }) { (error) in
            print("error")
        }
    }

    @objc private func updateProgress(timer: Timer) {
        progress = progress &+ 1
        let normalizedProgress = Double(progress) / Double(UInt8.max)
        if normalizedProgress > 0.99 {
            timer.invalidate()
            progress = 0
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }

    @IBAction func onSummon(_ sender: UIButton) {
        Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateProgress(timer:)), userInfo: nil, repeats: true)
        let color = UIColor(red: 80.0/255.0, green: 102.0/255.0, blue: 161.0/255.0, alpha: 0.7)
        let activityData = ActivityData(size: CGSize.init(width: 100, height: 100), message: "Waiter...", messageFont: UIFont.boldSystemFont(ofSize: 18), type: .lineScale, color: .white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: color, textColor: .white)

        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
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
        orderButton.isEnabled = false
        menuTableView.endUpdates()
        menuTableView.reloadSections(IndexSet([1]), with: .fade)
    }

    @objc private func handleOrder(_ sender: UIButton) {
        guard pendingItems.count > 0 else { return }
        let curTable = Table2()
        curTable.tableNumber = "002"
        curTable.status = false
        curTable.capacity = "8" // shouldn't it be an integer?
        _ = pendingItems.map { return $0.name }

        let order = Order(menuItems: pendingItems, table: curTable)
        
        order.saveInBackground { (success, error) in
            if error != nil {
                print("order error: \(String(describing: error))")
                return
            }
            if success {
                let successMsg = NotificationBanner(title: "Order Placed!", subtitle: nil, leftView: nil, rightView: nil, style: BannerStyle.success, colors: nil)
                successMsg.show()
                
                // jump to order detail screen
                if let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailBoard") as? OrderDetailViewController {
                    targetVC.menuItems = self.pendingItems
                    targetVC.curOrder = order
                    self.navigationController?.pushViewController(targetVC, animated: true)
                }
            }
        }
        
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
        } else if section == Section.pending.rawValue && pendingItems.count > 0 {
            return 80
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.order.rawValue {
            return "Menu"
        } else {
            if pendingItems.count == 0 {
                return ""
            }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        header.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        let views: [String: AnyObject] = ["titleLabel" : titleLabel,
                                          "view" : view]
        header.addSubview(titleLabel)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]", options: [], metrics: nil, views: views)
        
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightThin)
        titleLabel.textColor = (UIApplication.shared.delegate as! AppDelegate).blue
        NSLayoutConstraint.activate(constraints)
        
        if section == Section.order.rawValue {
            titleLabel.text = "MENU"
        } else if section == Section.pending.rawValue && pendingItems.count > 0 {
            titleLabel.text = "SELECTED ITEMS"
        } else {
            return nil
        }
        
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == Section.order.rawValue {
            return nil
        }
        
        if pendingItems.count == 0 {
            return nil
        }

        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        footer.backgroundColor = UIColor.white
        clearButton = UIButton(type: .roundedRect)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(handleClear(_:)), for: .touchUpInside)
        clearButton.tintColor = (UIApplication.shared.delegate as! AppDelegate).blue
        footer.addSubview(clearButton)

        orderButton = UIButton(type: .roundedRect)
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButton.setTitle("Order", for: .normal)
        orderButton.addTarget(self, action: #selector(handleOrder(_:)), for: .touchUpInside)
        orderButton.tintColor = (UIApplication.shared.delegate as! AppDelegate).blue
        footer.addSubview(orderButton)

        let views: [String: AnyObject] = ["clearButton" : clearButton,
                                          "orderButton" : orderButton,
                                          "view" : view]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[clearButton(==orderButton)]-[orderButton]-|", options: [NSLayoutFormatOptions.alignAllFirstBaseline], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[clearButton]-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)

        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "showMenuDetailViewController", sender: cell)
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

    func tableCellUpdate(tableData: Table2) {
        tableToReserve = tableData
        let customerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerViewController") as!CustomerViewController
        customerViewController.delegate = self
        customerViewController.reserveTimes = (tableToReserve?.reservedTimes)!
        let navigationController = UINavigationController(rootViewController: customerViewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.popover

        let popover = navigationController.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        customerViewController.preferredContentSize = CGSize(width: 300, height: 240)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)

        self.present(navigationController, animated: true, completion: nil)
    }

    //MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    func submittedCustomerInfo(customerName: UITextField, phoneNumber: UITextField, reserveTime: Int) {
        if customerName.text != "" && phoneNumber.text != "" && tableToReserve?.status == true {
            tableToReserve?.reserveTable(customerName: customerName.text!, phone: phoneNumber.text!, reserveTime: reserveTime)
            let index = tables.index(of: tableToReserve!)
            let indexPath = IndexPath(row: index!, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as! TableCell
            cell.onTap()
            collectionView.reloadItems(at: [indexPath])
            toggleSegmentedControl.selectedSegmentIndex = 1
            toggleSegmentedControl.sendActions(for: .valueChanged)
            loadMenuItems()
            loadTables()
        }
    }
}

extension RestaurantViewController: MenuItemTableViewCellDelegate {
    func menuItemTableViewCellDelegate(_ cell: MenuItemTableViewCell, didOrder menuItem: Menu2) {
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
    }
}

