//
//  AppliedListJobsController.swift
//  Workhub
//
//  Created by Administrator on 16/02/18.
//  Copyright © 2018 Sociosquares. All rights reserved.
//

import UIKit

class AppliedListJobsController: BaseViewController {

    var strJobs: String!
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
        self.lblHeaderContent.text = "JOBS YOU'VE APPLIED FOR"
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        self.jobListAPICall()
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension AppliedListJobsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJob.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppliedListJobsCell", for: indexPath) as! AppliedListJobsCell
        cell.datasource = self.arrJob[indexPath.row] as AnyObject
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
        jobDetailsPageVC.strJobId = val.jobID!
        jobDetailsPageVC.strFullTime = val.type!
        jobDetailsPageVC.strJobDesc = val.jobDetail!
        jobDetailsPageVC.strJobFunction = self.strJobs
        NavigationHelper.helper.contentNavController!.pushViewController(jobDetailsPageVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}



// MARK: - UserListAPICall
extension AppliedListJobsController {
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
                    self.lblNoData.text = "You've not applied to any job!"
                    
                }
            } else {
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
            }
        }
    }
}
