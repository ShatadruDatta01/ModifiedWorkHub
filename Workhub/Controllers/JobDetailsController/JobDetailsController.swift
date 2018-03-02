//
//  JobDetailsController.swift
//  Workhub
//
//  Created by Administrator on 04/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import MarqueeLabel
class JobDetailsController: BaseTableViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var strJobId: String!
    var strJobFunction: String!
    var strIconDetails: String!
    var strJobTitle: String!
    var strJobSubTitle: String!
    var strJobHour: String!
    var strJobLocation: String!
    var strJobPosted: String!
    var strShift: String!
    var strFullTime: String!
    var strJobDesc: String!
    var save = 0
    var apply = 0
    var checkController = false
    @IBOutlet weak var lblApply: UILabel!
    @IBOutlet weak var btnApplyJobs: UIButton!
    @IBOutlet weak var jobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: MarqueeLabel!
    @IBOutlet weak var lblJobSubtitle: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblJobPosted: UILabel!
    @IBOutlet weak var lblDayShift: UILabel!
    @IBOutlet weak var lblFulltime: UILabel!
    @IBOutlet weak var lblJobDescription: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.strJobFunction == "apply" {
            self.btnApplyJobs.isHidden = true
            self.lblApply.isHidden = true
        } else {
            if apply == 1 {
                self.btnApplyJobs.isHidden = true
                self.lblApply.isHidden = true
            } else {
                self.btnApplyJobs.isHidden = false
                self.lblApply.isHidden = false
            }
        }
        
        self.jobIcon.setImage(withURL: NSURL(string: strIconDetails)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
        self.lblJobTitle.text = strJobTitle
        self.lblJobTitle.speed = .duration(8.0)
        self.lblJobTitle.fadeLength = 15.0
        self.lblJobTitle.type = .continuous
        self.lblJobSubtitle.text = strJobSubTitle
        self.lblHour.text = "\(strJobHour!) per hour"
        self.lblLocation.text = strJobLocation
        self.lblJobPosted.text = strJobPosted
        self.lblDayShift.text = "\(strShift!) shift"
        self.lblFulltime.text = strFullTime
        self.lblJobDescription.text = strJobDesc
        if save == 0 {
            self.btnBookmark.setImage(UIImage(named: "star_white"), for: .normal)
        } else {
            self.btnBookmark.setImage(UIImage(named: "star_bookmark"), for: .normal)
        }
        self.tableView.estimatedRowHeight = 66.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
    }

    @IBAction func applyNow(_ sender: UIButton) {
        
        
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
                applyPageVC.strJobFunction = self.strJobFunction
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
    
    @IBAction func cross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}


// MARK: - TableViewDelegate
extension JobDetailsController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130.0
        case 1:
            return 50.0
        case 2:
            return 50.0
        case 3:
            if self.strJobFunction == "view" {
                return 50.0
            } else {
                return 0
            }
        case 4:
            return 50.0
        case 5:
            return 50.0
        case 6:
            return UITableViewAutomaticDimension
        default:
            return 110.0
        }
    }
}



// MARK: - SaveJobAPICall
extension JobDetailsController {
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
