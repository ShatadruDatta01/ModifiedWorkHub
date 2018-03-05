//
//  APIModel.swift
//  SocioAdvocacy
//
//  Created by sachitananda sahu  on 28/08/17.
//  Copyright © 2017 Sachita. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIModel: NSObject {
    
}

struct API_MODELS_METHODS {
    
    static func login(queue: DispatchQueue? = nil, email: String, password: String, network: String,
                            completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.LOGIN
        let completeUrl = AppWebservices.baseUrl + subpath + appServiceVariables.accessToken + AppConstantValues.companyAccessToken
        var parameters = [String: String]()
        if network == "Manual" {
            parameters = ["email": email,"password": password, "isCompany": "no", "network": ""]
        } else {
            parameters = ["email": email,"password": password, "isCompany": "no", "network": network]
        }
        
        if Reachability.isConnectedToNetwork(){
            HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
                if isSuccess {
                    let swiftyJsonVar   = JSON(response)
                    print(swiftyJsonVar)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        } else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            }
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
    
    
    
    static func register(queue: DispatchQueue? = nil, name: String, email: String, mobile: String, password: String, network: String,
                      completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.REGISTER
        let completeUrl = AppWebservices.baseUrl + subpath + appServiceVariables.accessToken + AppConstantValues.companyAccessToken
        var parameters = [String: String]()
        if network == "Manual" {
            parameters = ["name": name, "email": email, "mobile": mobile, "password": password, "network": "", "isCompany": "no"]
        } else {
            parameters = ["name": name, "email": email, "mobile": mobile, "password": password, "network": network, "isCompany": "no"]
        }
        
        if Reachability.isConnectedToNetwork(){
            HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
                if isSuccess {
                    let swiftyJsonVar   = JSON(response)
                    print(swiftyJsonVar)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        } else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            }
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }

    
    
    
    /// Token API Call
    ///
    /// - Parameters:
    ///   - queue: queue description
    ///   - completion: completion description
    static func token(queue: DispatchQueue? = nil,
                      completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.TOKEN
        let completeUrl = AppWebservices.baseUrl + subpath
        print(completeUrl)
        let parameters = [String: String]()
        
        if Reachability.isConnectedToNetwork(){
            HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
                if isSuccess {
                    let swiftyJsonVar   = JSON(response)
                    print(swiftyJsonVar)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        } else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            }
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
    }

    
    static func jobFunction(queue: DispatchQueue? = nil, action: String?, jobId: String?,
                      completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.JOB_FUNCTION
        let parameters = ["jobid": jobId, "action": action]
        let completeUrl = AppWebservices.baseUrl + subpath
        
        if Reachability.isConnectedToNetwork(){
            HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
                if isSuccess {
                    let swiftyJsonVar   = JSON(response)
                    print(swiftyJsonVar)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        } else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            }
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
    
    
    /// UserJOBList
    ///
    /// - Parameters:
    ///   - latitude: currentLAT
    ///   - longitude: currentLON
    ///   - pincode: curretPINCODE
    ///   - radius: 1
    ///   - queue: getJobSearch
    ///   - completion: responseDict(JSON)
    static func userJOBList(_ latitude: String?,_ longitude: String?, _ pincode: String?, radius: String? ,queue: DispatchQueue? = nil,
                            completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let createSubPathurl = "latitude=\(String(describing: latitude!))&longitude=\(String(describing: longitude!))&pincode=\(String(describing: pincode!))&radius=\(String(describing: radius!))"
        let subpath =  AppWebservices.JOB_SEARCH
        let completeUrl = AppWebservices.baseUrl + subpath + createSubPathurl
        _ = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.GETManagerWithHeader(completeUrl, completion: { (response, responseString,isSuccess) in
                if isSuccess{
                    let swiftyJsonVar   = JSON(response)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        }else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        }
                    })
                }
            })
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
    
    
    static func getProfile(queue: DispatchQueue? = nil,
                            completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.GET_PROFILE
        let completeUrl = AppWebservices.baseUrl + subpath 
        _ = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.GETManagerWithHeader(completeUrl, completion: { (response, responseString,isSuccess) in
                if isSuccess{
                    let swiftyJsonVar   = JSON(response)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        }else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        }
                    })
                }
            })
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
    }
    
    
    static func updateProfile(queue: DispatchQueue? = nil, email: String?, name: String?, mobile: String?, pic: String?, ext: String?, experience: String?, salExpected: String?, location: String?,
                            completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.UPDATE_PROFILE
        var parameters = ["": ""]
        let val = mobile?.components(separatedBy: "-")
        if val!.count > 1 {
            if val![1] == "" {
                parameters = ["name": name!, "email": email!, "pic": "\(ext!),\(String(describing: pic!))", "experience": experience!, "salExpected": salExpected!, "location": location!]
            } else {
                parameters = ["name": name!, "email": email!, "mobile": mobile!, "pic": "\(ext!),\(String(describing: pic!))", "experience": experience!, "salExpected": salExpected!, "location": location!]
            }
        } else {
            parameters = ["name": name!, "email": email!, "pic": "\(ext!),\(String(describing: pic!))", "experience": experience!, "salExpected": salExpected!, "location": location!]
        }
        
     
        print(parameters)
        let completeUrl = AppWebservices.baseUrl + subpath
        
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
                if isSuccess {
                    let swiftyJsonVar   = JSON(response)
                    print(swiftyJsonVar)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        } else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            }
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
    }
    
    static func getJobList(queue: DispatchQueue? = nil, action: String?,
                           completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.USER_JOB_LIST
        let completeUrl = AppWebservices.baseUrl + subpath + action!
        print(completeUrl)
        _ = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
        
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.GETManagerWithHeader(completeUrl, completion: { (response, responseString,isSuccess) in
                if isSuccess{
                    let swiftyJsonVar   = JSON(response)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        }else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            })
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
    
    
    
    static func resumeUpload(queue: DispatchQueue? = nil, resume: String?, ext: String?,
                              completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.RESUME_UPLOAD
        let parameters = ["resume": "\(ext!),\(resume!)"]
        let completeUrl = AppWebservices.baseUrl + subpath
        
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
                if isSuccess {
                    let swiftyJsonVar   = JSON(response)
                    print(swiftyJsonVar)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        } else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            }
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
    
    
    static func getOTP(queue: DispatchQueue? = nil, entity: String?, val: String?,
                           completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let action = "entity=email&val=\(String(describing: val!))&type=cpass"
        let subpath =  AppWebservices.SEND_OTP
        let completeUrl = AppWebservices.baseUrl + subpath + action
        print(completeUrl)
        _ = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
        
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.GETManagerWithHeader(completeUrl, completion: { (response, responseString,isSuccess) in
                if isSuccess{
                    let swiftyJsonVar   = JSON(response)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        }else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            })
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
    
    
    static func verifyOTP(queue: DispatchQueue? = nil, entity: String?, val: String?, otp: String?,
                       completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let action = "entity=email&val=\(String(describing: val!))&otp=\(String(describing: otp!))"
        let subpath =  AppWebservices.VERIFY_OTP
        let completeUrl = AppWebservices.baseUrl + subpath + action
        print(completeUrl)
        _ = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
        
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.GETManagerWithHeader(completeUrl, completion: { (response, responseString,isSuccess) in
                if isSuccess{
                    let swiftyJsonVar   = JSON(response)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        }else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            })
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
    
    
    static func changePassword(queue: DispatchQueue? = nil, entity: String?, val: String?, otp: String?, password: String?, completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        let subpath =  AppWebservices.CHANGE_PASSWORD
        let parameters = ["entity": entity, "val": val, "otp": otp, "password": password]
        let completeUrl = AppWebservices.baseUrl + subpath
        
        
        
        if Reachability.isConnectedToNetwork() {
            HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
                if isSuccess {
                    let swiftyJsonVar   = JSON(response)
                    print(swiftyJsonVar)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["status"].bool! {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],true)
                        } else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["result": swiftyJsonVar["result"]],false)
                        }
                    })
                }
            }
        } else {
            InternetCheckingController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Please Check Internet Connection !", didSubmit: { (text) in
                debugPrint("No Code")
            }, didFinish: {
                debugPrint("No Code")
            })
        }
        
    }
}
