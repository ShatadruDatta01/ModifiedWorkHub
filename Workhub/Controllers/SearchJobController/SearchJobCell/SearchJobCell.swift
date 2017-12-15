//
//  SearchJobCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 12/2/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class SearchJobCell: BaseTableViewCell {

    var jobId: String!
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
                self.jobId = val.jobID!
                self.lblJobTitle.text = val.role!
                self.lblSubJobTitle.text = val.company_name!
                self.lblHour.text = "\(val.salary_per_hour!) per hour"
                self.imgJobIcon.setImage(withURL: NSURL(string: val.category_image!)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
                self.viewHour.layer.borderWidth = 1.0
                self.viewHour.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
                self.viewMiles.layer.borderWidth = 1.0
                self.viewMiles.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
                self.btnTick.addTarget(self, action: #selector(SearchJobCell.moveToApplyJob), for: UIControlEvents.touchUpInside)
                self.btnBookmark.addTarget(self, action: #selector(SearchJobCell.saveJob), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    
    /// Move To ApplyJob
    func moveToApplyJob() {
        let applyJobPageVC = mainStoryboard.instantiateViewController(withIdentifier: "ApplyJobController") as! ApplyJobController
        let val = datasource as! SearchJob
        applyJobPageVC.strJobIcon = val.category_image!
        applyJobPageVC.strJobTitle = val.role!
        applyJobPageVC.strJobSubTitle = val.company_name!
        NavigationHelper.helper.contentNavController!.pushViewController(applyJobPageVC, animated: false)
    }
    
    
    /// SavedJobs
    func saveJob() {
        self.saveJobAPICall()
    }
}



// MARK: - SaveJobAPICall
extension SearchJobCell {
    func saveJobAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("saveJob"), attributes: .concurrent)
        API_MODELS_METHODS.jobFunction(queue: concurrentQueue, action: "save", jobId: self.jobId) { (responseDict,isSuccess) in
            if isSuccess {
                print(responseDict!)
            } else {
                
            }
        }
    }
}



