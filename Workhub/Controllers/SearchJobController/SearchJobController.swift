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

    @IBOutlet var widthGOconstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDetailsContent: UILabel!
    @IBOutlet weak var lblListContent: UILabel!
    @IBOutlet weak var imgListContent: UIImageView!
    @IBOutlet weak var imgMapContent: UIImageView!
    @IBOutlet weak var mapListJob: MKMapView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var txtSearchJob: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jobSearchAPICall()
        self.widthGOconstraint.constant = 0
        self.viewList.isHidden = true
        self.lblListContent.text = "List View"
        self.imgListContent.isHidden = true
        self.imgMapContent.isHidden = false
        self.txtSearchJob.layer.borderWidth = 1.0
        self.txtSearchJob.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.headerViewController?.isBack = false
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "Dash"), for: UIControlState.normal)
    }
    
    /// Go
    ///
    /// - Parameter sender: Button
    @IBAction func actionGO(_ sender: UIButton) {
        
    }
    
    
    /// ListShow
    ///
    /// - Parameter sender: Button
    @IBAction func actionList(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.viewList.isHidden = true
            self.lblListContent.text = "Map View"
            self.imgListContent.isHidden = true
            self.imgMapContent.isHidden = false
        } else {
            sender.isSelected = true
            self.viewList.isHidden = false
            self.lblListContent.text = "List View"
            self.imgListContent.isHidden = false
            self.imgMapContent.isHidden = true
        }
    }
}


// MARK: - UITextFieldDelegate
extension SearchJobController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSearchJob.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            self.widthGOconstraint.constant = 34
        } else {
            self.widthGOconstraint.constant = 0
        }
        return true
    }
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchJobController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchJobCell", for: indexPath) as! SearchJobCell
        cell.datasource = "" as AnyObject
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}



// MARK: - SearchJobAPICall
extension SearchJobController {
    
    func jobSearchAPICall() {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getJobSearch"), attributes: .concurrent)
        API_MODELS_METHODS.searchJOB("19.16803810", "72.84864010", "400001", radius:"1", queue: concurrentQueue) { (responseDict, isSuccess) in
            
        }
    }
}


