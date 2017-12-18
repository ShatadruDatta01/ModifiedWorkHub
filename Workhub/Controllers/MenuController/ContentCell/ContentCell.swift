//
//  ContentCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class ContentCell: BaseTableViewCell {

    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                self.lblText1.text = datasource as? String
                self.lblText2.text = "What would you like to do?"
            }
        }
    }

}
