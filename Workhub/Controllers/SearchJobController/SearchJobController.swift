//
//  SearchJobController.swift
//  Workhub
//
//  Created by Shatadru Datta on 11/21/17.
//  Copyright © 2017 Sociosquares. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchJobController: BaseViewController {

    var dictJob = [String: String]()
    var zipCode = ""
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var indexselected = -1
    var arrJob = [AnyObject]()
    var arrSearchJob = [AnyObject]()
    var locationManager = CLLocationManager()
    var annotationView: MKAnnotationView!
    @IBOutlet var widthGOconstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblDetailsContent: UILabel!
    @IBOutlet weak var lblListContent: UILabel!
    @IBOutlet weak var imgListContent: UIImageView!
    @IBOutlet weak var imgMapContent: UIImageView!
    @IBOutlet weak var mapListJob: MKMapView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var txtSearchJob: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearchJob.keyboardType = .numberPad
        AppConstantValues.latitide = "19.16803810" //"41.850033"
        AppConstantValues.longitude = "72.84864010"//"-87.6500523"
        //self.location()
        self.fetchZipCode()
        self.lblDetailsContent.text = "No jobs available in 5 sq miles"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapListJob.showsUserLocation = true
        
        self.widthGOconstraint.constant = 0
        self.viewList.isHidden = true
        self.lblListContent.text = "List View"
        self.imgListContent.isHidden = false
        self.imgMapContent.isHidden = true
        self.txtSearchJob.layer.borderWidth = 1.0
        self.txtSearchJob.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.reloadMenu()
        NavigationHelper.helper.headerViewController?.isBack = false
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "Dash"), for: UIControlState.normal)
        NavigationHelper.helper.headerViewController?.leftButton.addTarget(self, action: #selector(SearchJobController.actionDash), for: UIControlEvents.touchUpInside)
    }
    
    
    
    /// Current Location
    func location() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            AppConstantValues.latitide = String(currentLocation.coordinate.latitude)
            AppConstantValues.longitude = String(currentLocation.coordinate.longitude)
            print(AppConstantValues.latitide, AppConstantValues.longitude)
        }
    }
    

    
    /// Fetch ZipCode
    func fetchZipCode() {
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: Double(AppConstantValues.latitide)!, longitude: Double(AppConstantValues.longitude)!)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary as Any)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
            }
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
            }
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                AppConstantValues.zipcode = zip as String
                print(zip)
                self.userJobListAPICall(zipCode: AppConstantValues.zipcode)
            }
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
        })
        
        

    }
    
    
    /// Dashboard Action
    func actionDash() {
        NavigationHelper.helper.reloadMenu()
    }
    
    /// Go
    ///
    /// - Parameter sender: Button
    @IBAction func actionGO(_ sender: UIButton) {
        self.txtSearchJob.resignFirstResponder()
        self.userJobListAPICall(zipCode: self.zipCode)
    }
    
    
    /// ListShow
    ///
    /// - Parameter sender: Button
    @IBAction func actionList(_ sender: UIButton) {
//        if sender.isSelected {
//            sender.isSelected = false
//            self.viewList.isHidden = true
//            self.lblListContent.text = "List View"
//            self.imgListContent.isHidden = false
//            self.imgMapContent.isHidden = true
//        } else {
//            sender.isSelected = true
//            self.viewList.isHidden = false
//            self.lblListContent.text = "Map View"
//            self.imgListContent.isHidden = true
//            self.imgMapContent.isHidden = false
//        }
        
        CallOutController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Test", didSubmit: { (text) in
            debugPrint("No Code")
        }) {
            debugPrint("No Code")
        }

    }
    
    
    
    /// JobLocation
    func jobLocation() {
        for location in self.arrJob {
            let annotation = MKPointAnnotation()
            let val = location as! SearchJob
            annotation.title = val.role!
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(val.latitude!)!, longitude: Double(val.longitude!)!)
            mapListJob.addAnnotation(annotation)
        }
    }
}



