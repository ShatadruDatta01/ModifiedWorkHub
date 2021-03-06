//
//  LoginController.swift
//  Workhub
//
//  Created by Administrator on 20/11/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginController: BaseViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var network: String!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnPassword: UIButton!
    var profPic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPassword.isSecureTextEntry = true
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.viewEmail.layer.borderWidth = 1.0
        self.viewEmail.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        self.viewPassword.layer.borderWidth = 1.0
        self.viewPassword.layer.borderColor = UIColorRGB(r: 200.0, g: 200.0, b: 200.0)?.cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    
    /// DismissKeyboard
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
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
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Facebook SignIn
    ///
    /// - Parameter sender: Button
    @IBAction func btnFacebook(_ sender: UIButton) {
        FacebookLoginAPI.initiateFacebookLogin(completion: { (response, isSuccess,error) in
            DispatchQueue.main.async {
                if isSuccess {
                    let value = response as! [String:AnyObject]
                    debugPrint("the profile fbUser: \(value)")
                    AppConstantValues.isSocial = true
                    self.profPic = "http://graph.facebook.com/\((value["id"] as? String)!)/picture?type=large"
                    debugPrint("the profile fbUser: \(value)", self.profPic)
                    let emailId = (value["email"] as? String)!
                    self.loginAPICall(name: (value["name"] as? String)!, email: emailId, password: "", network: "facebook")
                }else{
                    debugPrint("error\(error)")
                    //NVActivityIndicatorHelper.hideIndicatorInView()
                }
            }
        })
    }

    
    /// Google SignIn
    ///
    /// - Parameter sender: Button
    @IBAction func btnGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
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


// MARK: - GoogleSignInDelegate and GoogleSignInUIDelegate
extension LoginController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print(signIn)
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // For client-side use only!
            
            //          let idToken = user.authentication.idToken // Safe to send to the server
            //          let givenName = user.profile.givenName
            //          let familyName = user.profile.familyName
            
            print(user.userID, user.profile.name, user.profile.email)
            AppConstantValues.isSocial = true
            if user.profile.hasImage {
                self.profPic = String(describing: signIn.currentUser.profile.imageURL(withDimension: 120)!)
            }
            self.loginAPICall(name: user.profile.name, email: user.profile.email!, password: "", network: "google")
            
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}


