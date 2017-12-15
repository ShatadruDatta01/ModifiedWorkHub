//
//  HTTPManagerAPI.swift
//  SocioAdvocacy/Users/sachita/Desktop/Projects/Swift_Remake/SocioAdvocacy/SocioAdvocacy
//
//  Created by sachitananda sahu  on 24/08/17.
//  Copyright © 2017 Sachita. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
/// The structure contains app seecific values.
struct AppConstantValues {
    
    static let CONSUMER_KEY_NONCE = "oauth_consumer_key"
    static let KEY_OAUTH_NONCE_TEMP = "oauth_nonce";
    static let KEY_OAUTH_SIGNATURE_METHOD_TEMP = "oauth_signature_method";
    static let KEY_OAUTH_TOKEN_TEMP = "oauth_token";
    static let KEY_OAUTH_TIMESTAMP_TEMP = "oauth_timestamp";
    static let KEY_OAUTH_VERSION_TEMP = "oauth_version";
    static let KEY_OAUTH_SIGNATURE_TEMP = "oauth_signature";
    static let KEY_AUTHORIZATION_OAUTH_TEMP = "Authorization: OAuth";
    
    static let VALUE_OAUTH_SIGNATURE_METHOD_TEMP = "HMAC-SHA1";
    static let VALUE_OAUTH_VERSION_TEMP = "1.0";
    
    static var latitide = ""
    static var longitude = ""
    static var zipcode = ""
    static var companyAccessToken = "" //"6d2003577e300fccfd0e4c4be7d7a59366f94bb0";
    static let iTunesAppUrl = "https://itunes.apple.com/us/app/brand-champs/id1037140094?ls=1&mt=8"

}


/// Enum to describe the Connection Type
///
/// - NONETWORK//nonetwork:  No Network
/// - MOBILE3GNETWORK//mobile3GNETWORK: mobile3GNETWORK
/// - WIFINETWORK//wifinetwork: wifinetwork
public enum ConnectionType {
    case NONETWORK//nonetwork
    case MOBILE3GNETWORK//mobile3GNETWORK
    case WIFINETWORK//wifinetwork
}

/// Check for Network Connectivity
struct NetworkConnectivity {
    
    /// Checks for Network Connectivity
    ///
    /// - Parameter hostname: String Parameter
    /// - Returns: Returns Connection Type Enun
    static func networkConnectionType(_ hostname: NSString) ->
        ConnectionType {
            let reachabilityRef =
                SCNetworkReachabilityCreateWithName(nil,hostname.utf8String!)
            var flags: SCNetworkReachabilityFlags =
                SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachabilityRef!, &flags)
            let reachable: Bool = (flags.rawValue &
                SCNetworkReachabilityFlags.reachable.rawValue) != 0
            let needsConnection: Bool = (flags.rawValue &
                SCNetworkReachabilityFlags.connectionRequired.rawValue) != 0
            if reachable && !needsConnection {
                // what type of connection is available
                let isCellularConnection = (flags.rawValue &
                    SCNetworkReachabilityFlags.isWWAN.rawValue) != 0
                if isCellularConnection {
                    // cellular connection available
                    return ConnectionType.MOBILE3GNETWORK
                } else {
                    // wifi connection available
                    return ConnectionType.WIFINETWORK
                }
            }
            return ConnectionType.NONETWORK // no connection at all
    }
}
///JSON to String converter struct
struct convertJsonToString {
    
    /// Convert the Json parameters into String
    ///
    /// - Parameter json: Json
    /// - Returns: Returns a string Value
    static func jsonToString(_ json: AnyObject) -> String{
        
        var responseString = ""
        
        if let json = try? JSONSerialization.data(withJSONObject: json, options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                responseString = content
            }
        }
        return responseString
    }
}

