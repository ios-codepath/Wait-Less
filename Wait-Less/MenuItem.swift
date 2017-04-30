//
//  MenuItem.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/25/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import Parse

class MenuItem {
    var name: String!
    var price: Double!
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
}
