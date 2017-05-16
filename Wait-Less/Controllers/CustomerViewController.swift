//
//  CustomerViewController.swift
//  Wait-Less
//
//  Created by Waseem Mohd on 5/4/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

@objc protocol CustomerViewDelegate {
    @objc optional func submittedCustomerInfo(customerName: UITextField, phoneNumber: UITextField, reserveTime: Int) -> Void
}

class CustomerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var customerName: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField!
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

        customerName.selectedTitleColor = .lightGray
        phoneNumber.selectedTitleColor = .lightGray
        customerName.errorColor = .red
        phoneNumber.errorColor = .red
        phoneNumber.delegate = self
        
        let reserveTimeButtons = [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton,
                                   sevenButton, eightButton, nineButton, tenButton, elevenButton, twelveButton]

        
        reserveTimeButtons.forEach {
            reserveTimeButton in
            reserveTimeButton?.layer.cornerRadius = 4
        }
    }
    

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if customerName.text == "" {
            phoneNumber.errorMessage = ""
            customerName.errorMessage = "Name Required"
        } else if  phoneNumber.text == "" {
            customerName.errorMessage = ""
            phoneNumber.errorMessage = "Phone Number Required"
        } else if selectedTime?.tag == nil {
            phoneNumber.errorMessage = ""
            customerName.errorMessage = "Reservation Time Required"
        } else {
            customerName.errorMessage = ""
            phoneNumber.errorMessage = ""
            self.dismiss(animated: true, completion: nil)
            delegate?.submittedCustomerInfo!(customerName: customerName, phoneNumber: phoneNumber, reserveTime: (selectedTime?.tag)!)
        }
    }

    @IBAction func reserveTimeTapped(_ sender: UIButton) {
        if selectedTime?.tag != sender.tag {
            selectedTime?.isSelected = false
            selectedTime?.backgroundColor = (UIApplication.shared.delegate as! AppDelegate).blue
            sender.isSelected = !sender.isSelected
            sender.backgroundColor = (sender.isSelected) ? (UIApplication.shared.delegate as! AppDelegate).green : (UIApplication.shared.delegate as! AppDelegate).blue
            selectedTime = sender
        } else {
            selectedTime?.isSelected = !(selectedTime?.isSelected)!
            selectedTime?.backgroundColor = (selectedTime?.isSelected)! ? (UIApplication.shared.delegate as! AppDelegate).green : (UIApplication.shared.delegate as! AppDelegate).blue
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
