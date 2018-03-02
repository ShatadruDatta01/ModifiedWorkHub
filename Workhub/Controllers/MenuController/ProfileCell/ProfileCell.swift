//
//  ProfileCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class ProfileCell: BaseTableViewCell {

    var isLogin: Bool!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                if self.isLogin == true {
                    if datasource as! String != "" {
                        self.imgProfile.imageFromURL(urlString: datasource as! String)
                    }
                } else {
                    self.imgProfile.image = UIImage(named: "Camera")
                }
            }
        }
    }
}
//9007062026 - Manos
