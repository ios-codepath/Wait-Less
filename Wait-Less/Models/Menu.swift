//
//  Menu.swift
//  Wait-Less
//
//  Created by Waseem Mohd on 4/27/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import Parse

class Menu: NSObject {
    
    var name: String!
    var price: Double!
    var menuDescription: String!
    var imageName: String!
    var menuData: PFObject!
    
    init(menuData: PFObject) {
        self.menuData = menuData
        self.name = menuData.object(forKey: "name") as? String
        self.price = menuData.object(forKey: "price") as? Double
        self.menuDescription = menuData.object(forKey: "description") as? String
        self.imageName = menuData.object(forKey: "imageName") as? String
    }
    
    convenience override init() {
        self.init(menuData: PFObject.init(className: ""))
    }
    
    class func menuItemsArray(array: [PFObject]) -> [Menu] {
        var menuItems = [Menu]()
        for menu in array {
            print(menu)
            menuItems.append(Menu(menuData: menu))
        }
        return menuItems
    }
    
    func getMenuItems(success: @escaping ([Menu]) -> Void, failure: @escaping (Error) -> Void) {
        var menuItems = [Menu]()
        
        let query = PFQuery(className: "Menu")
        query.findObjectsInBackground { (pfObjects, error) in
            if (!(error != nil)) {
                menuItems = Menu.menuItemsArray(array: pfObjects!)
                success(menuItems)
            } else {
                failure(error!)
            }
        }
    }
}
