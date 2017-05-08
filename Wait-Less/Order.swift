//
//  Order.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/7/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Parse

class Order: PFObject, PFSubclassing {
    
    @NSManaged var menuItems: [String]
    
    @NSManaged var tableId: String
    
    override init() {
        super.init()
    }
    
    convenience init(menuItems: [String], tableId: String) {
        self.init()
        self.menuItems = menuItems
        self.tableId = tableId
    }
    
    public static func parseClassName() -> String {
        return "Order"
    }    
}

//class Order: NSObject {
//    
//    var menuItems: [Menu] = []
//    
//    var table: Table!
//    
//    init(menuItems: [Menu], table: Table) {
//        self.menuItems = menuItems
//        self.table = table
//    }
//    
//    class func parseName() -> String {
//        return "Order"
//    }
//}
