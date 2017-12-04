//
//  RegisterController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterController: BaseViewController {

    var arrCountryCode = [AnyObject]()
    var dictCountryCode = [String: String]()
    @IBOutlet weak var tblRegister: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCountryCode()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)

    }
}


// MARK: - FetchCountryCode
extension RegisterController {
    func fetchCountryCode() {
        let path =  Bundle.main.path(forResource: "CountryCodes", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        print(jsonData!)
        let jsonResult: NSArray = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        for result in jsonResult {
            let val = JSON(result)
            self.dictCountryCode = ["name": val["name"].stringValue, "dial_code": val["dial_code"].stringValue, "code": val["code"].stringValue]
            print(self.dictCountryCode)
            self.arrCountryCode.append(self.dictCountryCode as AnyObject)
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension RegisterController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cellRegister = tableView.dequeueReusableCell(withIdentifier: "RegisterCell", for: indexPath) as! RegisterCell
            cellRegister.datasource = "" as AnyObject
            cellRegister.selectionStyle = .none
            return cellRegister
        default:
            switch indexPath.row {
            case 0:
                let cellName = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cellName.index = indexPath.row
                cellName.datasource = "" as AnyObject
                cellName.imgLogo.image = UIImage(named: "UserIcon")
                cellName.txtField.placeholder = "Full Name"
                cellName.selectionStyle = .none
                return cellName
            case 1:
                let cellEmail = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cellEmail.index = indexPath.row
                cellEmail.datasource = "" as AnyObject
                cellEmail.imgLogo.image = UIImage(named: "Mail")
                cellEmail.txtField.placeholder = "Email"
                cellEmail.selectionStyle = .none
                return cellEmail
            case 2:
                let cellMob = tableView.dequeueReusableCell(withIdentifier: "MobCell", for: indexPath) as! MobCell
                cellMob.datasource = "" as AnyObject
                cellMob.imgLogo.image = UIImage(named: "Call")
                cellMob.txtMobNo.placeholder = "Mobile No"
                cellMob.txtExt.placeholder = "Ext"
                cellMob.didSendVal = { text in
                    if text == "CountryCode" {
                        CountryCodeController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Select Country", arrValue: self.arrCountryCode, didSubmit: { (coountryName, code, countryCode) in
                            cellMob.txtExt.text = "(\(code)) \(countryCode)"
                            cellMob.imgFlag.image = UIImage(named: "\(coountryName).png")
                        }) {
                            debugPrint("No Code")
                        }
                    }
                }
                cellMob.selectionStyle = .none
                return cellMob
            case 3:
                let cellPassword = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cellPassword.index = indexPath.row
                cellPassword.datasource = "" as AnyObject
                cellPassword.imgLogo.image = UIImage(named: "PasswordIcon")
                cellPassword.txtField.placeholder = "Create Password"
                cellPassword.selectionStyle = .none
                return cellPassword
            default:
                let cellButton = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                cellButton.datasource = "" as AnyObject
                cellButton.selectionStyle = .none
                return cellButton
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 180.0
        default:
            switch indexPath.row {
            case 0...3:
                return 55.0
            default:
                return 99.0
            }
        }
    }
}
