//
//  UpdateResumeController.swift
//  Workhub
//
//  Created by Administrator on 12/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class UpdateResumeController: BaseTableViewController {

    var strResumeBase64: String!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblResume: UILabel!
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
        
        let url1 = Bundle.main.url(forResource: "ShatadruDatta_resume", withExtension: "docx")
        let one1 = NSData(contentsOf: url1!)
        self.strResumeBase64 = one1!.base64EncodedString(options: .endLineWithLineFeed)
        print(self.strResumeBase64)
        
        self.getFileSize()
        // Do any additional setup after loading the view.
    }

    @IBAction func uploadResume(_ sender: UIButton) {
        self.resumeUploadAPI()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
    }
    
    
    func getFileSize() {
        let MyUrl = Bundle.main.url(forResource: "ShatadruDatta_resume", withExtension: "docx")
        let fileAttributes = try! FileManager.default.attributesOfItem(atPath: MyUrl!.path)
        let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
        let fileSize = fileSizeNumber.int64Value
        var sizeMB = Double(fileSize / 1024)
        sizeMB = Double(sizeMB / 1024)
        print(String(format: "%.2f", sizeMB) + " MB")
    }
}



// MARK: - ResumeUploadAPI
extension UpdateResumeController {
    func resumeUploadAPI() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("resumeUpload"), attributes: .concurrent)
        API_MODELS_METHODS.resumeUpload(queue: concurrentQueue, resume: self.strResumeBase64) { (responseDict, isSuccess) in
            print(responseDict!)
            if isSuccess {
                
            } else {
                
            }
        }
    }
}


