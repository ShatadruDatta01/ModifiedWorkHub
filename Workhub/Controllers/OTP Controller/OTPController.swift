//
//  OTPController.swift
//  Workhub
//
//  Created by Administrator on 06/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class OTPController: BaseTableViewController {

    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfPassword: UITextField!
    @IBOutlet weak var viewOTP: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConfPassword: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
        self.viewOTP.layer.borderWidth = 1.0
        self.viewOTP.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        self.viewPassword.layer.borderWidth = 1.0
        self.viewPassword.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        self.viewConfPassword.layer.borderWidth = 1.0
        self.viewConfPassword.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        // Do any additional setup after loading the view.
    }

    
    @IBAction func resetPAssword(_ sender: UIButton) {
    }
    
    @IBAction func resendOTP(_ sender: UIButton) {
    }

    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
