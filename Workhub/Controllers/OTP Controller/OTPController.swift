//
//  OTPController.swift
//  Workhub
//
//  Created by Administrator on 06/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class OTPController: BaseTableViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var strEmail: String!
    var strOTP: String!
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfPassword: UITextField!
    @IBOutlet weak var viewOTP: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewConfPassword: UIView!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnConfPassword: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
        //self.txtOTP.text = self.strOTP
        self.viewOTP.layer.borderWidth = 1.0
        self.viewOTP.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        self.viewPassword.layer.borderWidth = 1.0
        self.viewPassword.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        self.viewConfPassword.layer.borderWidth = 1.0
        self.viewConfPassword.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        // Do any additional setup after loading the view.
    }

    @IBAction func visibilityPassword(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.txtPassword.isSecureTextEntry = true
            self.btnPassword.setImage(UIImage(named: "Visibility_off"), for: .normal)
        } else {
            sender.isSelected = true
            self.txtPassword.isSecureTextEntry = false
            self.btnPassword.setImage(UIImage(named: "Visibility_on"), for: .selected)
        }
    }
    
    @IBAction func visibilityConfirmPassword(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.txtConfPassword.isSecureTextEntry = true
            self.btnConfPassword.setImage(UIImage(named: "Visibility_off"), for: .normal)
        } else {
            sender.isSelected = true
            self.txtConfPassword.isSecureTextEntry = false
            self.btnConfPassword.setImage(UIImage(named: "Visibility_on"), for: .selected)
        }
    }
    
    
    @IBAction func resetPAssword(_ sender: UIButton) {
        self.validation()
    }
    
    @IBAction func resendOTP(_ sender: UIButton) {
        self.circleIndicator.isHidden = false
        self.circleIndicator.animate()
        self.sendOTP()
    }

    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



// MARK: - OTPController
extension OTPController {
    func validation() {
        if (self.txtPassword.text!.characters.count) > 0 {
            if (self.txtPassword.text!.characters.count) > 5 {
                if (self.txtConfPassword.text!.characters.count) > 0 {
                    if self.txtPassword.text! == self.txtConfPassword.text! {
                        self.circleIndicator.isHidden = false
                        self.circleIndicator.animate()
                        self.changePassword()
                    } else {
                        ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Password & Confirm Password doesn't match", didSubmit: { (text) in
                            debugPrint("No Code")
                        }, didFinish: {
                            debugPrint("No Code")
                        })
                    }
                } else {
                    ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter confirm password", didSubmit: { (text) in
                        debugPrint("No Code")
                    }, didFinish: {
                        debugPrint("No Code")
                    })
                }
            } else {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Password should be minimum 6 characters", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        } else {
            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter password", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
    }
}




// MARK: - OTPController
extension OTPController {
    
    /// Send OTP
    func sendOTP() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getOTP"), attributes: .concurrent)
        API_MODELS_METHODS.getOTP(queue: concurrentQueue, entity: "email", val: self.strEmail!) { (responseDict,isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                self.txtOTP.text = responseDict!["result"]!["data"]["otp"].stringValue
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
    
    
    /// Verify OTP
    func verifyOTP() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("verifyOTP"), attributes: .concurrent)
        API_MODELS_METHODS.verifyOTP(queue: concurrentQueue, entity: "email", val: self.strEmail!, otp: self.txtOTP.text!) { (responseDict,isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
//                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter password", didSubmit: { (text) in
//                    debugPrint("No Code")
//                }, didFinish: {
//                    debugPrint("No Code")
//                })
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
    
    
    
    /// ChangePasswordAPICall
    func changePassword() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("changePassword"), attributes: .concurrent)
        API_MODELS_METHODS.changePassword(queue: concurrentQueue, entity: "email", val: self.strEmail!, otp: self.txtOTP.text!, password: self.txtConfPassword.text!) { (responseDict, isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully changed", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
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





