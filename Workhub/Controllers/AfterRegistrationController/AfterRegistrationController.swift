//
//  AfterRegistrationController.swift
//  Workhub
//
//  Created by Shatadru Datta on 1/17/18.
//  Copyright © 2018 Sociosquares. All rights reserved.
//

import UIKit

class AfterRegistrationController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController?.isBack = false
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: false)
        Timer.scheduledTimer(timeInterval: 2.0,
                             target: self,
                             selector: #selector(self.messageView),
                             userInfo: nil,
                             repeats: false)
        // Do any additional setup after loading the view.
    }
    
    
    /// Message View
    func messageView() {
        self.presentAlertWithTitle(title: "All done!", message: "Congratulations on registering with WorkHub.")
    }

    
    /// LetsGo
    ///
    /// - Parameter sender: Button
    @IBAction func letsGo(_ sender: UIButton) {
        let jobPageVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchJobController") as! SearchJobController
        NavigationHelper.helper.contentNavController!.pushViewController(jobPageVC, animated: true)
    }
    
}
