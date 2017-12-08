//
//  MobCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class MobCell: BaseTableViewCell {

    var didSendValue:((String, Int)->())!
    var didSendCountryVal: ((String)->())!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnExt: UIButton!
    @IBOutlet weak var txtMobNo: UITextField!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                self.btnExt.addTarget(self, action: #selector(MobCell.openCountrycode), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    func openCountrycode() {
        self.didSendCountryVal("CountryCode")
    }
}


// MARK: - UITextFieldDelegate
extension MobCell: UITextFieldDelegate {
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.didSendValue!(textField.text!, 2)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.didSendCountryVal(textField.text!)
        self.txtMobNo.resignFirstResponder()
        return true
    }
}
