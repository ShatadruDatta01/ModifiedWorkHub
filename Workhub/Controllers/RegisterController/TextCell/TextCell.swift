//
//  TextCell.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class TextCell: BaseTableViewCell {

    var index: Int!
    var didSendValue:((String, Int)->())!
    @IBOutlet weak var btnVisibility: UIButton!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtField: UITextField!
    override var datasource: AnyObject?{
        didSet {
            if datasource != nil {
                if index == 1 {
                    self.topConstraint.constant = 15.0
                    self.widthConstraint.constant = 20.0
                    self.heightConstraint.constant = 15.0
                } else {
                    self.topConstraint.constant = 11.0
                    self.widthConstraint.constant = 20.0
                    self.heightConstraint.constant = 20.0
                }
                
                if index == 3 {
                    self.txtField.isSecureTextEntry = true
                    self.btnVisibility.isHidden = false
                } else {
                    self.btnVisibility.isHidden = true
                    
                }
                
                self.btnVisibility.addTarget(self, action: #selector(TextCell.visibilityPassword), for: .touchUpInside)
            }
        }
    }
    
    
    /// VisibilityPassword
    func visibilityPassword(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.txtField.isSecureTextEntry = true
            self.btnVisibility.setImage(UIImage(named: "Visibility_off"), for: .normal)
        } else {
            sender.isSelected = true
            self.txtField.isSecureTextEntry = false
            self.btnVisibility.setImage(UIImage(named: "Visibility_on"), for: .selected)
        }
    }
}


// MARK: - UITextFieldDelegate
extension TextCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtField.resignFirstResponder()
        return true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print(textField.text!)
        self.didSendValue!(textField.text!, index)
    }
}
