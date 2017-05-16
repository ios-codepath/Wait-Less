//
//  Menu2.swift
//  Wait-Less
//
//  Created by Guoliang Wang on 5/7/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import Parse

class Menu2: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    
    @NSManaged var price: Double
    
    @NSManaged var imageName: String
    
    @NSManaged var menuDescription: String
    
    public static let shared = Menu2()
    
    override init() {
        super.init()
    }
    
    // TODO: refactor this to get rid of menuData, instead use the field/instance variables in the constructor
    convenience init(menuData: PFObject) {
        self.init()
        self.name = menuData.object(forKey: "name") as! String
        self.price = menuData.object(forKey: "price") as! Double
        self.menuDescription = menuData.object(forKey: "description") as! String
        self.imageName = menuData.object(forKey: "imageName") as! String
    }
    
    class func menuItemsArray(array: [PFObject]) -> [Menu2] {
        var menuItems = [Menu2]()
        for menu in array {
            print(menu)
            menuItems.append(Menu2(menuData: menu))
        }
        return menuItems
    }
    
    func getMenuItems(success: @escaping ([Menu2]) -> Void, failure: @escaping (Error?) -> Void) {
        
        Menu2.query()?.findObjectsInBackground { (objects, error) in
            if error != nil {
                print("query error: \(String(describing: error))")
                failure(error)
            } else {
                print("menuItems: \(String(describing: objects))")
                let menuItems = objects as! [Menu2]
                success(menuItems)
            }
        }
    }
    
    public static func parseClassName() -> String {
        return "Menu"
    }
}
