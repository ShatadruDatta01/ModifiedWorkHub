//
//  MenuController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import TGCameraViewController

class MenuController: BaseViewController {

    var cameraImage = false
    var imageProf: UIImage!
    var arrMenuBeforeLogin = ["REGISTER", "LOGIN"]
    var arrMenuBeforeLoginImg = ["REGISTER", "LOGIN"]
    var arrMenuAfterLogin = ["EDIT PROFILE", "UPDATE RESUME", "APPLIED JOBS", "SAVED JOBS"]
    var arrMenuAfterLoginImg = ["REGISTER", "UPDATE_RESUME", "APPLIED", "SAVED_JOBS"]
    @IBOutlet weak var tblMenu: UITableView!
    var checkController = false
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.reloadData = {
            self.tblMenu.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionTermsConds(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: false)
        let termsPageVC = mainStoryboard.instantiateViewController(withIdentifier: "TermsCondsController") as! TermsCondsController
        NavigationHelper.helper.contentNavController!.pushViewController(termsPageVC, animated: true)
    }
    
    
    @IBAction func actionAboutWorkhub(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: false)
        let aboutWorkhubPageVC = mainStoryboard.instantiateViewController(withIdentifier: "AboutWorkhubController") as! AboutWorkhubController
        NavigationHelper.helper.contentNavController!.pushViewController(aboutWorkhubPageVC, animated: true)
    }
}


// MARK: - TGCameraDelegate
extension MenuController: TGCameraDelegate {
    func cameraDidCancel() {
        print("Cancel")
        cameraImage = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        self.imageProf = image;
        self.dismiss(animated: true, completion: nil)
        cameraImage = true
        self.tblMenu.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
    }
    
