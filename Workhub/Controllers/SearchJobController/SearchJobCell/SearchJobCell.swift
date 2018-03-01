//
//  SearchJobCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 12/2/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

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
//                    self.btnTick.setImage(UIImage(named: "Tick"), for: .normal)
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
        self.didCallApplyAPIJobs!(self.jobId)
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



