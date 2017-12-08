//
//  LogoutCell.swift
//  Workhub
//
//  Created by Administrator on 08/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class LogoutCell: BaseTableViewCell {

    @IBOutlet weak var btnLogout: UIButton!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
            }
        }
    }
}