    func cameraDidTakePhoto(_ image: UIImage!) {
        self.imageProf = image;
        self.dismiss(animated: true, completion: nil)
        cameraImage = true
        self.tblMenu.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            switch section {
            case 0:
                return 3
            default:
                return self.arrMenuBeforeLogin.count
            }
        } else {
            switch section {
            case 0:
                return 3
            case 1:
                return self.arrMenuAfterLogin.count
            default:
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuController.tappedMe))
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
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
                    cellProf.isLogin = false
                    cellProf.datasource = "" as AnyObject
                    cellProf.imgProfile.addGestureRecognizer(tap)
                    cellProf.imgProfile.isUserInteractionEnabled = true
                    cellProf.selectionStyle = .none
                    return cellProf
                default:
                    let cellContent = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
                    cellContent.datasource = "Hello" as AnyObject
                    cellContent.selectionStyle = .none
                    return cellContent
                }
            default:
                let cellMenu = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
                cellMenu.imgMenu.image = UIImage(named: self.arrMenuBeforeLoginImg[indexPath.row])
                cellMenu.datasource = self.arrMenuBeforeLogin[indexPath.row] as AnyObject
                cellMenu.selectionStyle = .none
                return cellMenu
            }

        } else {
            
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
                    cellProf.isLogin = true
                    if self.cameraImage == false {
                        cellProf.datasource = String(describing: OBJ_FOR_KEY(key: "UserPic")!) as AnyObject
                    } else {
                        if self.imageProf != nil {
                            cellProf.imgProfile.image = self.imageProf
                        }
                    }
                    cellProf.imgProfile.addGestureRecognizer(tap)
                    cellProf.imgProfile.isUserInteractionEnabled = true
                    
                    cellProf.selectionStyle = .none
                    return cellProf
                default:
                    let cellContent = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentCell
                    cellContent.datasource = String(describing: OBJ_FOR_KEY(key: "Name")!) as AnyObject
                    cellContent.selectionStyle = .none
                    return cellContent
                }
            case 1:
                let cellMenu = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
                cellMenu.imgMenu.image = UIImage(named: self.arrMenuAfterLoginImg[indexPath.row])
                cellMenu.datasource = self.arrMenuAfterLogin[indexPath.row] as AnyObject
                cellMenu.selectionStyle = .none
                return cellMenu
            default:
                let cellLogout = tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath) as! LogoutCell
                cellLogout.datasource = "" as AnyObject
                cellLogout.btnLogout.addTarget(self, action: #selector(MenuController.logOut), for: UIControlEvents.touchUpInside)
                cellLogout.selectionStyle = .none
                return cellLogout
            }
        }
    }
    
    
    /// Tapped On Profile
    func tappedMe()
    {
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            let loginPageVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            NavigationHelper.helper.contentNavController!.pushViewController(loginPageVC, animated: true)
            NavigationHelper.helper.openSidePanel(open: false)
        } else {
            let navigationController = TGCameraNavigationController.new(with: self)
            self.present(navigationController!, animated: true, completion: nil)
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            
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

        } else {
            
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
            case 1:
                return 50.0
            default:
                return 70.0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    
                    let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
                    for aviewcontroller: UIViewController in allViewController
                    {
                        if aviewcontroller.isKind(of: RegisterController.classForCoder())
                        {
                            NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                            checkController = true
                            break
                        }
                    }
                    
                    if checkController == false {
                        let registerVC = mainStoryboard.instantiateViewController(withIdentifier: "RegisterController") as! RegisterController
                        NavigationHelper.helper.contentNavController!.pushViewController(registerVC, animated: true)
                    }
                    self.checkController = false
                    
                default:
                    
                    let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
                    for aviewcontroller: UIViewController in allViewController
                    {
                        if aviewcontroller.isKind(of: LoginController.classForCoder())
                        {
                            NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                            checkController = true
                            break
                        }
                    }
                    
                    if checkController == false {
                        let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                        NavigationHelper.helper.contentNavController!.pushViewController(loginVC, animated: true)
                    }
                    self.checkController = false
                    
                }
            default:
                print("No Code")
            }

        } else {
            
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    
                    let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
                    for aviewcontroller: UIViewController in allViewController
                    {
                        if aviewcontroller.isKind(of: EditProfileController.classForCoder())
                        {
                            NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                            checkController = true
                            break
                        }
                    }
                    
                    if checkController == false {
                        let editProfileVC = mainStoryboard.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
                        NavigationHelper.helper.contentNavController!.pushViewController(editProfileVC, animated: true)
                    }
                    self.checkController = false
    
                case 1:
                    
                    let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
                    for aviewcontroller: UIViewController in allViewController
                    {
                        if aviewcontroller.isKind(of: UpdateResumeController.classForCoder())
                        {
                            NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                            checkController = true
                            break
                        }
                    }
                    
                    if checkController == false {
                        let updateResumeVC = mainStoryboard.instantiateViewController(withIdentifier: "UpdateResumeController") as! UpdateResumeController
                        NavigationHelper.helper.contentNavController!.pushViewController(updateResumeVC, animated: true)
                    }
                    self.checkController = false
                    
                case 2:
                    
                    let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
                    for aviewcontroller: UIViewController in allViewController
                    {
                        if aviewcontroller.isKind(of: AppliedListJobsController.classForCoder())
                        {
                            NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                            checkController = true
                            break
                        }
                    }
                    
                    if checkController == false {
                        let savedApplyVC = mainStoryboard.instantiateViewController(withIdentifier: "AppliedListJobsController") as! AppliedListJobsController
                        savedApplyVC.strJobs = "apply"
                        NavigationHelper.helper.contentNavController!.pushViewController(savedApplyVC, animated: true)
                    }
                    self.checkController = false
                    
                default:
                    
                    let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
                    for aviewcontroller: UIViewController in allViewController
                    {
                        if aviewcontroller.isKind(of: SavedAppliedJobsController.classForCoder())
                        {
                            NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                            checkController = true
                            break
                        }
                    }
                    
                    if checkController == false {
                        let savedApplyVC = mainStoryboard.instantiateViewController(withIdentifier: "SavedAppliedJobsController") as! SavedAppliedJobsController
                        savedApplyVC.strJobs = "save"
                        NavigationHelper.helper.contentNavController!.pushViewController(savedApplyVC, animated: true)
                    }
                    self.checkController = false
                }
                
            default:
                print("No Code")
            }

        }
        NavigationHelper.helper.openSidePanel(open: false)
    }
}


// MARK: - LogOut
extension MenuController {
    func logOut() {
        self.presentAlertActionWithTitle(title: "Workhub", message: "Do you want to logout?", text: "")
    }
}



