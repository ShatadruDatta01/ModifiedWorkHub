//
//  EditProfileController.swift
//  Workhub
//
//  Created by Administrator on 11/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditProfileController: BaseTableViewController {

    var strCountryCode = "+1"
    var arrCountryCode = [AnyObject]()
    var dictCountryCode = [String: String]()
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var imgProf: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAdd: UITextField!
    @IBOutlet weak var txtJobExp: UITextField!
    @IBOutlet weak var txtSal: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMob: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        self.imgProf.layer.borderWidth = 2.0
        self.imgProf.layer.borderColor = UIColorRGB(r: 245.0, g: 170.0, b: 81.0)?.cgColor
        self.txtName.keyboardType = UIKeyboardType.alphabet
        self.txtSal.keyboardType = UIKeyboardType.decimalPad
        self.txtJobExp.keyboardType = UIKeyboardType.decimalPad
        self.txtEmail.keyboardType = UIKeyboardType.emailAddress
        self.txtMob.keyboardType = UIKeyboardType.phonePad
        self.fetchCountryCode()
        self.editProfileAPI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func countryCode(_ sender: UIButton) {
        CountryCodeController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Select Country", arrValue: self.arrCountryCode, didSubmit: { (coountryName, code, countryCode) in
            self.strCountryCode = countryCode
            self.btnCountryCode.setTitle("(\(code)) \(countryCode)", for: .normal)
            self.imgFlag.image = UIImage(named: "\(coountryName).png")
        }) {
            debugPrint("No Code")
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        self.validation()
    }
}


// MARK: - FetchCountryCode
extension EditProfileController {
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


// MARK: - UITextFieldDelegate
extension EditProfileController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Validation
extension EditProfileController {
    func validation() {
        if !(self.txtName.text?.isEmpty)! {
            if !(self.txtAdd.text?.isEmpty)! {
                if !(self.txtJobExp.text?.isEmpty)! {
                    if !(self.txtSal.text?.isEmpty)! {
                        if !(self.txtEmail.text?.isEmpty)! {
                            if (self.txtEmail.text?.isValidEmail)! {
                                if !(self.txtMob.text?.isEmpty)! {
                                    //............//
                                } else {
                                    ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter mobile no", didSubmit: { (text) in
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
                        ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter expected salary (per hour)", didSubmit: { (text) in
                            debugPrint("No Code")
                        }, didFinish: {
                            debugPrint("No Code")
                        })
                    }
                } else {
                    ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter job experience", didSubmit: { (text) in
                        debugPrint("No Code")
                    }, didFinish: {
                        debugPrint("No Code")
                    })
                }
            } else {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please enter address", didSubmit: { (text) in
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



// MARK: - ProfileUpdateAPICall
extension EditProfileController {
    func editProfileAPI() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getJobSearch"), attributes: .concurrent)
        API_MODELS_METHODS.getProfile(queue: concurrentQueue) { (responseDict, isSuccess) in
            if isSuccess {
                self.txtName.text = responseDict!["result"]!["data"]["name"].stringValue
                self.txtAdd.text = responseDict!["result"]!["data"]["location"].stringValue
                self.txtJobExp.text = responseDict!["result"]!["data"]["experience"].stringValue
                self.txtSal.text = responseDict!["result"]!["data"]["salExpected"].stringValue
                self.txtEmail.text = responseDict!["result"]!["data"]["email"].stringValue
                let mobNo = responseDict!["result"]!["data"]["mobile"].stringValue.components(separatedBy: "-")
                self.txtMob.text = String(mobNo[1])
                self.btnCountryCode.setTitle(String(mobNo[0]), for: .normal)
                self.imgProf.setImage(withURL: NSURL(string: responseDict!["result"]!["data"]["pic"].stringValue)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
            } else {
                
            }
        }
    }
}



