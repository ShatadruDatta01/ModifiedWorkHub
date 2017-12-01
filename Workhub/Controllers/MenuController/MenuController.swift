//
//  MenuController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class MenuController: BaseViewController {

    var arrMenu = ["REGISTER", "LOGIN"]
    @IBOutlet weak var tblMenu: UITableView!
    var checkController = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionTermsConds(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: false)
        let termsPageVC = mainStoryboard.instantiateViewController(withIdentifier: "TermsCondsController") as! TermsCondsController
        NavigationHelper.helper.contentNavController!.pushViewController(termsPageVC, animated: true)
    }
    
    
    @IBAction func actionAboutWorkhub(_ sender: UIButton) {
        
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return self.arrMenu.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cellTitle = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
                cellTitle.datasource = "" as AnyObject
                cellTitle.selectionStyle = .none
                return cellTitle
            case 1:
                let cellProf = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
                cellProf.datasource = "" as AnyObject
                cellProf.selectionStyle = .none
                return cellProf
            default:
                let cellContent = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
                cellContent.datasource = "" as AnyObject
                cellContent.selectionStyle = .none
                return cellContent
            }
        default:
            let cellMenu = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cellMenu.datasource = self.arrMenu[indexPath.row] as AnyObject
            cellMenu.selectionStyle = .none
            return cellMenu
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return 60.0
            case 1:
                return 112.0
            default:
                return 54.0
            }
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                let registerPageVC = mainStoryboard.instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
                NavigationHelper.helper.contentNavController!.pushViewController(registerPageVC, animated: true)
            default:
                let loginPageVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                NavigationHelper.helper.contentNavController!.pushViewController(loginPageVC, animated: true)
            }
        default:
            print("No Code")
        }
        NavigationHelper.helper.openSidePanel(open: false)
    }
    
}
