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
        self.jobDetail = (dict["detail"]! as! String)
        self.category = (dict["category"]! as! String)
        self.state = (dict["state"]! as! String)
        self.country = (dict["country"]! as! String)
        self.salary_per_hour = (dict["salary_per_hour"]! as! String)
        self.posted_on = (dict["posted_on"]! as! String)
        self.longitude = (dict["longitude"]! as! String)
        if let salary_per_month = dict["salary_per_month"] {
            self.salary_per_month = salary_per_month as? String
        }
        //self.salary_per_month = (dict["salary_per_month"]! as! String)
        self.type = (dict["type"]! as! String)
        self.company_name = (dict["company_name"]! as! String)
        if let salary_range = dict["salary_range"] {
            self.salary_range = salary_range as? String
        }
        
        self.latitude = (dict["latitude"]! as! String)
        self.category_image = (dict["category_image"]! as! String)
        self.city = (dict["city"]! as! String)
        self.role = (dict["role"]! as! String)
        self.currency = (dict["currency"]! as! String)
        self.shift = (dict["shift"]! as! String)
        self.company_detail = (dict["company_detail"]! as! String)
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
