//
//  ForgotPasswordController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/18/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class ForgotPasswordController: BaseViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
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
        self.validation()
    }
}



// MARK: - Validation
extension ForgotPasswordController {
    func validation() {
        if (self.txtEmail.text?.isBlank)! {
            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter email", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        } else {
            if (self.txtEmail.text?.isValidEmail)! {
                self.circleIndicator.isHidden = false
                self.circleIndicator.animate()
                self.sendOTP()
            } else {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter valid email", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        }
    }
    
    
    /// OTPController
    func moveToPageOTP(otp: String) {
        let OTPPageVC = mainStoryboard.instantiateViewController(withIdentifier: "OTPController") as! OTPController
        OTPPageVC.strEmail = self.txtEmail.text
        OTPPageVC.strOTP = otp
        NavigationHelper.helper.contentNavController!.pushViewController(OTPPageVC, animated: true)
    }
}



// MARK: - OTPController
extension ForgotPasswordController {
    func sendOTP() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getOTP"), attributes: .concurrent)
        API_MODELS_METHODS.getOTP(queue: concurrentQueue, entity: "email", val: self.txtEmail.text!) { (responseDict,isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                self.moveToPageOTP(otp: responseDict!["result"]!["data"]["otp"].stringValue)
                
            } else {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                AlertController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: (responseDict!["result"]!["error"]["msgUser"].stringValue), didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        }
    }
}




