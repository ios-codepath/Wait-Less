//
//  Bill.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/7/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Parse

public typealias BillItem = (name: String, price: Double)
class Bill: PFObject, PFSubclassing {
    
    @NSManaged var order: Order
    
    override init() {
        super.init()
    }
    
    convenience init(order: Order) {
        self.init()
        self.order = order
    }
    
    public static func parseClassName() -> String {
        return "Bill"
    }
    
    public func getSubTotal() -> Double {
        return self.order.menuItems.map({ (menuItem) -> Double in
            return menuItem.price
        }).reduce(0, +)
    }
    
    public func getTotalItems() -> Int {
        return self.order.menuItems.count
    }
}
