//
//  SearchJobCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 12/2/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import CoreLocation

class SearchJobCell: BaseTableViewCell {

    var checkController = false
    var jobId: String!
    var didSendValue:((String, Bool) -> ())!
    var didCallLoader: (()->())!
    var didCallApplyAPIJobs: ((String)->())!
    var jobType: String!
    @IBOutlet weak var viewHour: UIView!
    @IBOutlet weak var viewMiles: UIView!
    @IBOutlet weak var imgJobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblSubJobTitle: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnTick: UIButton!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                let val = datasource as! SearchJob
                
                let currentCoordinate = CLLocation(latitude: Double(AppConstantValues.latitide)!, longitude: Double(AppConstantValues.longitude)!)
                let jobCoordinate = CLLocation(latitude: Double(val.latitude!)!, longitude: Double(val.longitude!)!)
                let distanceInMeters = currentCoordinate.distance(from: jobCoordinate)
                print(distanceInMeters)
                let double = distanceInMeters/1609
                let doubleStr = String(format: "%.1f", double)
                self.lblMiles.text = "\(doubleStr) miles"
                
                if let save = val.save {
                    if save == 0 {
                        self.btnBookmark.setImage(UIImage(named: "star_white"), for: .normal)
                    } else {
                        self.btnBookmark.setImage(UIImage(named: "star_bookmark"), for: .normal)
                    }
                } else {
                    self.btnBookmark.setImage(UIImage(named: "star_white"), for: .normal)
                }
                
                self.jobId = val.jobID!
                self.lblJobTitle.text = val.role!
                self.lblSubJobTitle.text = val.company_name!
                self.lblHour.text = "\(val.salary_per_hour!) per hour"
                self.imgJobIcon.setImage(withURL: NSURL(string: val.category_image!)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
                self.viewHour.layer.borderWidth = 1.0
                self.viewHour.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
                self.viewMiles.layer.borderWidth = 1.0
                self.viewMiles.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
                if self.jobType == "save" {
                    if let apply = val.apply {
                        if apply == 1 {
                            self.btnTick.setImage(UIImage(named: "GreenTick"), for: .normal)
                            self.btnTick.isUserInteractionEnabled = false
                        } else {
                            self.btnTick.setImage(UIImage(named: "Tick"), for: .normal)
                            self.btnTick.isUserInteractionEnabled = true
                        }
                    }
                } else {
                    if let apply = val.apply {
                        if apply == 1 {
                            self.btnTick.setImage(UIImage(named: "GreenTick"), for: .normal)
                            self.btnTick.isUserInteractionEnabled = false
                        } else {
                            self.btnTick.setImage(UIImage(named: "Tick"), for: .normal)
                            self.btnTick.isUserInteractionEnabled = true
                        }
                    }
                }
                
                self.btnTick.addTarget(self, action: #selector(SearchJobCell.moveToApplyJob), for: UIControlEvents.touchUpInside)
                self.btnBookmark.addTarget(self, action: #selector(SearchJobCell.saveJob), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    
    /// Move To ApplyJob
    func moveToApplyJob() {
        
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
            for aviewcontroller: UIViewController in allViewController
            {
                if aviewcontroller.isKind(of: LoginController.classForCoder())
                {
                    NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                    self.checkController = true
                    break
                }
            }
            
            if self.checkController == false {
                let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                NavigationHelper.helper.contentNavController!.pushViewController(loginVC, animated: true)
            }
            self.checkController = false
        } else {
            
            if String(describing: OBJ_FOR_KEY(key: "Resume")!) == "" || String(describing: OBJ_FOR_KEY(key: "Resume")!) == "0" {
                AppConstantValues.isResumeUploaded = false
            } else {
                AppConstantValues.isResumeUploaded = true
            }
            
            if AppConstantValues.isResumeUploaded == true {
                self.didCallApplyAPIJobs!(self.jobId)
            } else {
                let val = datasource as! SearchJob
                let applyPageVC = mainStoryboard.instantiateViewController(withIdentifier: "ApplyJobController") as! ApplyJobController
                applyPageVC.strJobIcon = val.category_image!
                applyPageVC.strJobTitle = val.role!
                applyPageVC.strJobSubTitle = val.company_name!
                applyPageVC.strJobId = val.jobID!
                applyPageVC.save = val.save!
                NavigationHelper.helper.contentNavController!.pushViewController(applyPageVC, animated: true)
            }
        }
    }
    
    
    /// SavedJobs
    func saveJob() {
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
            for aviewcontroller: UIViewController in allViewController
            {
                if aviewcontroller.isKind(of: LoginController.classForCoder())
                {
                    NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                    self.checkController = true
                    break
                }
            }
            
            if self.checkController == false {
                let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                NavigationHelper.helper.contentNavController!.pushViewController(loginVC, animated: true)
            }
            self.checkController = false
        } else {
            self.didCallLoader!()
            self.saveJobAPICall()
        }
    }
}



// MARK: - SaveJobAPICall
extension SearchJobCell {
    func saveJobAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("saveJob"), attributes: .concurrent)
        print(self.jobId)
        API_MODELS_METHODS.jobFunction(queue: concurrentQueue, action: "save", jobId: self.jobId) { (responseDict,isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.didSendValue!("callAPI", responseDict!["result"]!["status"].bool!)
            } else {
                self.didSendValue!(responseDict!["result"]!["error"]["msgUser"].stringValue, responseDict!["result"]!["status"].bool!)
            }
        }
    }
}



