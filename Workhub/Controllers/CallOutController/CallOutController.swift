//
//  CallOutController.swift
//  Workhub
//
//  Created by Shatadru Datta on 12/9/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class CallOutController: BaseViewController {

     var strJobId = ""
     var strIconDetails = ""
     var strJobHour = ""
     var strJobTitle = ""
     var strJobSubTitle = ""
     var strJobLocation = ""
     var strShift = ""
     var strJobPosted = ""
     var strFullTime = ""
     var strJobDesc = ""
     var save = 0
    var checkController = false
    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet var imgJobIcon: UIImageView!
    @IBOutlet var lblJobRole: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblCompName: UILabel!
    @IBOutlet var lblJobPosted: UILabel!
    @IBOutlet var lblShift: UILabel!
    @IBOutlet var lblHour: UILabel!
    @IBOutlet var lblFullTime: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    
    var didSubmitButton:((_ text: String) -> ())?
    var didRemove:((_ text: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self, action: #selector(CallOutController.tappedMe))
        self.viewPopUp.addGestureRecognizer(tap)
        self.viewPopUp.isUserInteractionEnabled = true
    }
    
    func tappedMe() {
        self.dismissAnimate()
        let jobDetailsPageVC = mainStoryboard.instantiateViewController(withIdentifier: "JobDetailsController") as! JobDetailsController
        jobDetailsPageVC.strIconDetails = self.strIconDetails
        jobDetailsPageVC.strJobHour = self.strJobHour
        jobDetailsPageVC.strJobTitle = self.strJobTitle
        jobDetailsPageVC.strJobSubTitle = self.strJobSubTitle
        jobDetailsPageVC.strJobLocation = self.strJobLocation
        jobDetailsPageVC.strShift = self.strShift
        jobDetailsPageVC.strJobPosted = self.strJobPosted
        jobDetailsPageVC.strFullTime = self.strFullTime
        jobDetailsPageVC.strJobDesc = self.strJobDesc
        jobDetailsPageVC.save = self.save
        jobDetailsPageVC.strJobId = self.strJobId
        jobDetailsPageVC.strJobFunction = "view"
        NavigationHelper.helper.contentNavController!.pushViewController(jobDetailsPageVC, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismissAnimate()
    }
    
    @IBAction func apply(_ sender: UIButton) {
        self.dismissAnimate()
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
            
            if AppConstantValues.isResumeUploaded == false {
                let applyPageVC = mainStoryboard.instantiateViewController(withIdentifier: "ApplyJobController") as! ApplyJobController
                applyPageVC.strJobIcon = strIconDetails
                applyPageVC.strJobTitle = strJobTitle
                applyPageVC.strJobSubTitle = strJobSubTitle
                applyPageVC.strJobId = strJobId
                applyPageVC.save = self.save
                NavigationHelper.helper.contentNavController!.pushViewController(applyPageVC, animated: false)
            } else {
                self.applyJobAPICall()
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
    
    func backToJobListScreen() {
        self.dismissAnimate()
    }
    
    @IBAction func jobSave(_ sender: UIButton) {
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
            self.dismissAnimate()
        } else {
            self.circleIndicator.isHidden = false
            self.circleIndicator.animate()
            self.saveJobAPICall()
        }
    }
    
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, strJobId: String, strIconDetails: String, strJobHour: String, strJobTitle: String, strJobSubTitle: String, strJobLocation: String, strShift: String, strJobPosted: String, strFullTime: String, strJobDesc: String, save: Int, apply: Int, didSubmit: @escaping ((_ text: String) -> ()), didFinish: @escaping ((_ text: String) -> ())) {
        
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "CallOutController") as! CallOutController
        commentPopVC.didSubmitButton = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceController: sourceViewController, strJobId: strJobId,strIconDetails: strIconDetails, strJobHour: strJobHour, strJobTitle: strJobTitle, strJobSubTitle: strJobSubTitle, strJobLocation: strJobLocation, strShift: strShift, strJobPosted: strJobPosted, strFullTime: strFullTime, strJobDesc: strJobDesc, save: save, apply: apply)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController, strJobId: String, strIconDetails: String, strJobHour: String, strJobTitle: String, strJobSubTitle: String, strJobLocation: String, strShift: String, strJobPosted: String, strFullTime: String, strJobDesc: String, save: Int, apply: Int) {
        self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChildViewController(self)
        sourceController.view.bringSubview(toFront: self.view)
        self.strIconDetails = strIconDetails
        self.strJobHour = strJobHour
        self.strJobTitle = strJobTitle
        self.strJobSubTitle = strJobSubTitle
        self.strJobLocation = strJobLocation
        self.strShift = strShift
        self.strJobPosted = strJobPosted
        self.strFullTime = strFullTime
        self.strJobDesc = strJobDesc
        self.save = save
        self.strJobId = strJobId
        presentAnimationToView(strJobId: self.strJobId, strIconDetails: self.strIconDetails, strJobHour: self.strJobHour, strJobTitle: self.strJobTitle, strJobSubTitle: self.strJobSubTitle, strJobLocation: self.strJobLocation, strShift: self.strShift, strJobPosted: self.strJobPosted, strFullTime: self.strFullTime, strJobDesc: self.strJobDesc, save: self.save, apply: apply)
    }
    
    // MARK: - Animation
    func presentAnimationToView(strJobId: String, strIconDetails: String, strJobHour: String, strJobTitle: String, strJobSubTitle: String, strJobLocation: String, strShift: String, strJobPosted: String, strFullTime: String, strJobDesc: String, save: Int, apply: Int) {
        viewBG.alpha = 0.0
        if apply == 0 {
            self.btnApply.isHidden = false
        } else {
            self.btnApply.isHidden = true
        }
        self.imgJobIcon.setImage(withURL: NSURL(string: strIconDetails)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
        self.lblHour.text = strJobHour
        self.lblShift.text = strShift
        self.lblJobRole.text = strJobTitle
        self.lblCompName.text = strJobSubTitle
        self.lblFullTime.text = strFullTime
        self.lblLocation.text = strJobLocation
        self.lblJobPosted.text = strJobPosted
        if save == 0 {
            self.btnBookmark.setImage(UIImage(named: "star_white"), for: .normal)
        } else {
            self.btnBookmark.setImage(UIImage(named: "star_bookmark"), for: .normal)
        }
        self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25) {
            self.viewBG.alpha = 0.3
            self.viewPopUp.transform = .identity
        }
        
    }
    
    
    
    /// DismissAnimate
    func dismissAnimate() {
        
        if didRemove != nil {
            didRemove!("Remove")
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0.0
            self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25) {
                self.viewPopUp.transform = IS_IPAD() ? .identity : CGAffineTransform(translationX: 0, y: -(keyboardSize.height / 2))
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.viewPopUp.transform = .identity
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - SaveJobAPICall
extension CallOutController {
    func saveJobAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("saveJob"), attributes: .concurrent)
        API_MODELS_METHODS.jobFunction(queue: concurrentQueue, action: "save", jobId: self.strJobId) { (responseDict,isSuccess) in
            if isSuccess {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                self.btnBookmark.setImage(UIImage(named: "star_bookmark"), for: .normal)
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully saved", didSubmit: { (text) in
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