// MARK: - MKMapViewDelegate
extension SearchJobController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        mapListJob.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "LocationIcon")
            annotationView = pin
            return pin
            
        } else {
            let annotationIdentifier = "AnnotationIdentifier"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
                annotationView!.canShowCallout = false
            }
            else {
                annotationView!.annotation = annotation
            }
            
            
            annotationView!.image = UIImage(named: "JobIcon")
            
            return annotationView
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedPinCoordinate = (view.annotation?.coordinate)!
        print(view.annotation!.title!!)
        print(selectedPinCoordinate.latitude, selectedPinCoordinate.longitude)
        
        CallOutController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Test", didSubmit: { (text) in
            debugPrint("No Code")
        }) { 
            debugPrint("No Code")
        }
        
        
    }
}



// MARK: - UITextFieldDelegate
extension SearchJobController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSearchJob.resignFirstResponder()
        self.widthGOconstraint.constant = 0
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        self.zipCode = newString
        if newString.characters.count > 0 {
            self.widthGOconstraint.constant = 34.0
        } else {
            self.widthGOconstraint.constant = 0
        }
        return true
    }
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchJobController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJob.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchJobCell", for: indexPath) as! SearchJobCell
        cell.datasource = self.arrJob[indexPath.row] as AnyObject
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailsPageVC = mainStoryboard.instantiateViewController(withIdentifier: "JobDetailsController") as! JobDetailsController
        let val = self.arrJob[indexPath.row] as! SearchJob
        jobDetailsPageVC.strIconDetails = val.category_image!
        jobDetailsPageVC.strJobHour = val.salary_per_hour!
        jobDetailsPageVC.strJobTitle = val.role!
        jobDetailsPageVC.strJobSubTitle = val.company_name!
        jobDetailsPageVC.strJobLocation = "\(val.state!), \(val.city!)"
        jobDetailsPageVC.strShift = val.shift!
        jobDetailsPageVC.strJobPosted = val.posted_on!
        jobDetailsPageVC.strFullTime = val.type!
        jobDetailsPageVC.strJobDesc = val.jobDetail!
        NavigationHelper.helper.contentNavController!.pushViewController(jobDetailsPageVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}



// MARK: - SearchJobAPICall
extension SearchJobController {
    
    
    /// UserJOB APICall
    func userJobListAPICall(zipCode: String) {
        let concurrentQueue = DispatchQueue(label:DeviceSettings.dispatchQueueName("getJobSearch"), attributes: .concurrent)
        API_MODELS_METHODS.userJOBList(AppConstantValues.latitide, AppConstantValues.longitude, zipCode, radius:"1", queue: concurrentQueue) { (responseDict, isSuccess) in
            if isSuccess {
                print(responseDict!["result"]!["data"])
                if responseDict!["result"]!["data"].count > 0 {
                    
                    if self.arrJob.count > 0 {
                        self.arrJob.removeAll()
                    }
                    
                    self.tblList.isHidden = false
                    for value in responseDict!["result"]!["data"].arrayObject! {
                        let objJobList = SearchJob(withDictionary: value as! [String : AnyObject])
                        self.arrJob.append(objJobList)
                    }
                    self.lblDetailsContent.text = "\(self.arrJob.count) jobs available in 5 sq miles"
                    self.tblList.reloadData()
                    self.jobLocation()
                } else {
                    self.tblList.isHidden = true
                }
            } else {
                
            }
        }
    }
    
    
    /*self.dictJob = ["jobID": objJobList.jobID!, "jobDetail": objJobList.jobDetail!, "category": objJobList.category!, "state": objJobList.state!, "country": objJobList.country!, "salary_per_hour": objJobList.salary_per_hour!, "posted_on": objJobList.posted_on!, "longitude": objJobList.longitude!, "salary_per_month": objJobList.salary_per_month!, "type": objJobList.type!, "company_name": objJobList.company_name!, "salary_range": objJobList.salary_range!, "latitude": objJobList.latitude!, "category_image": objJobList.category_image!, "city": objJobList.city!, "role": objJobList.role!, "currency": objJobList.currency!, "shift": objJobList.shift!, "company_detail": objJobList.company_detail!]*/
    
    
}


