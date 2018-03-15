//
//  SavedAppliedJobsController.swift
//  Workhub
//
//  Created by Administrator on 18/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class SavedAppliedJobsController: BaseViewController {

    var strJobs: String!
    var strJobId: String!
    @IBOutlet weak var lblHeaderContent: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    @IBOutlet weak var tblList: UITableView!
    var arrJob = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        circleIndicator.isHidden = false
        circleIndicator.animate()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.strJobs == "save" {
            self.lblHeaderContent.text = "JOBS YOU'VE SAVED FOR LATER"
        } else {
            self.lblHeaderContent.text = "JOBS YOU'VE APPLIED FOR"
        }
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        self.jobListAPICall()
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension SavedAppliedJobsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJob.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchJobCell", for: indexPath) as! SearchJobCell
        cell.jobType = "save"
        cell.datasource = self.arrJob[indexPath.row] as AnyObject
        cell.didCallLoader = {
            self.circleIndicator.isHidden = false
            self.circleIndicator.animate()
        }
        cell.didSendValue = { text, check in
            self.circleIndicator.isHidden = true
            self.circleIndicator.stop()
            if check {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully saved", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            } else {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: text, didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        }
        
        cell.didCallApplyAPIJobs = { jobId in
            self.strJobId = jobId
            self.circleIndicator.isHidden = false
            self.circleIndicator.animate()
            self.applyJobAPICall()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailsPageVC = mainStoryboard.instantiateViewController(withIdentifier: "JobDetailsController") as! JobDetailsController
        let val = self.arrJob[indexPath.row] as! SearchJob
        jobDetailsPageVC.strIconDetails = val.category_image!
        jobDetailsPageVC.strJobHour = val.salary_per_hour!
        jobDetailsPageVC.strJobTitle = val.role!
        jobDetailsPageVC.strJobSubTitle = val.company_name!
        jobDetailsPageVC.strJobLocation = "\(val.state!), \(val.city!)"
        jobDetailsPageVC.strShift = val.shift!
        if let posted_on  = val.posted_on {
            jobDetailsPageVC.strJobPosted = posted_on
        }
        if let save = val.save {
            jobDetailsPageVC.save = save
        }
        if let apply = val.apply {
            jobDetailsPageVC.apply = apply
        }
        jobDetailsPageVC.strJobId = val.jobID!
        jobDetailsPageVC.strFullTime = val.type!
        jobDetailsPageVC.strJobDesc = val.jobDetail!
        jobDetailsPageVC.strJobFunction = self.strJobs
        NavigationHelper.helper.contentNavController!.pushViewController(jobDetailsPageVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}



// MARK: - UserListAPICall
extension SavedAppliedJobsController {
    func jobListAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getJobFunction"), attributes: .concurrent)
        API_MODELS_METHODS.getJobList(queue: concurrentQueue, action: self.strJobs) { (responseDict, isSuccess) in
            print(responseDict!)
            if isSuccess {
                self.circleIndicator.stop()
                self.circleIndicator.isHidden = true
                if responseDict!["result"]!["data"].count > 0 {
                    
                    if self.arrJob.count > 0 {
                        self.arrJob.removeAll()
                    }
                    
                    self.tblList.isHidden = false
                    for value in responseDict!["result"]!["data"].arrayObject! {
                        let objJobList = SearchJob(withDictionary: value as! [String : AnyObject])
                        self.arrJob.append(objJobList)
                    }
                    self.tblList.reloadData()
                } else {
                    self.tblList.isHidden = true
                    if self.strJobs == "save" {
                        self.lblNoData.text = "You've not saved any job!"
                    } else {
                        self.lblNoData.text = "You've not applied to any job!"
                    }
                }
            } else {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
            }
        }
    }
    
    
    /// ApplyJobAPICall
    func applyJobAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("saveJob"), attributes: .concurrent)
        API_MODELS_METHODS.jobFunction(queue: concurrentQueue, action: "apply", jobId: self.strJobId) { (responseDict,isSuccess) in
            print(responseDict!)
            if isSuccess {

                WellDoneController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully applied for this job", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
                
                self.jobListAPICall()
                
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


