//
//  UpdateResumeController.swift
//  Workhub
//
//  Created by Administrator on 12/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import MobileCoreServices
import MarqueeLabel

class UpdateResumeController: BaseTableViewController, UINavigationControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate  {

    var resumeSize = 0.0
    var resumeUpload = false
    var ext: String!
    var strResume: String!
    var strResumeBase64: String!
    var docController: UIDocumentInteractionController!
    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblResume: MarqueeLabel!
    @IBOutlet weak var viewResume: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtName.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.txtName.layer.borderWidth = 1.0
        self.txtName.text = String(describing: OBJ_FOR_KEY(key: "Name")!)
        self.txtEmail.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.txtEmail.layer.borderWidth = 1.0
        self.txtEmail.text = String(describing: OBJ_FOR_KEY(key: "Email")!)
        self.viewResume.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.viewResume.layer.borderWidth = 1.0
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        // Do any additional setup after loading the view.
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
    
    @IBAction func uploadResume(_ sender: UIButton) {
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    
    
    @IBAction func submit(_ sender: UIButton) {
        if self.resumeUpload == true {
            self.circleIndicator.isHidden = false
            self.circleIndicator.animate()
            self.resumeUploadAPI()
        } else {
            if self.resumeSize > 5.000 {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "File size must be within 5mb", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            } else {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please upload resume first", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
            
        }
    }
    
    
    func getFileSize(url: URL) {
        let fileAttributes = try! FileManager.default.attributesOfItem(atPath: url.path)
        let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
        let fileSize = fileSizeNumber.int64Value
        var sizeMB = Double(fileSize / 1024)
        sizeMB = Double(sizeMB / 1024)
        self.resumeSize = Double(round(1000 * sizeMB)/1000)
        self.lblResume.text = self.strResume
        self.lblResume.textColor = .black
        self.lblResume.speed = .duration(8.0)
        self.lblResume.fadeLength = 15.0
        self.lblResume.type = .continuous
        if self.resumeSize > 5.000 {
            self.resumeUpload = false
            ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "File size must be within 5mb", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        } else {
            self.resumeUpload = true
            self.getBase64String(url: url)
        }
    }
    
    func getBase64String(url: URL) {
        let data = NSData(contentsOf: url)
        self.strResumeBase64 = data!.base64EncodedString(options: .endLineWithLineFeed)
    }
}



// MARK: - ResumeUploadAPI
extension UpdateResumeController {
    func resumeUploadAPI() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("resumeUpload"), attributes: .concurrent)
        API_MODELS_METHODS.resumeUpload(queue: concurrentQueue, resume: self.strResumeBase64!, ext: self.ext!) { (responseDict, isSuccess) in
            print(responseDict!)
            if isSuccess {
                SET_OBJ_FOR_KEY(obj: "1" as AnyObject, key: "Resume")
                AppConstantValues.isResumeUploaded = true 
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
}


