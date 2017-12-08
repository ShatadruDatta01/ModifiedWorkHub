//
//  ToastController.swift
//  GetMoreSports
//
//  Created by redapple043 on 30/04/17.
//  Copyright © 2017 redapple043. All rights reserved.
//

import UIKit

class CountryCodeController: BaseViewController {

    var isSearch = false
    var arrCountryCode = [AnyObject]()
    var arrSearchCountryCode = [AnyObject]()
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblCountry: UITableView!
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var viewBG: UIView!
    
    var didSubmitButton:((_ countryName: String, _ code: String, _ countryCode: String) -> ())?
    var didRemove:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPopUp.layer.borderWidth = 1.0
        self.viewPopUp.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cross(_ sender: UIButton) {
        self.dismissAnimate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, alertMessage: String, arrValue: [AnyObject], didSubmit: @escaping ((_ countryName: String, _ code: String, _ countryCode: String) -> ()), didFinish: @escaping (() -> ())) {
        
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "CountryCodeController") as! CountryCodeController
        commentPopVC.didSubmitButton = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceController: sourceViewController, message: alertMessage, arrValue: arrValue)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController, message: String, arrValue: [AnyObject]) {
        self.arrCountryCode = arrValue
        self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChildViewController(self)
        sourceController.view.bringSubview(toFront: self.view)
        presentAnimationToView(message: message)
    }
    
    // MARK: - Animation
    func presentAnimationToView(message: String) {
        viewBG.alpha = 0.0
        labelAlert.text = message
        self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25) {
            self.viewBG.alpha = 0.3
            self.viewPopUp.transform = .identity
        }
    }
    
    
    func dismissAnimate() {
        
        if didRemove != nil {
            didRemove!()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0.0
            self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }) { (true) in
            self.view.removeFromSuperview();
            self.removeFromParentViewController()
        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25) {
                self.viewPopUp.transform = IS_IPAD() ? .identity : CGAffineTransform(translationX: 0, y: -(keyboardSize.height / 2))
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.viewPopUp.transform = .identity
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



// MARK: - UITableViewDelegate, UITableViewDatasource
extension CountryCodeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearch {
            return self.arrSearchCountryCode.count
        } else {
            return self.arrCountryCode.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        if self.isSearch {
            cell.datasource = self.arrSearchCountryCode[indexPath.row] as AnyObject
        } else {
            cell.datasource = self.arrCountryCode[indexPath.row] as AnyObject
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let val =  self.isSearch ? self.arrSearchCountryCode[indexPath.row] as AnyObject : self.arrCountryCode[indexPath.row] as AnyObject
        self.didSubmitButton!(String(describing: val["name"]!!), String(describing: val["code"]!!),String(describing: val["dial_code"]!!))
        self.dismissAnimate()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}



// MARK: - UITextFieldDelegate
extension CountryCodeController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSearch.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if newString.characters.count > 0 {
            self.isSearch = true
        } else {
            self.isSearch = false
        }
        self.arrSearchCountryCode = self.arrCountryCode.filter { NSPredicate(format: "(name beginswith[c] %@)", newString).evaluate(with: $0) }
        self.tblCountry.reloadData()
        return true
    }
}
