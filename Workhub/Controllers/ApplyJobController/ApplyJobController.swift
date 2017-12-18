//
//  ApplyJobController.swift
//  Workhub
//
//  Created by Administrator on 04/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import MarqueeLabel

class ApplyJobController: BaseTableViewController {

    var strJobIcon: String!
    var strJobTitle: String!
    var strJobSubTitle: String!
    @IBOutlet weak var imgJobIcon: UIImageView!
    @IBOutlet weak var lblJobTitle: MarqueeLabel!
    @IBOutlet weak var lblSubJobTitle: UILabel!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var lblResume: UILabel!
    @IBOutlet weak var viewResume: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtName.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.txtName.layer.borderWidth = 1.0
        self.txtName.isUserInteractionEnabled = false
        self.txtName.text = String(describing: OBJ_FOR_KEY(key: "Name")!)
        self.txtEmail.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.txtEmail.layer.borderWidth = 1.0
        self.txtEmail.isUserInteractionEnabled = false
        self.txtEmail.text = String(describing: OBJ_FOR_KEY(key: "Email")!)
        self.viewResume.layer.borderColor = UIColorRGB(r: 188, g: 188, b: 188)?.cgColor
        self.viewResume.layer.borderWidth = 1.0
        self.imgJobIcon.setImage(withURL: NSURL(string: strJobIcon)!, placeHolderImageNamed: "JobCategoryPlaceholder", andImageTransition: .crossDissolve(0.4))
        self.lblJobTitle.text = strJobTitle
        self.lblJobTitle.speed = .duration(8.0)
        self.lblJobTitle.fadeLength = 15.0
        self.lblJobTitle.type = .continuous
        self.lblSubJobTitle.text = strJobSubTitle
        // Do any additional setup after loading the view.
    }
    
    @IBAction func documentUpload(_ sender: UIButton) {
        
    }
    
    @IBAction func cross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func bookmark(_ sender: UIButton) {
        
    }
    
    @IBAction func submit(_ sender: UIButton) {
        self.presentAlertWithTitle(title: "Workhub", message: "Work under progress")
    }
}


