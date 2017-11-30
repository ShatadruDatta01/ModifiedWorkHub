//
//  SearchJobController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import MapKit

class SearchJobController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isBack = false
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
    }

}
