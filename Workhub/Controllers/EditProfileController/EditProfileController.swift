//
//  EditProfileController.swift
//  Workhub
//
//  Created by Administrator on 11/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import SwiftyJSON
import TGCameraViewController

class EditProfileController: BaseTableViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var strCountryCode = "+1"
    var strBase64 = ""
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfileController.tappedMe))
        self.imgProf.addGestureRecognizer(tap)
        self.imgProf.isUserInteractionEnabled = true
        self.imgProf.layer.borderWidth = 2.0
        self.imgProf.layer.borderColor = UIColorRGB(r: 245.0, g: 170.0, b: 81.0)?.cgColor
        self.txtName.keyboardType = UIKeyboardType.alphabet
        self.txtSal.keyboardType = UIKeyboardType.decimalPad
        self.txtJobExp.keyboardType = UIKeyboardType.decimalPad
        self.txtEmail.keyboardType = UIKeyboardType.emailAddress
        self.txtMob.keyboardType = UIKeyboardType.phonePad
        self.fetchCountryCode()
        circleIndicator.isHidden = false
        circleIndicator.animate()
        self.editProfileAPI()

        
        // Do any additional setup after loading the view.
    }
    
    func tappedMe()
    {
        let navigationController = TGCameraNavigationController.new(with: self)
        self.present(navigationController!, animated: true, completion: nil)
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


// MARK: - TGCameraDelegate
extension EditProfileController: TGCameraDelegate {
    func cameraDidCancel() {
        print("Cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        self.imgProf.image = image;
        self.dismiss(animated: true, completion: nil)
    }
    
    func cameraDidTakePhoto(_ image: UIImage!) {
        self.imgProf.image = image;
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Base64 conversion
extension EditProfileController {
    func imageToBase64(image: UIImage) {
        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        self.strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        self.updateProfileAPI()
    }
    
    func fetchFlag() {
        for result in self.arrCountryCode {
            let val = JSON(result)
            if val["dial_code"].stringValue == self.strCountryCode {
                self.imgFlag.image = UIImage(named: "\(val["name"]).png")
                self.btnCountryCode.setTitle("(\(val["code"])) \(self.strCountryCode)", for: .normal)
                break
            }
        }
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
                                    self.circleIndicator.isHidden = false
                                    self.circleIndicator.animate()
                                    self.imageToBase64(image: self.imgProf.image!)
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
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getProfile"), attributes: .concurrent)
        API_MODELS_METHODS.getProfile(queue: concurrentQueue) { (responseDict, isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                self.txtName.text = responseDict!["result"]!["data"]["name"].stringValue
                self.txtAdd.text = responseDict!["result"]!["data"]["location"].stringValue
                self.txtJobExp.text = responseDict!["result"]!["data"]["experience"].stringValue
                self.txtSal.text = responseDict!["result"]!["data"]["salExpected"].stringValue
                self.txtEmail.text = responseDict!["result"]!["data"]["email"].stringValue
                let mobNo = responseDict!["result"]!["data"]["mobile"].stringValue.components(separatedBy: "-")
                self.txtMob.text = String(mobNo[1])
                self.strCountryCode = String(mobNo[0])
                self.imgProf.setImage(withURL: NSURL(string: responseDict!["result"]!["data"]["pic"].stringValue)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
                self.fetchFlag()
            } else {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
            }
        }
    }
    
    func updateProfileAPI() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("updateProfile"), attributes: .concurrent)
        let mob = self.strCountryCode + "-" + self.txtMob.text!
        API_MODELS_METHODS.updateProfile(queue: concurrentQueue, email: self.txtEmail.text!, name: self.txtName.text!, mobile: mob, pic: self.strBase64, experience: self.txtJobExp.text!, salExpected: self.txtSal.text!, location: self.txtAdd.text!) { (responseDict, isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully updated your profile", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            } else {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: responseDict!["result"]!["error"]["msgUser"].stringValue, didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        }
    }
}



