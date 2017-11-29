//
//  LoginController.swift
//  Workhub
//
//  Created by Administrator on 20/11/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class LoginController: BaseViewController {

    var network: String!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.text = "abc@sociosquares.com"
        self.txtPassword.text = "test@123"
        self.viewEmail.layer.borderWidth = 1.0
        self.viewEmail.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        
        self.viewPassword.layer.borderWidth = 1.0
        self.viewPassword.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Facebook SignIn
    ///
    /// - Parameter sender: Button
    @IBAction func btnFacebook(_ sender: UIButton) {
        
    }

    
    /// Google SignIn
    ///
    /// - Parameter sender: Button
    @IBAction func btnGoogle(_ sender: UIButton) {
    }
    
    
    /// Manual SignIn
    ///
    /// - Parameter sender: Button
    @IBAction func btnSignIn(_ sender: UIButton) {
        self.validation()
    }
    
    
    /// Forgot Password
    ///
    /// - Parameter sender: Button
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        let forgotPasswordPageVC = mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
        NavigationHelper.helper.contentNavController!.pushViewController(forgotPasswordPageVC, animated: true)
    }
}


// MARK: - Validation
extension LoginController {
    func validation() {
        
        if !(self.txtEmail.text?.isEmpty)! {
            if (self.txtEmail.text?.isValidEmail)! {
                if !(self.txtPassword.text?.isEmpty)! {
                    self.loginAPICall(email: self.txtEmail.text!, password: self.txtPassword.text!, network: "Manual")
                } else {
                    ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter password", didSubmit: { (text) in
                        debugPrint("No Code")
                    }, didFinish: {
                        debugPrint("No Code")
                    })
                }
            } else {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter valid email", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        } else {
            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter email", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtEmail {
            if (self.txtEmail.text?.isEmpty)! {
                self.txtEmail.becomeFirstResponder()
            } else {
                self.txtEmail.resignFirstResponder()
            }
        } else {
            if (self.txtPassword.text?.isEmpty)! {
                self.txtPassword.becomeFirstResponder()
            } else {
                self.txtPassword.resignFirstResponder()
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.backView?.frame = CGRect(x: self.backView.frame.origin.x, y: self.backView.frame.origin.y - 120, width: (self.backView?.frame.size.width)!, height: (self.backView?.frame.size.height)!)
            }, completion: { (finished: Bool) in
                
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.backView?.frame = CGRect(x: self.backView.frame.origin.x, y: self.backView.frame.origin.y - 120, width: (self.backView?.frame.size.width)!, height: (self.backView?.frame.size.height)!)
            }, completion: { (finished: Bool) in
                
            })
        }
        return true
    }
}

// MARK: - Login API Call
extension LoginController {
    func loginAPICall(email: String, password: String, network: String) {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getLogin"), attributes: .concurrent)
        API_MODELS_METHODS.login(queue: concurrentQueue, email: email, password: password, network: network, completion: {responseDict,isSuccess in
            if isSuccess {
                print(responseDict!)
            } else {
                print(responseDict!, isSuccess)
                AlertController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: (responseDict!["result"]!["error"]["msgUser"].stringValue), didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
                
                print(responseDict!["result"]!)
            }
        })
    }
}




