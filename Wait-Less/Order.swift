//
//  Order.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/7/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Parse

class Order: PFObject, PFSubclassing {
    
    @NSManaged var menuItems: [Menu2]
    
    @NSManaged var table: Table2
    
    override init() {
        super.init()
    }
    
    convenience init(menuItems: [Menu2], table: Table2) {
        self.init()
        self.menuItems = menuItems
        self.table = table
    }
    
    public static func parseClassName() -> String {
        return "Order"
    }    
}