///Create a format of multipart
struct MultiPartHelper{
    
    
    /// Create a format of multipart with image data
    ///
    /// - Parameters:
    ///   - parameters: PARAMETERS OF WEBSERVICE
    ///   - filePathKey: file Path Key
    ///   - imageData: imageDataKey as NSData
    ///   - boundary: boundary as String
    /// - Returns: return as NSData
    static func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageData: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        let filename = "\(filePathKey!).jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        return body
    }
}


/// The structure holds the alamofire login for both Get and post calls of the app
struct HTTPMANAGERAPI_ALAMOFIRE {
    
    public typealias completionHandler = ((_ response: AnyObject,_ responseString: String,_ isSuccess:Bool) -> ())
    
    
    /// GET MANAGER
    ///
    /// - Parameters:
    ///   - subPath: APPENDED SUBPATH OF BASE URL
    ///   - queue: BACKGROUND QUEUE (OPTIONAL)
    ///   - parameters: PARAMETERS OF WEBSERVICE
    ///   - completion:  COMPLETION BLOCK
    static func GETManagerWithHeader(_ subPath:String,
                                     queue: DispatchQueue? = nil,
                                     parameters:[String: AnyObject]? = nil,
                                     completion: @escaping (_ response: AnyObject,_ responseString:String,_ isSuccess:Bool) -> Void){
        
        _ = NetworkConnectivity.networkConnectionType("needsConnection")
        //queue?.sync {
            
            //let baseUrlString = "https://apils.socioadvocacy.com/company/feed/2017-08-22/2017-08-23?access_token=0d63c9f79807211b736651ed943661370f838eb1&cid=365834c2&uid=064bf2c6"
            print(AppConstantValues.companyAccessToken)
            let baseUrlString = subPath
            var header = CREATE_HEADER.createHeaderForTheUrl(baseUrl: baseUrlString, mType: "GET", parameterDict: [:], companyCid: "", accessToken: AppConstantValues.companyAccessToken)
            
            header = header.replacingOccurrences(of: "%27", with: "'")
            header = header.replacingOccurrences(of: "%0A", with: "")
            header = header.replacingOccurrences(of: "%3D", with: "")
            
            header = header.substring(to: header.index(before: header.endIndex)) + "%3D"
        
            print(header)
            
            if let url = URL(string: baseUrlString) {
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = HTTPMethod.get.rawValue
                
                urlRequest.addValue(header, forHTTPHeaderField: "X-WHOAuth")
//                urlRequest.addValue(header, forHTTPHeaderField: "X-SAOAuth")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                urlRequest.addValue("Bearer"+" \(AppConstantValues.companyAccessToken)", forHTTPHeaderField: "Authorization")
//                urlRequest.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
//                urlRequest.addValue("ios"+"-v"+"1.0", forHTTPHeaderField: "User-Agent")
                
                
                Alamofire.request(urlRequest)
                    .responseJSON { response in
                        if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                            completion(json as AnyObject,convertJsonToString.jsonToString(json as AnyObject),true)
                        }
                }
            }
        //}
    }
    
    
    static func POSTManager(_ subPath:String,
                            queue: DispatchQueue? = nil,
                            parameters:[String: AnyObject]?,
                            completion: @escaping (_ response: AnyObject,_ responseString:String,_ isSuccess:Bool) -> Void){
        _ = NetworkConnectivity.networkConnectionType("needsConnection")
        queue?.sync {
            
            print(parameters!)
            let paramDict = parameters //["email":"demo@acu.com","role":"general"]
            
            let baseUrlString = subPath
            var header = CREATE_HEADER.createHeaderForTheUrl(baseUrl: baseUrlString, mType: "POST", parameterDict: paramDict! as! [String : String], companyCid: "", accessToken: AppConstantValues.companyAccessToken)
            
            header = header.replacingOccurrences(of: "%27", with: "'")
            header = header.replacingOccurrences(of: "%0A", with: "")
            header = header.replacingOccurrences(of: "%3D", with: "")
            
            header = header.substring(to: header.index(before: header.endIndex)) + "%3D"
            
            print(header)
            
            var headersDict: HTTPHeaders = HTTPHeaders()
            headersDict["X-WHOAuth"] = header
            headersDict["Authorization"] = "Bearer"+" \(AppConstantValues.companyAccessToken)"
            headersDict["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
            headersDict["User-Agent"] = "ios"+"-v"+"1.0"
            print(headersDict)
            
            Alamofire.request(baseUrlString, method: .post, parameters: paramDict, encoding: URLEncoding.default, headers: headersDict)
                .responseJSON { response in
                    if let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) {
                        completion(json as AnyObject,convertJsonToString.jsonToString(json as AnyObject),true)
                    }
            }
        }
    }
    
    
    /// GET MANAGER
    ///
    /// - Parameters:
    ///   - subPath: APPENDED SUBPATH OF BASE URL
    ///   - queue: BACKGROUND QUEUE (OPTIONAL)
    ///   - parameters: PARAMETERS OF WEBSERVICE
    ///   - completion:  COMPLETION BLOCK
    static func GETManager(_ subPath:String,
                           queue: DispatchQueue? = nil,
                           parameters:[String: AnyObject]? = nil,
                           completion: @escaping (_ response: AnyObject,_ responseString:String,_ isSuccess:Bool) -> Void){
        
        let connectivity = NetworkConnectivity.networkConnectionType("needsConnection")
        if connectivity != ConnectionType.NONETWORK  {
            //Assigning the Queue
            queue?.async {
                
                let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
                var dataTask: URLSessionDataTask?
                
                if dataTask != nil {
                    dataTask?.cancel()
                }
                let urlToRequest = AppWebservices.baseUrl + subPath
                let url = URL(string: urlToRequest)
                dataTask = defaultSession.dataTask(with: url!, completionHandler: {
                    data, response, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            
                            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                                completion(json as AnyObject,convertJsonToString.jsonToString(json as AnyObject),true)
                            }
                        }
                        else{
                            completion("" as AnyObject,"Parsing Error",false)
                        }
                    }else {
                    }
                })
                dataTask?.resume()
            }
        }else {
            completion("" as AnyObject,ResponseMessageHandler.NOCONNECTIVITY,false)
        }
        
    }

}


