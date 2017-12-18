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

struct API_MODELS_METHODS{
    
    
    static func login(queue: DispatchQueue? = nil, email: String, password: String, network: String,
                            completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.LOGIN
        let completeUrl = AppWebservices.baseUrl + subpath + appServiceVariables.accessToken + AppConstantValues.companyAccessToken
        var parameters = [String: String]()
        if network == "Manual" {
            parameters = ["email": email,"password": password, "isCompany": "no", "network": ""]
        } else {
            parameters = ["email": email,"password": password, "isCompany": "no", "network": network]
        }
        
        
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
    }
    
    
    static func register(queue: DispatchQueue? = nil, name: String, email: String, mobile: String, password: String, network: String,
                      completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.REGISTER
        let completeUrl = AppWebservices.baseUrl + subpath + appServiceVariables.accessToken + AppConstantValues.companyAccessToken
        var parameters = [String: String]()
        if network == "Manual" {
            parameters = ["name": name, "email": email, "mobile": mobile, "password": password, "network": "", "isCompany": "no"]
        } else {
            parameters = ["name": name, "email": email, "mobile": mobile, "password": password, "network": network, "isCompany": "no"]
        }
        
        
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
    }

    
    
    
    /// Token API Call
    ///
    /// - Parameters:
    ///   - queue: queue description
    ///   - completion: completion description
    static func token(queue: DispatchQueue? = nil,
                      completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.TOKEN
        let completeUrl = AppWebservices.baseUrl + subpath
        print(completeUrl)
        let parameters = [String: String]()
        
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
    }

    
    
    
    static func jobFunction(queue: DispatchQueue? = nil, action: String?, jobId: String?,
                      completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.JOB_FUNCTION
        let parameters = ["jobid": jobId, "action": action]
        let completeUrl = AppWebservices.baseUrl + subpath
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
        
        // https://api.socioadvocacy.com/user/uid?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0&cid=52ad0375&email=sachitanandas@sociosquares.com&role=general
        let createSubPathurl = "latitude=\(String(describing: latitude!))&longitude=\(String(describing: longitude!))&pincode=\(String(describing: pincode!))&radius=\(String(describing: radius!))"
        let subpath =  AppWebservices.JOB_SEARCH
        let completeUrl = AppWebservices.baseUrl + subpath + createSubPathurl
        //let completeUrl = AppWebservices.baseUrl + subpath + createSubPathurl
        let connectivity = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
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
    }
    
    
    static func getProfile(queue: DispatchQueue? = nil,
                            completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // https://api.socioadvocacy.com/user/uid?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0&cid=52ad0375&email=sachitanandas@sociosquares.com&role=general
        let subpath =  AppWebservices.GET_PROFILE
        let completeUrl = AppWebservices.baseUrl + subpath 
        let connectivity = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
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
    }
    
    
    static func updateProfile(queue: DispatchQueue? = nil, email: String?, name: String?, mobile: String?, pic: String?, experience: String?, salExpected: String?, location: String?,
                            completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.UPDATE_PROFILE
        let parameters = ["name": name, "email": email, "mobile": mobile, "pic": pic, "experience": experience, "salExpected": salExpected, "location": location]
        let completeUrl = AppWebservices.baseUrl + subpath
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
    }
    
    
    
    static func getJobList(queue: DispatchQueue? = nil, action: String?,
                           completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // https://api.socioadvocacy.com/user/uid?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0&cid=52ad0375&email=sachitanandas@sociosquares.com&role=general
        let subpath =  AppWebservices.USER_JOB_LIST
        let completeUrl = AppWebservices.baseUrl + subpath + action!
        print(completeUrl)
        let connectivity = NetworkConnectivity.networkConnectionType("needsConnection")
        print(completeUrl)
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
    }
    
    
    
    static func resumeUpload(queue: DispatchQueue? = nil, resume: String?,
                              completion: @escaping (_ responseDict:[String: JSON]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.RESUME_UPLOAD
        let parameters = ["resume": resume]
        let completeUrl = AppWebservices.baseUrl + subpath
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
    }

    
}
