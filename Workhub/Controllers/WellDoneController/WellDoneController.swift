//
//  WellDoneController.swift
//  Workhub
//
//  Created by Administrator on 06/03/18.
//  Copyright © 2018 Sociosquares. All rights reserved.
//

import UIKit

class WellDoneController: BaseViewController {
    
    @IBOutlet weak var viewPopUp: UIView!

    var didSubmitButton:((_ text: String) -> ())?
    var didRemove:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    internal class func showAddOrClearPopUp(sourceViewController: UIViewController, alertMessage: String, didSubmit: @escaping ((_ text: String) -> ()), didFinish: @escaping (() -> ())) {
        
        let commentPopVC = mainStoryboard.instantiateViewController(withIdentifier: "WellDoneController") as! WellDoneController
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
        
        self.viewPopUp.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        UIView.animate(withDuration: 0.25) {
            
            self.viewPopUp.transform = .identity
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismissAnimate()
    }
    
    func dismissAnimate() {
        
        if didRemove != nil {
            didRemove!()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            
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

    



