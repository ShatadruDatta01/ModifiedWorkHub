//
//  AboutWorkhubController.swift
//  Workhub
//
//  Created by Administrator on 14/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class AboutWorkhubController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        // Do any additional setup after loading the view.
    }
}
