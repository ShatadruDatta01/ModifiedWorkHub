//
//  JobDetailsController.swift
//  Workhub
//
//  Created by Administrator on 04/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class JobDetailsController: BaseTableViewController {

    @IBOutlet weak var jobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblJobSubtitle: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblJobPosted: UILabel!
    @IBOutlet weak var lblDayShift: UILabel!
    @IBOutlet weak var lblFulltime: UILabel!
    @IBOutlet weak var lblJobDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
