//
//  ApplyJobController.swift
//  Workhub
//
//  Created by Administrator on 04/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import MarqueeLabel
import MobileCoreServices

class ApplyJobController: BaseTableViewController, UINavigationControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var strJobFunction: String!
    var strJobIcon: String!
    var strJobTitle: String!
    var strJobSubTitle: String!
    var strJobId: String!
    var checkController = false
    var save = 0
    var ext: String!
    var strResume: String!
    var strResumeBase64 = ""
    @IBOutlet weak var imgJobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: MarqueeLabel!
    @IBOutlet weak var lblSubJobTitle: UILabel!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblResume: MarqueeLabel!
    @IBOutlet weak var viewResume: UIView!
    @IBOutlet weak var btnBookmark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtName.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.txtName.layer.borderWidth = 1.0
        self.txtName.isUserInteractionEnabled = false
        self.txtName.text = String(describing: OBJ_FOR_KEY(key: "Name")!)
        self.txtEmail.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.txtEmail.layer.borderWidth = 1.0
        self.txtEmail.isUserInteractionEnabled = false
        self.txtEmail.text = String(describing: OBJ_FOR_KEY(key: "Email")!)
        self.viewResume.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.viewResume.layer.borderWidth = 1.0
        self.imgJobIcon.setImage(withURL: NSURL(string: strJobIcon)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
        self.lblJobTitle.text = strJobTitle
        self.lblJobTitle.speed = .duration(8.0)
        self.lblJobTitle.fadeLength = 15.0
        self.lblJobTitle.type = .continuous
        self.lblSubJobTitle.text = strJobSubTitle
        if save == 0 {
            self.btnBookmark.setImage(UIImage(named: "star_white"), for: .normal)
        } else {
            self.btnBookmark.setImage(UIImage(named: "star_bookmark"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
    }
    
    @IBAction func documentUpload(_ sender: UIButton) {
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    // MARK:- UIDocumentMenuDelegate
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    // MARK:- UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // Do something
        let val = url.lastPathComponent.components(separatedBy: ".")
        self.strResume = val[0]
        self.ext = val[1]
        self.getFileSize(url: url)
    }
    
    func getFileSize(url: URL) {
        let fileAttributes = try! FileManager.default.attributesOfItem(atPath: url.path)
        let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
        let fileSize = fileSizeNumber.int64Value
        var sizeMB = Double(fileSize / 1024)
        sizeMB = Double(sizeMB / 1024)
        let resumeSize = Double(round(1000 * sizeMB)/1000)
        if  resumeSize > 5.000 {
            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "File size must be within 5mb", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        } else {
            self.lblResume.text = self.strResume
            self.lblResume.textColor = .black
            self.lblResume.speed = .duration(8.0)
            self.lblResume.fadeLength = 15.0
            self.lblResume.type = .continuous
            self.getBase64String(url: url)
        }
    }
    
    func getBase64String(url: URL) {
        let data = NSData(contentsOf: url)
        self.strResumeBase64 = data!.base64EncodedString(options: .endLineWithLineFeed)
        self.resumeUploadAPI()
    }
    
    
    @IBAction func cross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func bookmark(_ sender: UIButton) {
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
            for aviewcontroller: UIViewController in allViewController
            {
                if aviewcontroller.isKind(of: LoginController.classForCoder())
                {
                    NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                    checkController = true
                    break
                }
            }
            
            if checkController == false {
                let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                NavigationHelper.helper.contentNavController!.pushViewController(loginVC, animated: true)
            }
            self.checkController = false
        } else {
            self.circleIndicator.isHidden = false
            self.circleIndicator.animate()
            self.saveJobAPICall()
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        self.validation()
    }
    
    func validation() {
        if self.strResumeBase64.isEmpty {
            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please submit your resume", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        } else {
            self.circleIndicator.isHidden = false
            self.circleIndicator.animate()
            self.applyJobAPICall()
        }
    }
}


// MARK: - SaveJobAPICall
extension ApplyJobController {
    func saveJobAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("saveJob"), attributes: .concurrent)
        API_MODELS_METHODS.jobFunction(queue: concurrentQueue, action: "save", jobId: self.strJobId) { (responseDict,isSuccess) in
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully saved", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
                self.btnBookmark.setImage(UIImage(named: "star_bookmark"), for: .normal)
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
    
    
    
    
    /// ResumeUpload
    func resumeUploadAPI() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("resumeUpload"), attributes: .concurrent)
        API_MODELS_METHODS.resumeUpload(queue: concurrentQueue, resume: self.strResumeBase64, ext: self.ext!) { (responseDict, isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Resume successfully updated", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            } else {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Selected file is not supported. Please select another file", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        }
    }
    
    
    /// ApplyJobAPICall
    func applyJobAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("saveJob"), attributes: .concurrent)
        API_MODELS_METHODS.jobFunction(queue: concurrentQueue, action: "apply", jobId: self.strJobId) { (responseDict,isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully applied for this job", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
                self.backToJobListScreen()
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
    
    
    
    /// SearchJobListScreen
    func backToJobListScreen() {
        let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
        for aviewcontroller: UIViewController in allViewController
        {
            if aviewcontroller.isKind(of: SearchJobController.classForCoder())
            {
                NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                checkController = true
                break
            }
        }
        
        if checkController == false {
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchJobController") as! SearchJobController
            NavigationHelper.helper.contentNavController!.pushViewController(loginVC, animated: true)
        }
        self.checkController = false
    }
}


