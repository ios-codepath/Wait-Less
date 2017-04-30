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
    var menuData: PFObject!
    
    init(menuData: PFObject) {
        self.menuData = menuData
        self.name = menuData.object(forKey: "name") as? String
        self.price = menuData.object(forKey: "price") as? Double
        self.menuDescription = menuData.object(forKey: "description") as? String
    }
    
    convenience override init() {
        self.init(menuData: PFObject.init(className: ""))
    }
    
    class func menuesArray(array: [PFObject]) -> [Menu] {
        var menues = [Menu]()
        for menu in array {
            print(menu)
            menues.append(Menu(menuData: menu))
        }
        return menues
    }
    
    func getMenues(success: @escaping ([Menu]) -> Void, failure: @escaping (Error) -> Void) {
        var menues = [Menu]()
        
        let query = PFQuery(className: "Menu")
        query.findObjectsInBackground { (pfObjects, error) in
            if (!(error != nil)) {
                menues = Menu.menuesArray(array: pfObjects!)
                success(menues)
            } else {
                failure(error!)
            }
        }
    }
}
