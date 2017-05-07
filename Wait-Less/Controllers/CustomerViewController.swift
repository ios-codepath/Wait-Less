//
//  CustomerViewController.swift
//  Wait-Less
//
//  Created by Waseem Mohd on 5/4/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

@objc protocol CustomerViewDelegate {
    @objc optional func submittedCustomerInfo(customerName: UITextField, phoneNumber: UITextField, reserveTime: Int) -> Void
}

class CustomerViewController: UIViewController {

    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var twelveButton: UIButton!
    @IBOutlet weak var elevenButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var tenButton: UIButton!

    var reserveTimes = [Int]()
    var selectedTime: UIButton?
    weak var delegate: CustomerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let reserveTimeButtons = [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton,
                                   sevenButton, eightButton, nineButton, tenButton, elevenButton, twelveButton]

        reserveTimeButtons.forEach { reserveTimeButton in
            if reserveTimes.contains((reserveTimeButton?.tag)!) {
                reserveTimeButton?.isSelected = true
                reserveTimeButton?.backgroundColor = .clear
                reserveTimeButton?.isUserInteractionEnabled = false
            }
        }
    }

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.submittedCustomerInfo!(customerName: customerName, phoneNumber: phoneNumber, reserveTime: (selectedTime?.tag)!)
    }

    @IBAction func reserveTimeTapped(_ sender: UIButton) {
        if selectedTime?.tag != sender.tag {
            selectedTime?.isSelected = false
            selectedTime?.backgroundColor = UIColor.red
            sender.isSelected = !sender.isSelected
            sender.backgroundColor = (sender.isSelected) ? UIColor.clear : UIColor.red
            selectedTime = sender
        } else {
            selectedTime?.isSelected = !(selectedTime?.isSelected)!
            selectedTime?.backgroundColor = (selectedTime?.isSelected)! ? UIColor.clear : UIColor.red
        }
    }
}
