//
//  ForgotPasswordController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/18/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class ForgotPasswordController: BaseViewController {

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewEmail.layer.borderWidth = 1.0
        self.viewEmail.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        let OTPPageVC = mainStoryboard.instantiateViewController(withIdentifier: "OTPController") as! OTPController
        NavigationHelper.helper.contentNavController!.pushViewController(OTPPageVC, animated: true)
    }
}
