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

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewWorkhub: UIView!
    @IBOutlet weak var viewWorkhubConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
        self.tokenAPICall()
        self.startingView()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Token API Call
extension LaunchController {
    func tokenAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getToken"), attributes: .concurrent)
        API_MODELS_METHODS.token(queue: concurrentQueue) { (responseDict,isSuccess) in
            if isSuccess {
                AppConstantValues.companyAccessToken = responseDict!["result"]!["data"]["access_token"].stringValue
                //self.startingView()
            } else {
                
            }
        }
    }
}


// MARK: - Starting View
extension LaunchController {
    func startingView() {
        self.imgLogo.alpha = 0.3
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
        Timer.scheduledTimer(timeInterval: 0.3,
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

        UIView.animate(withDuration: Double(0.5), animations: {
            self.imgLogo.alpha = 1.0
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
        let jobPageVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchJobController") as! SearchJobController
        NavigationHelper.helper.contentNavController!.pushViewController(jobPageVC, animated: true)
    }
}
