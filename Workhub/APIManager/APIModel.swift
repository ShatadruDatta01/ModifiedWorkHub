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
            parameters = ["email": email,"password": password, "isCompany": "yes", "network": ""]
        } else {
            parameters = ["email": email,"password": password, "isCompany": "yes", "network": network]
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

    
    
    
    
    static func searchJOB(_ latitude: String?,_ longitude: String?, _ pincode: String?, radius: String? ,queue: DispatchQueue? = nil,
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
}
