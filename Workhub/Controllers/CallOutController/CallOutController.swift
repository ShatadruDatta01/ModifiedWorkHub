//
//  CallOutController.swift
//  Workhub
//
//  Created by Shatadru Datta on 12/9/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class CallOutController: BaseViewController {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var viewBG: UIView!
    
    var didSubmitButton:((_ text: String) -> ())?
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, alertMessage: String, didSubmit: @escaping ((_ text: String) -> ()), didFinish: @escaping (() -> ())) {
        
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "CallOutController") as! CallOutController
        commentPopVC.didSubmitButton = didSubmit
        commentPopVC.didRemove = didFinish
        commentPopVC.presentAddOrClearPopUpWith(sourceController: sourceViewController, message: alertMessage)
    }
    
    func presentAddOrClearPopUpWith(sourceController: UIViewController, message: String) {
        self.view.frame = sourceController.view.bounds
        sourceController.view.addSubview(self.view)
        sourceController.addChildViewController(self)
        sourceController.view.bringSubview(toFront: self.view)
        presentAnimationToView(message: message)
    }
    
    // MARK: - Animation
    func presentAnimationToView(message: String) {
        viewBG.alpha = 0.0
        self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25) {
            self.viewBG.alpha = 0.3
            self.viewPopUp.transform = .identity
        }
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.dismissAnimate()
            }
        } else {
            // Fallback on earlier versions
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ToastController.dismissAnimate), userInfo: nil, repeats: false)
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