/// The structure holds the creation of header for all services.
/// It is the Important part of the app. Unless a correct header is created the APIs won't work
/// The Header generated by the method can be verified by the Base url generated and base Url generated from the Server end.
struct CREATE_HEADER {
    
    /// The Method creates a unique header for every API fired by taking current Url, parameters passed(if available), company Cid(if available) and access token
    /// of company which is mentioned Struct AppConstant Values.
    /// - Parameters:
    ///   - baseUrl: The Url passed for every API
    ///   - mType: The method type i.e POST, GET and DELETE
    ///   - parameterDict: The parameters passed if available
    ///   - companyCid: Company CID which we get from mobile/login for SocioAdvocacy or else it is hard coded in AppConstant Value
    ///   - accessToken: The company access token 
    /// - Returns: Returns the complete header string formed by combination of above parametrs
    static func createHeaderForTheUrl(baseUrl: String, mType: String, parameterDict: [String: String], companyCid:String, accessToken: String) -> String {
        
        var baseString = self.buidBaseString(url:baseUrl, mType: mType, keyValuePairs: parameterDict)
        
        baseString = baseString.replacingOccurrences(of: "%2C", with: "%252C")
        baseString = baseString.replacingOccurrences(of: "%40", with: "%2540")
        baseString = baseString.replacingOccurrences(of: "%252520", with: "%2520")
        let instanceOfCustomObject: Helper = Helper()
        let compositeKey =  instanceOfCustomObject.buidCompositeKey("", aToken: accessToken)!
        let compositeSignature = instanceOfCustomObject.computeSignature(baseString, key: compositeKey)!
        
        let currentdate =  instanceOfCustomObject.generateCurrentTime()!
       // let header = "Authorization: OAuth \(AppConstantValues.KEY_OAUTH_NONCE_TEMP)=\(instanceOfCustomObject.stringConverBase64(currentdate)!),\(AppConstantValues.KEY_OAUTH_SIGNATURE_METHOD_TEMP)=\(AppConstantValues.VALUE_OAUTH_SIGNATURE_METHOD_TEMP),\(AppConstantValues.KEY_OAUTH_TOKEN_TEMP)=\(AppConstantValues.companyAccessToken), \(AppConstantValues.KEY_OAUTH_TIMESTAMP_TEMP)=\(currentdate), \(AppConstantValues.KEY_OAUTH_VERSION_TEMP)=\(AppConstantValues.VALUE_OAUTH_VERSION_TEMP),\(AppConstantValues.KEY_OAUTH_SIGNATURE_TEMP)=\(instanceOfCustomObject.stringEncode(compositeSignature)!)"
       
        let header = "\(AppConstantValues.CONSUMER_KEY_NONCE)=78044b02,\(AppConstantValues.KEY_OAUTH_NONCE_TEMP)=\(instanceOfCustomObject.stringConverBase64(currentdate)!),\(AppConstantValues.KEY_OAUTH_SIGNATURE_METHOD_TEMP)=\(AppConstantValues.VALUE_OAUTH_SIGNATURE_METHOD_TEMP),\(AppConstantValues.KEY_OAUTH_TOKEN_TEMP)=\(AppConstantValues.companyAccessToken), \(AppConstantValues.KEY_OAUTH_TIMESTAMP_TEMP)=\(currentdate), \(AppConstantValues.KEY_OAUTH_VERSION_TEMP)=\(AppConstantValues.VALUE_OAUTH_VERSION_TEMP),\(AppConstantValues.KEY_OAUTH_SIGNATURE_TEMP)=\(instanceOfCustomObject.stringEncode(compositeSignature)!)"

        return header
    }
    
    
    
