//
//  LaunchController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class LaunchController: BaseViewController {

    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewWorkhub: UIView!
    @IBOutlet weak var viewWorkhubConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkAccess), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        self.imgLogo.alpha = 0
        self.imgTitle.alpha = 0
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
        
        self.getConfigFiles()
        
        if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
            self.tokenAPICall()
        } else {
            self.startingView()
        }
        // Do any additional setup after loading the view.
    }
    
    
    /// NetworkAccess
    func networkAccess() {
        if AppConstantValues.isNetwork == "true" {
            if OBJ_FOR_KEY(key: "isLogin") == nil || String(describing: OBJ_FOR_KEY(key: "isLogin")!) == "0" {
                self.tokenAPICall()
            } else {
                self.startingView()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - GetAppConfigFiles
extension LaunchController {
    
    /// The Method calls the Terms and Condition WebService to fetch the Terms.
    func getConfigFiles() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getAppConfig"), attributes: .concurrent)
        API_MODELS_METHODS.appConfig(queue: concurrentQueue) { (responseDict,isSuccess) in
            if isSuccess {
                print(responseDict!)
            } else {
                
            }
        }
    }
}



// MARK: - Token API Call
extension LaunchController {
    func tokenAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getToken"), attributes: .concurrent)
        API_MODELS_METHODS.token(queue: concurrentQueue) { (responseDict,isSuccess) in
            if isSuccess {
                REMOVE_OBJ_FOR_KEY(key: "AccessToken")
                SET_OBJ_FOR_KEY(obj: responseDict!["result"]!["data"]["access_token"].stringValue as AnyObject, key: "AccessToken")
                self.startingView()
            } else {
                
            }
        }
    }
}


// MARK: - Starting View
extension LaunchController {
    func startingView() {
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(self.updateView),
                             userInfo: nil,
                             repeats: false)
    }
}


// MARK: - UpdateView
extension LaunchController {
    /// UpdateView
    func updateView() {
        self.viewWorkhubConstraint.constant = 0
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: Double(1.0), animations: {
            self.imgLogo.alpha = 1.0
            self.imgTitle.alpha = 1.0
            self.viewWorkhubConstraint.constant = self.view.frame.size.height/2
            self.view.layoutIfNeeded()
            
            Timer.scheduledTimer(timeInterval: 1.5,
                                 target: self,
                                 selector: #selector(self.moveToController),
                                 userInfo: nil,
                                 repeats: false)
        })
    }
    
    
    /// MoveToJobController
    func moveToController() {
        if Reachability.isConnectedToNetwork(){
            let jobPageVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchJobController") as! SearchJobController
            NavigationHelper.helper.contentNavController!.pushViewController(jobPageVC, animated: true)
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
    }
}
