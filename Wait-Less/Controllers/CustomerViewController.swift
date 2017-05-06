//
//  CustomerViewController.swift
//  Wait-Less
//
//  Created by Waseem Mohd on 5/4/17.
//  Copyright © 2017 Jonathan Wong. All rights reserved.
//

import UIKit

@objc protocol CustomerViewDelegate {
    @objc optional func submittedCustomerInfo(customerName: UITextField, phoneNumber: UITextField) -> Void
}

class CustomerViewController: UIViewController {

    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!

    weak var delegate: CustomerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.submittedCustomerInfo!(customerName: customerName, phoneNumber: phoneNumber)
    }
}
