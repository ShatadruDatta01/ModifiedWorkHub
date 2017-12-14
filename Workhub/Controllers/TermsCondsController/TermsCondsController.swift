//
//  TermsCondsController.swift
//  Workhub
//
//  Created by Administrator on 01/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class TermsCondsController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    @IBOutlet weak var termsView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationHelper.helper.headerViewController?.isBack = true
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        self.termsView.delegate = self
        let url = URL (string: "https://sociosquare.socioadvocacy.com/Terms")
        let requestObj = URLRequest(url: url!)
        self.termsView.loadRequest(requestObj)
        // Do any additional setup after loading the view.
    }
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        circleIndicator.isHidden = false
        circleIndicator.animate()
        print("Started")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        circleIndicator.isHidden = true
        circleIndicator.stop()
        print("Finished")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Failure")
    }
}
