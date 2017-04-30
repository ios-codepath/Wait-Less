//
//  ViewController.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/23/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource, TableCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var tables = [Table]()
    var menus = [Menu]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        Table().getTables(success: { tables in
            self.tables = tables
            self.collectionView.reloadData()
        }, failure: { error in
            print(error)
        })
    }

    @IBAction func onToggle(_ sender: UISegmentedControl) {
        if collectionView.isHidden {
            tableView.isHidden = true
            collectionView.isHidden = false
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
        }
    }

    @IBAction func onSummon(_ sender: UIBarButtonItem) {
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
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

