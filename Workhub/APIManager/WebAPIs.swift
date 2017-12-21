//
//  WebAPIs.swift
//  SocioAdvocacy
//
//  Created by sachitananda sahu  on 28/08/17.
//  Copyright © 2017 Sachita. All rights reserved.
//

import Foundation

/// App base urls and Urls usede in the app.
struct AppWebservices {
    
    static let baseUrl = "http://apils.workhubapp.com/"
    
    static let GET_APPCONFIG_FILES = "appconfig.json?"
    static let MOBILE_LOGIN = "mobile/login?"
    static let USER_UID     = "user/uid?"
    
    static let REGISTER = "register?"
    static let LOGIN = "login?"
    static let JOB_SEARCH = "job/search?"
    static let TOKEN = "token?"
    static let JOB_FUNCTION = "job/operate?"
    static let GET_PROFILE = "user/profile?"
    static let UPDATE_PROFILE = "user/profile?"
    static let USER_JOB_LIST = "job/listing?filter="
    static let RESUME_UPLOAD = "resume/upload?"
    static let SEND_OTP = "sendotp?"
    static let VERIFY_OTP = "verifyotp?"
    static let CHANGE_PASSWORD = "user/changepassword?"
    
}

struct appServiceVariables {
    static let accessToken = "access_token="
}
