//
//  CallOutController.swift
//  Workhub
//
//  Created by Shatadru Datta on 12/9/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class CallOutController: BaseViewController {

     var strIconDetails = ""
     var strJobHour = ""
     var strJobTitle = ""
     var strJobSubTitle = ""
     var strJobLocation = ""
     var strShift = ""
     var strJobPosted = ""
     var strFullTime = ""
     var strJobDesc = ""
    
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
    
    
    var didSubmitButton:((_ text: String) -> ())?
    var didRemove:((_ text: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismissAnimate()
    }
    
    @IBAction func apply(_ sender: UIButton) {
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
        NavigationHelper.helper.contentNavController!.pushViewController(jobDetailsPageVC, animated: false)
    }
    
    @IBAction func jobSave(_ sender: UIButton) {
    }
    
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, strIconDetails: String, strJobHour: String, strJobTitle: String, strJobSubTitle: String, strJobLocation: String, strShift: String, strJobPosted: String, strFullTime: String, strJobDesc: String, didSubmit: @escaping ((_ text: String) -> ()), didFinish: @escaping ((_ text: String) -> ())) {
        
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "CallOutController") as! CallOutController
        commentPopVC.didSubmitButton = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceController: sourceViewController, strIconDetails: strIconDetails, strJobHour: strJobHour, strJobTitle: strJobTitle, strJobSubTitle: strJobSubTitle, strJobLocation: strJobLocation, strShift: strShift, strJobPosted: strJobPosted, strFullTime: strFullTime, strJobDesc: strJobDesc)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController, strIconDetails: String, strJobHour: String, strJobTitle: String, strJobSubTitle: String, strJobLocation: String, strShift: String, strJobPosted: String, strFullTime: String, strJobDesc: String) {
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
        presentAnimationToView(strIconDetails: self.strIconDetails, strJobHour: self.strJobHour, strJobTitle: self.strJobTitle, strJobSubTitle: self.strJobSubTitle, strJobLocation: self.strJobLocation, strShift: self.strShift, strJobPosted: self.strJobPosted, strFullTime: self.strFullTime, strJobDesc: self.strJobDesc)
    }
    
    // MARK: - Animation
    func presentAnimationToView(strIconDetails: String, strJobHour: String, strJobTitle: String, strJobSubTitle: String, strJobLocation: String, strShift: String, strJobPosted: String, strFullTime: String, strJobDesc: String) {
        viewBG.alpha = 0.0
        self.imgJobIcon.setImage(withURL: NSURL(string: strIconDetails)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
        self.lblHour.text = strJobHour
        self.lblShift.text = strShift
        self.lblJobRole.text = strJobTitle
        self.lblCompName.text = strJobSubTitle
        self.lblFullTime.text = strFullTime
        self.lblLocation.text = strJobLocation
        self.lblJobPosted.text = strJobPosted
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
