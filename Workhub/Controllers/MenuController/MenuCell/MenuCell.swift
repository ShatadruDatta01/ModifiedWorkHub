//
//  MenuCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class MenuCell: BaseTableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var lblMenu: UILabel!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                self.lblMenu.text = datasource as? String
            }
        }
    }
}
