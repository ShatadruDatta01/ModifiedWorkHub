//
//  SearchJobCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 12/2/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class SearchJobCell: BaseTableViewCell {

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
                self.lblJobTitle.text = val.role!
                self.lblSubJobTitle.text = val.company_name!
                self.lblHour.text = "\(val.salary_per_hour!) per hour"
                self.imgJobIcon.setImage(withURL: NSURL(string: val.category_image!)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
                self.viewHour.layer.borderWidth = 1.0
                self.viewHour.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
                self.viewMiles.layer.borderWidth = 1.0
                self.viewMiles.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
            }
        }
    }

}
