//
//  Table2.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/15/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Parse

class Table2: PFObject, PFSubclassing {
    
    @NSManaged var tableNumber: String
    @NSManaged var capacity: String
    @NSManaged var status: Bool
    var tableData: PFObject!
    @NSManaged var reservedTimes: [Int]
    @NSManaged var customerNames: [String]
    @NSManaged var phoneNumbers: [String]
    
    override init() {
        super.init()
    }
    
    convenience init(tableData: PFObject) {
        self.init()
        
        self.tableData = tableData
        self.tableNumber = tableData.object(forKey: "tableNumber") as! String
        self.capacity = tableData.object(forKey: "capacity") as! String
        self.status =  tableData.object(forKey: "status") as? Bool ?? false
        if let times = tableData.object(forKey: "reservedTimes") as? [Int] {
            reservedTimes = times
        }
    }
    
    class func tablesArray(array: [PFObject]) -> [Table2] {
        var tables = [Table2]()
        for table in array {
            print(table)
            tables.append(Table2(tableData: table))
        }
        tables.sort(by: ({$0.tableNumber < $1.tableNumber}))
        return tables
    }
    
    func getTables(success: @escaping ([Table2]) -> Void, failure: @escaping (Error) -> Void){
        var tables = [Table2]()
        let query = PFQuery(className: "Table")
        query.findObjectsInBackground { (pfObjects, error) in
            if (!(error != nil)) {
                tables = Table2.tablesArray(array: pfObjects!)
                success(tables)
            } else {
                failure(error!)
            }
        }
    }
    
    func reserveTable(customerName: String, phone: String, reserveTime: Int) {
        status = reservedTimes.count < 12
        tableData["status"] = status
        customerNames.append(customerName)
        phoneNumbers.append(phone)
        tableData["customerNames"] = customerNames
        tableData["phoneNumbers"] = phoneNumbers
        if !reservedTimes.contains(reserveTime) {
            reservedTimes.append(reserveTime)
        }
        tableData["reservedTimes"] = reservedTimes
        tableData.saveInBackground()
    }
    
    public static func parseClassName() -> String {
        return "Table"
    }
    
}
