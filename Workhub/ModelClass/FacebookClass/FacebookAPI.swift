//
//  FacebookAPI.swift
//  Workhub
//

import Foundation
import FacebookLogin
import FBSDKLoginKit

/// The Structure Contains Facebook API
struct FacebookLoginAPI {
    
    /// The Method is used to Intialise the Facebook API for verifing the User's credentials for Login and Registration in
    /// the app.
    /// - Parameter completion: The completion handler returns the Faceboook Response received by the API
    static func initiateFacebookLogin(completion: @escaping (_ facebookResponse: Any,_ isSucess:Bool,_ error:String) -> Void) {
        
        //self.removeFacebookSession()
        let facebookLoginManager = FBSDKLoginManager()
        
        if UIApplication.shared.canOpenURL(URL(string: "fbapi://")!) {
            facebookLoginManager.loginBehavior =  .systemAccount
        } else {
            facebookLoginManager.loginBehavior =  .web
        }
        
        
        facebookLoginManager.logIn(withReadPermissions: ["email","user_friends","public_profile"], from: nil, handler:{(result, error) -> Void in
            if (error != nil) {
                completion("",false,ResponseFacebookHandler.DENY)
                print(error ?? "")
                self.removeFacebookSession()
                
            } else if (result?.isCancelled)! {
                completion("",false,ResponseFacebookHandler.CANCELED)
                self.removeFacebookSession()
            } else {
                //Success
                if (result?.grantedPermissions.contains("email"))! || (result?.grantedPermissions.contains("public_profile"))! {
                    if FBSDKAccessToken.current() != nil {
                        
                        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,first_name,last_name,gender"])
                        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                            
                            if ((error) != nil) {
                                completion("",false,"denied from Facebook")
                                self.removeFacebookSession()
                            } else {
                                //Handle Profile Photo URL String
                                let value = result as! [String:AnyObject]
                                
                                completion(value,true,ResponseFacebookHandler.SUCCESS)
                            }
                        })
                    }
                } else {
                    completion("",false,"No granted Permissions found")
                }
            }
        })
    }
    
    /// The method is used for destroying the Facebook Session
    static func removeFacebookSession() {
        //Remove FB Data
        FBSDKAccessToken.setCurrent(nil)
    }
    
    /// The method is used for logout from Facebook
    static func logOutFromFacebook() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()        
    }
    
    /// The method is used to receive the Facebook Friends list. 
    static func getFacebookFriendsList (completion: @escaping (_ facebookResponse: Any,_ isSucess:Bool,_ error:String) -> Void) {
        
        if FBSDKAccessToken.current() != nil {
            
           let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,first_name,last_name,gender,friends{id,name,picture}"])
            
            //me/friends?fields=email,picture,friends{id,name,picture}

            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil) {
                    completion("",false,"denied from Facebook")
                } else {
                    //Handle Profile Photo URL String
                    let value = result as! [String:AnyObject]
                    completion(value,true,ResponseFacebookHandler.SUCCESS)
                }
            })
        }
        
    }
    
    /// The Method is used to Intialise the Facebook API for verifing the User's credentials for fetching the Facebook Friends List.
    /// the app.
    /// - Parameter completion: The completion handler returns the Faceboook Response received by the API
    static func initiateFacebookFriendsList(completion: @escaping (_ facebookResponse: Any,_ isSucess:Bool,_ error:String) -> Void) {
        
        //self.removeFacebookSession()
        let facebookLoginManager = FBSDKLoginManager()
        
        
        facebookLoginManager.loginBehavior =  .web
        
        
        facebookLoginManager.logIn(withReadPermissions: ["email","user_friends","public_profile"], from: nil, handler:{(result, error) -> Void in
            if (error != nil) {
                completion("",false,ResponseFacebookHandler.DENY)
                print(error ?? "")
                self.removeFacebookSession()
                
            } else if (result?.isCancelled)! {
                completion("",false,ResponseFacebookHandler.CANCELED)
                self.removeFacebookSession()
            } else {
                //Success
                if (result?.grantedPermissions.contains("email"))! || (result?.grantedPermissions.contains("public_profile"))! {
                    if FBSDKAccessToken.current() != nil {
                        
                      let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,first_name,last_name,gender,friends{id,name,picture}"])
                        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                            
                            if ((error) != nil) {
                                completion("",false,"denied from Facebook")
                                self.removeFacebookSession()

                            } else {
                                //Handle Profile Photo URL String
                                let value = result as! [String:AnyObject]
                                completion(value,true,ResponseFacebookHandler.SUCCESS)
                            }
                        })
                    }
                } else {
                    completion("",false,"No granted Permissions found")
                }
            }
        })
    }
}
