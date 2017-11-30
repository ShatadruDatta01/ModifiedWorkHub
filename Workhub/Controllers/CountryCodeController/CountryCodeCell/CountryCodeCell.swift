//
//  CountryCodeCell.swift
//  Workhub
//
//  Created by Administrator on 30/11/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class CountryCodeCell: BaseTableViewCell {

    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                self.lblCountry.text = String(describing: datasource!["name"]!!)
                self.lblCode.text = String(describing: datasource!["dial_code"]!!)
                self.imgFlag.image = UIImage(named: "\(datasource!["name"]!!).png")
            }
        }
    }
}
