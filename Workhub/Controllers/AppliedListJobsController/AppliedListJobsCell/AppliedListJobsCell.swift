//
//  AppliedListJobsCell.swift
//  Workhub
//
//  Created by Administrator on 16/02/18.
//  Copyright © 2018 Sociosquares. All rights reserved.
//

import UIKit

class AppliedListJobsCell: BaseTableViewCell {

    @IBOutlet weak var imgJobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblSubJobTitle: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                let val = datasource as! SearchJob
                self.lblJobTitle.text = val.role!
                self.lblSubJobTitle.text = val.company_name!
                self.lblMiles.text = "> 100 miles"
                self.imgJobIcon.setImage(withURL: NSURL(string: val.category_image!)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
            }
        }
    }
}
