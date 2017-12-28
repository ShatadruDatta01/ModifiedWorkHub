//
//  RegisterController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleSignIn

class RegisterController: BaseViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var strCountryCode = "+1"
    var strNetwork = ""
    var strName = ""
    var strEmail = ""
    var strMob = ""
    var strPassword = ""
    var arrCountryCode = [AnyObject]()
    var dictCountryCode = [String: String]()
    @IBOutlet weak var tblRegister: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.fetchCountryCode()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)

    }
}


// MARK: - FetchCountryCode
extension RegisterController {
    func fetchCountryCode() {
        let path =  Bundle.main.path(forResource: "CountryCodes", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        print(jsonData!)
        let jsonResult: NSArray = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        for result in jsonResult {
            let val = JSON(result)
            self.dictCountryCode = ["name": val["name"].stringValue, "dial_code": val["dial_code"].stringValue, "code": val["code"].stringValue]
            print(self.dictCountryCode)
            self.arrCountryCode.append(self.dictCountryCode as AnyObject)
        }
    }
}



// MARK: - GoogleSignInDelegate and GoogleSignInUIDelegate
extension RegisterController: GIDSignInUIDelegate, GIDSignInDelegate {
    
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
            
            self.registerAPICall(name: user.profile.name, email: user.profile.email, mob: "", password: "", network: "google")
            
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


// MARK: - GoogleRegistration
extension RegisterController {
    func googleAPICall() {
        GIDSignIn.sharedInstance().signIn()
    }
}


// MARK: - FacebookRegistration
extension RegisterController {
    func facebookAPICall() {
        FacebookLoginAPI.initiateFacebookLogin(completion: { (response, isSuccess,error) in
            DispatchQueue.main.async {
                if isSuccess {
                    let value = response as! [String:AnyObject]
                    debugPrint("the profile fbUser: \(value)")
                    //let emailId = (value["email"] as? String)!
                    self.registerAPICall(name: (value["name"] as? String)!, email: (value["email"] as? String)!, mob: "", password: "", network: "facebook")
                    
                }else{
                    debugPrint("error\(error)")
                    //NVActivityIndicatorHelper.hideIndicatorInView()
                }
            }
        })
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension RegisterController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cellRegister = tableView.dequeueReusableCell(withIdentifier: "RegisterCell", for: indexPath) as! RegisterCell
            cellRegister.datasource = "" as AnyObject
            cellRegister.btnRegisterGoogle.addTarget(self, action: #selector(RegisterController.googleAPICall), for: UIControlEvents.touchUpInside)
            cellRegister.btnRegisterFacebook.addTarget(self, action: #selector(RegisterController.facebookAPICall), for: UIControlEvents.touchUpInside)
            cellRegister.selectionStyle = .none
            return cellRegister
        default:
            switch indexPath.row {
            case 0:
                let cellName = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cellName.index = indexPath.row
                cellName.datasource = "" as AnyObject
                cellName.imgLogo.image = UIImage(named: "UserIcon")
                cellName.txtField.placeholder = "Full Name"
                cellName.didSendValue = { text, index in
                    self.strName = text
                }
                cellName.selectionStyle = .none
                return cellName
            case 1:
                let cellEmail = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cellEmail.index = indexPath.row
                cellEmail.datasource = "" as AnyObject
                cellEmail.imgLogo.image = UIImage(named: "Mail")
                cellEmail.txtField.placeholder = "Email"
                cellEmail.didSendValue = { text, index in
                    self.strEmail = text
                }
                cellEmail.selectionStyle = .none
                return cellEmail
            case 2:
                let cellMob = tableView.dequeueReusableCell(withIdentifier: "MobCell", for: indexPath) as! MobCell
                cellMob.datasource = "" as AnyObject
                cellMob.imgLogo.image = UIImage(named: "Call")
                cellMob.txtMobNo.placeholder = "Mobile No"
                cellMob.didSendCountryVal = { text in
                    if text == "CountryCode" {
                        CountryCodeController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Select Country", arrValue: self.arrCountryCode, didSubmit: { (coountryName, code, countryCode) in
                            self.strCountryCode = countryCode
                            cellMob.btnExt.setTitle("(\(code)) \(countryCode)", for: .normal)
                            cellMob.imgFlag.image = UIImage(named: "\(coountryName).png")
                        }) {
                            debugPrint("No Code")
                        }
                    }
                }
                cellMob.didSendValue = { text, index in
                    self.strMob = text
                }
                cellMob.selectionStyle = .none
                return cellMob
            case 3:
                let cellPassword = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cellPassword.index = indexPath.row
                cellPassword.datasource = "" as AnyObject
                cellPassword.imgLogo.image = UIImage(named: "PasswordIcon")
                cellPassword.txtField.placeholder = "Create Password"
                cellPassword.didSendValue = { text, index in
                    self.strPassword = text
                }
                cellPassword.selectionStyle = .none
                return cellPassword
            default:
                let cellButton = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cellButton.datasource = "" as AnyObject
                cellButton.btnRegister.addTarget(self, action: #selector(RegisterController.validation), for: UIControlEvents.touchUpInside)
                cellButton.selectionStyle = .none
                return cellButton
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 180.0
        default:
            switch indexPath.row {
            case 0...3:
                return 45.0
            default:
                return 99.0
            }
        }
    }
}



// MARK: - Validation
extension RegisterController {
    func validation() {
        if self.strName.characters.count > 0 {
            if self.strEmail.characters.count > 0 {
                if self.strEmail.isValidEmail {
                    if self.strMob.characters.count > 0 {
                        if self.strMob.characters.count > 6 {
                            if self.strPassword.characters.count > 0 {
                                if self.strPassword.characters.count > 5 {
                                    self.strNetwork = "Manual"
                                    let mob = "\(self.strCountryCode)-\(self.strMob)"
                                    self.registerAPICall(name: self.strName, email: self.strEmail, mob: mob, password: self.strPassword, network: "Manual")
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
                        } else {
                            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter valid mobile number", didSubmit: { (text) in
                                debugPrint("No Code")
                            }, didFinish: {
                                debugPrint("No Code")
                            })
                        }
                    } else {
                        ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter mobile number", didSubmit: { (text) in
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
        } else {
            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter name (Only character allowed)", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
    }
}



// MARK: - RegistrationAPICall
extension RegisterController {
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
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["pic"].stringValue as AnyObject, key: "UserPic")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["email"].stringValue as AnyObject, key: "Email")
                REMOVE_OBJ_FOR_KEY(key: "AccessToken")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["access_token"].stringValue as AnyObject, key: "AccessToken")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["name"].stringValue as AnyObject, key: "Name")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["network"].stringValue as AnyObject, key: "Network")
                
                let jobPageVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchJobController") as! SearchJobController
                NavigationHelper.helper.contentNavController!.pushViewController(jobPageVC, animated: true)
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



