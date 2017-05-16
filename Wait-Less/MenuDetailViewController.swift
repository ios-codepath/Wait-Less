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
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    var menuItem: Menu2!
    var numberFormatter: NumberFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.textColor = (UIApplication.shared.delegate as! AppDelegate).blue
        menuDescriptionLabel.textColor = (UIApplication.shared.delegate as! AppDelegate).blue
        nameLabel.text = menuItem.name
        menuDescriptionLabel.text = menuItem.menuDescription
        
        if let formatted = numberFormatter?.string(from: menuItem.price as NSNumber) {
            priceLabel.text = formatted
        }
        
        let tokens = menuItem.imageName.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: tokens[0], ofType: tokens[1])
        menuImageView.image = UIImage(contentsOfFile: path!)
        
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.2, y: 0.4)
        gradient.colors = [(UIApplication.shared.delegate as! AppDelegate).powderBlue.cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionHeightConstraint.constant = view.frame.height + 8
        menuDescriptionLabel.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        descriptionHeightConstraint.constant = 8
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: [], animations: {
            self.view.layoutIfNeeded()
            self.menuDescriptionLabel.alpha = 1.0
        }, completion: nil)
        
    }
}
