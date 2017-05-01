//
//  MenuDetailViewController.swift
//  Wait-Less
//
//  Created by Jonathan Wong on 4/25/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

class MenuDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var menuDescriptionLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    var menuItem: Menu!
    var numberFormatter: NumberFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = menuItem.name
        menuDescriptionLabel.text = menuItem.menuDescription
        
        if let formatted = numberFormatter?.string(from: menuItem.price as NSNumber) {
            priceLabel.text = formatted
        }
        
        let tokens = menuItem.imageName.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: tokens[0], ofType: tokens[1])
        menuImageView.image = UIImage(contentsOfFile: path!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