// MARK: - Validation
extension LoginController {
    func validation() {
        
        if !(self.txtEmail.text?.isEmpty)! {
            if (self.txtEmail.text?.isValidEmail)! {
                if !(self.txtPassword.text?.isEmpty)! {
                    AppConstantValues.isSocial = false
                    self.loginAPICall(name: "", email: self.txtEmail.text!, password: self.txtPassword.text!, network: "Manual")
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
}



// MARK: - Login API Call
extension LoginController {
    func loginAPICall(name: String, email: String, password: String, network: String) {
        self.circleIndicator.isHidden = false
        self.circleIndicator.animate()
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getLogin"), attributes: .concurrent)
        API_MODELS_METHODS.login(queue: concurrentQueue, email: email, password: password, network: network, completion: {responseDict,isSuccess in
            if isSuccess {
                print(responseDict!)
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                SET_OBJ_FOR_KEY(obj: "1" as AnyObject, key: "isLogin")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["resume"].stringValue as AnyObject, key: "Resume")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["id"].stringValue as AnyObject, key: "UserId")
                if String(describing: OBJ_FOR_KEY(key: "Resume")!) == "" || String(describing: OBJ_FOR_KEY(key: "Resume")!) == "0" {
                    AppConstantValues.isResumeUploaded = false
                } else {
                    AppConstantValues.isResumeUploaded = true
                }
                
                /*if AppConstantValues.isSocial == true {
                    if self.profPic.isEmpty {
                        SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["pic"].stringValue as AnyObject, key: "UserPic")
                    } else {
                        SET_OBJ_FOR_KEY(obj: self.profPic as AnyObject, key: "UserPic")
                    }
                } else {
                    SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["pic"].stringValue as AnyObject, key: "UserPic")
                }*/
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["pic"].stringValue as AnyObject, key: "UserPic")
                
                
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["email"].stringValue as AnyObject, key: "Email")
                AppConstantValues.email = responseDict!["result"]!["data"]["email"].stringValue
                REMOVE_OBJ_FOR_KEY(key: "AccessToken")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["access_token"].stringValue as AnyObject, key: "AccessToken")
                AppConstantValues.companyAccessToken = String(describing: OBJ_FOR_KEY(key: "AccessToken")!)
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["name"].stringValue as AnyObject, key: "Name")
                AppConstantValues.name = responseDict!["result"]!["data"]["name"].stringValue
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["network"].stringValue as AnyObject, key: "Network")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["isVerified"].stringValue as AnyObject, key: "IsVerified")
                let jobPageVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchJobController") as! SearchJobController
                NavigationHelper.helper.contentNavController!.pushViewController(jobPageVC, animated: true)
            } else {
                print(responseDict!, isSuccess)
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                
                if responseDict!["result"]!["error"]["code"].stringValue == "106" {
                    if network == "facebook" || network == "google" {
                        self.registerAPICall(name: name, email: email, mob: "", password: "", network: network)
                    } else {
                        AlertController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: (responseDict!["result"]!["error"]["msgUser"].stringValue), didSubmit: { (text) in
                            debugPrint("No Code")
                        }, didFinish: {
                            debugPrint("No Code")
                        })
                    }
                } else {
                    AlertController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: (responseDict!["result"]!["error"]["msgUser"].stringValue), didSubmit: { (text) in
                        debugPrint("No Code")
                    }, didFinish: {
                        debugPrint("No Code")
                    })
                }
                print(responseDict!["result"]!)
            }
        })
    }
}



// MARK: - RegistrationAPICall
extension LoginController {
    func registerAPICall(name: String, email: String, mob: String, password: String, network: String) {
        self.circleIndicator.isHidden = false
        self.circleIndicator.animate()
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getRegister"), attributes: .concurrent)
        API_MODELS_METHODS.register(queue: concurrentQueue, name: name, email: email, mobile: mob, password: password, network: network) { (responseDict, isSuccess) in
            if isSuccess {
                print(responseDict!)
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                SET_OBJ_FOR_KEY(obj: "1" as AnyObject, key: "isLogin")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["resume"].stringValue as AnyObject, key: "Resume")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["id"].stringValue as AnyObject, key: "UserId")
                if AppConstantValues.isSocial == true {
                    AppConstantValues.isFirstTimeRegisterviaSocial = true
                    if self.profPic.isEmpty {
                        SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["pic"].stringValue as AnyObject, key: "UserPic")
                    } else {
                        SET_OBJ_FOR_KEY(obj: self.profPic as AnyObject, key: "UserPic")
                    }
                } else {
                    AppConstantValues.isFirstTimeRegisterviaSocial = false
                    SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["pic"].stringValue as AnyObject, key: "UserPic")
                }
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["email"].stringValue as AnyObject, key: "Email")
                REMOVE_OBJ_FOR_KEY(key: "AccessToken")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["access_token"].stringValue as AnyObject, key: "AccessToken")
                
                AppConstantValues.companyAccessToken = String(describing: OBJ_FOR_KEY(key: "AccessToken")!)
                print(AppConstantValues.companyAccessToken)
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["name"].stringValue as AnyObject, key: "Name")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["network"].stringValue as AnyObject, key: "Network")
                
                let regsDoneVC = mainStoryboard.instantiateViewController(withIdentifier: "AfterRegistrationController") as! AfterRegistrationController
                NavigationHelper.helper.contentNavController!.pushViewController(regsDoneVC, animated: true)
                
                
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


