//
//  ApplyJobController.swift
//  Workhub
//
//  Created by Administrator on 04/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import MarqueeLabel

class ApplyJobController: BaseTableViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var strJobFunction: String!
    var strJobIcon: String!
    var strJobTitle: String!
    var strJobSubTitle: String!
    var strJobId: String!
    var checkController = false
    var save = 0
    @IBOutlet weak var imgJobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: MarqueeLabel!
    @IBOutlet weak var lblSubJobTitle: UILabel!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblResume: UILabel!
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
        self.presentAlertWithTitle(title: "Workhub", message: "Work under progress")
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
}


