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

    var strIconDetails: String!
    var strJobTitle: String!
    var strJobSubTitle: String!
    var strJobHour: String!
    var strJobLocation: String!
    var strJobPosted: String!
    var strShift: String!
    var strFullTime: String!
    var strJobDesc: String!
    @IBOutlet weak var jobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: MarqueeLabel!
    @IBOutlet weak var lblJobSubtitle: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblJobPosted: UILabel!
    @IBOutlet weak var lblDayShift: UILabel!
    @IBOutlet weak var lblFulltime: UILabel!
    @IBOutlet weak var lblJobDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.tableView.estimatedRowHeight = 66.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isBack = false
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
    }

    @IBAction func applyNow(_ sender: UIButton) {
        let applyPageVC = mainStoryboard.instantiateViewController(withIdentifier: "ApplyJobController") as! ApplyJobController
        applyPageVC.strJobIcon = strIconDetails
        applyPageVC.strJobTitle = strJobTitle
        applyPageVC.strJobSubTitle = strJobSubTitle
        NavigationHelper.helper.contentNavController!.pushViewController(applyPageVC, animated: false)
    }
    
    @IBAction func bookmark(_ sender: UIButton) {
        
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
        case 1, 2, 3, 4, 5:
            return 50.0
        case 6:
            return UITableViewAutomaticDimension
        default:
            return 110.0
        }
    }
}
