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
                            completion: @escaping (_ responseDict:[String: String]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.LOGIN
        let completeUrl = AppWebservices.baseUrl + subpath + appServiceVariables.accessToken + AppConstantValues.companyAccessToken
        var parameters = [String: String]()
        if network == "Manual" {
            parameters = ["email": email,"password": password, "isCompany": "yes"]
        } else {
            parameters = ["email": email,"password": password, "isCompany": "yes", "network": network]
        }
        
        
        HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
            if isSuccess {
                let swiftyJsonVar   = JSON(response)
                DispatchQueue.main.async(execute: {
                    if swiftyJsonVar["result"]["status"].bool! {
                        print(swiftyJsonVar)
                    } else {
                        let swiftyJsonVar   = JSON(response)
                        completion(["errorCode":swiftyJsonVar["result"]["error"]["code"].stringValue,"errorMessage":swiftyJsonVar["result"]["error"]["message"].stringValue],false)
                    }
                })
            }
        }
    }

    
    static func mobileLogin(queue: DispatchQueue? = nil,
                            completion: @escaping (_ responseDict:[String: String]?,_ isSuccess:Bool) -> Void){
        
        // "https://api.socioadvocacy.com/mobile/login?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0"
        let subpath =  AppWebservices.MOBILE_LOGIN
        let completeUrl = AppWebservices.baseUrl + subpath + appServiceVariables.accessToken + AppConstantValues.companyAccessToken
        let parameters = ["email":"demo@acu.com","role":"general"]
        
        HTTPMANAGERAPI_ALAMOFIRE.POSTManager(completeUrl, queue: queue, parameters: parameters as [String : AnyObject]) { (response, responseJson, isSuccess) in
            if isSuccess {
                let swiftyJsonVar   = JSON(response)
                DispatchQueue.main.async(execute: {
                    if swiftyJsonVar["result"]["success"].bool! {
                        if let companyToken = swiftyJsonVar["result"]["data"]["company_token"].string {
                            let companyDecodedToken = GlobalMethods.getCompanyCidAndCompanyAccesstoken(companyToken).accessToken
                            let companyCid = GlobalMethods.getCompanyCidAndCompanyAccesstoken(companyToken).cid
                            
                            debugPrint("the companyDecodedToken \(companyDecodedToken) and companyCid:\(companyCid):")
                            completion(["companyAccessToken":companyDecodedToken,"cid":companyCid],true)

                        }
                    } else {
                        let swiftyJsonVar   = JSON(response)
                        completion(["errorCode":swiftyJsonVar["result"]["error"]["code"].stringValue,"errorMessage":swiftyJsonVar["result"]["error"]["message"].stringValue],false)
                    }
                })
            }
        }
    }
    
    
    static func sendUserUid(_ email: String?,_ cid: String?,queue: DispatchQueue? = nil,
                            completion: @escaping (_ responseDict:[String: String]?,_ isSuccess:Bool) -> Void){
        
        // https://api.socioadvocacy.com/user/uid?access_token=6d2003577e300fccfd0e4c4be7d7a59366f94bb0&cid=52ad0375&email=sachitanandas@sociosquares.com&role=general
        let createSubPathurl = "&cid=\(String(describing: cid!))&email=\(String(describing: email!))&role=general"
        let subpath =  AppWebservices.USER_UID
        let completeUrl = AppWebservices.baseUrl + subpath + appServiceVariables.accessToken + AppConstantValues.companyAccessToken + createSubPathurl
        let connectivity = NetworkConnectivity.networkConnectionType("needsConnection")
        if connectivity != ConnectionType.NONETWORK  {
            HTTPMANAGERAPI_ALAMOFIRE.GETManagerWithHeader(completeUrl, completion: { (response, responseString,isSuccess) in
                if isSuccess{
                    let swiftyJsonVar   = JSON(response)
                    DispatchQueue.main.async(execute: {
                        if swiftyJsonVar["result"]["success"].bool! {
                            completion(["uid":swiftyJsonVar["result"]["data"]["uid"].stringValue],true)
                        }else {
                            let swiftyJsonVar   = JSON(response)
                            completion(["errorCode":swiftyJsonVar["result"]["error"]["code"].stringValue,"errorMessage":swiftyJsonVar["result"]["error"]["message"].stringValue],false)
                        }
                    })
                }
            })
            
        } else {
            completion(["errorCode": "404", "errorMessage":ResponseMessageHandler.NOCONNECTIVITY],false)
        }
    }
}
