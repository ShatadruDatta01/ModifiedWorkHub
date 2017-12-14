//
//  ButtonCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class ButtonCell: BaseTableViewCell {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                self.btnTerms.addTarget(self, action: #selector(ButtonCell.termsPageVC), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    func termsPageVC() {
        let termsPageVC = mainStoryboard.instantiateViewController(withIdentifier: "TermsCondsController") as! TermsCondsController
        NavigationHelper.helper.contentNavController!.pushViewController(termsPageVC, animated: true)
    }
}
