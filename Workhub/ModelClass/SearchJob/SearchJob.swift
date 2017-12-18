//
//  SearchJob.swift
//  Workhub
//
//  Created by Administrator on 07/12/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit

class SearchJob: NSObject {

    var jobID: String?
    var jobDetail: String?
    var category: String?
    var state: String?
    var country: String?
    var salary_per_hour: String?
    var posted_on: String?
    var longitude: String?
    var salary_per_month: String?
    var type: String?
    var company_name: String?
    var salary_range: String?
    var latitude: String?
    var category_image: String?
    var city: String?
    var role: String?
    var currency: String?
    var shift: String?
    var company_detail: String?
    var save: Int?
    var like: Int?
    var apply: Int?
    var view: Int?
    init(withDictionary dict:[String: AnyObject]) {
        self.jobID = (dict["id"]! as! String)
        if let jobDetail = dict["detail"] {
            self.jobDetail = jobDetail as? String
        }
        if let category = dict["category"] {
            self.category = category as? String
        }
        if let state = dict["state"] {
            self.state = state as? String
        }
        if let country = dict["country"] {
            self.country = country as? String
        }
        if let salary_per_hour = dict["salary_per_hour"] {
            self.salary_per_hour = salary_per_hour as? String
        }
        if let posted_on = dict["posted_on"] {
            self.posted_on = posted_on as? String
        }
        self.longitude = (dict["longitude"]! as! String)
        if let salary_per_month = dict["salary_per_month"] {
            self.salary_per_month = salary_per_month as? String
        }
        
        if let type = dict["type"] {
            self.type = type as? String
        }
        if let company_name = dict["company_name"] {
            self.company_name = company_name as? String
        }
        if let salary_range = dict["salary_range"] {
            self.salary_range = salary_range as? String
        }
        
        self.latitude = (dict["latitude"]! as! String)
        
        if let category_image = dict["category_image"] {
            self.category_image = category_image as? String
        }
        if let city = dict["city"] {
            self.city = city as? String
        }
        if let role = dict["role"] {
            self.role = role as? String
        }
        if let currency = dict["currency"] {
            self.currency = currency as? String
        }
        if let shift = dict["shift"] {
            self.shift = shift as? String
        }
        
        if let company_detail = dict["company_detail"] {
            self.company_detail = company_detail as? String
        }
        if let save = dict["save"] {
            self.save = save as? Int
        }
        if let like = dict["like"] {
            self.like = like as? Int
        }
        if let apply = dict["apply"] {
            self.apply = apply as? Int
        }
        if let view = dict["view"] {
            self.view = view as? Int
        }
        
        
    }

}