    /// The method encodes a string with base64
    ///
    /// - Parameter passedString: the string to be encoded
    /// - Returns: The encoded returned string.
    static func stringEncode(passedString : String) ->  String {
        
        var escapedString = passedString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        escapedString = escapedString?.replacingOccurrences(of: ":", with: "%3A")
        escapedString = escapedString?.replacingOccurrences(of: "=", with: "%3D")
        escapedString = escapedString?.replacingOccurrences(of: "&", with: "%26")
        
        return escapedString!
    }
    
    /// The methods creates a base string for the header part
    ///
    /// - Parameters:
    ///   - url: The Url is passed.
    ///   - mType: The url type is passed i.e POST, GET and DELETE
    ///   - keyValuePairs: The key value dictionary is passed.
    /// - Returns: Base url string is returned.
    static func buidBaseString(url : String, mType: String, keyValuePairs: [String : String]) -> String {
        var createkeyValueUrl = "&"
        
        if mType == "GET" || mType == "DELETE" {
            createkeyValueUrl = "?"
        } else {
            createkeyValueUrl = "&"
        }
        let keys  = keyValuePairs.keys
        let sKeys = keys.sorted{$0.caseInsensitiveCompare($1) == .orderedAscending}
        // serviceName = "\(serviceName), \(serviceSwity["service_name"].stringValue)"
        
        
        for  (_,object) in (sKeys.enumerated()) {
            createkeyValueUrl = createkeyValueUrl.appending("\(object)=\(stringEncode(passedString: keyValuePairs[object]!))&")
        }
        let tempCreateValueUrl = createkeyValueUrl.substring(to: createkeyValueUrl.index(before: createkeyValueUrl.endIndex))
        return mType + "&" + stringEncode(passedString: url) + stringEncode(passedString: tempCreateValueUrl)
        
    }
    
}
