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
import Alamofire
import SwiftyJSON

class SearchJobController: BaseViewController {

    @IBOutlet weak var circleIndicator: BPCircleActivityIndicator!
    var dictJob = [String: String]()
    var zipCode = ""
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var indexselected = -1
    var arrJob = [AnyObject]()
    var arrSearchJob = [AnyObject]()
    var locationManager = CLLocationManager()
    var annotationView: MKAnnotationView!
    var save = 0
    @IBOutlet weak var btnGO: UIButton!
    @IBOutlet weak var viewRecenter: UIView!
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
        AppConstantValues.companyAccessToken = String(describing: OBJ_FOR_KEY(key: "AccessToken")!)
        print("Access Token : \(AppConstantValues.companyAccessToken)")
        self.lblNoDataFound.text = "No jobs available on this location"
        self.viewRecenter.isHidden = true
        self.viewRecenter.layer.cornerRadius = 5.0
        self.viewRecenter.layer.masksToBounds = true
        self.txtSearchJob.keyboardType = .numberPad
        AppConstantValues.latitide = "41.850033"
        AppConstantValues.longitude = "-87.6500523"
        //self.location()
        self.lblDetailsContent.text = "No jobs available in 5 sq miles"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        circleIndicator.isHidden = false
        circleIndicator.animate()
        self.fetchZipCode()
        mapListJob.showsUserLocation = true
        
        self.widthGOconstraint.constant = 0
        self.viewList.isHidden = true
        self.lblListContent.text = "List View"
        self.imgListContent.isHidden = false
        self.imgMapContent.isHidden = true
        self.txtSearchJob.layer.borderWidth = 1.0
        self.txtSearchJob.layer.borderColor = UIColorRGB(r: 202, g: 202, b: 202)?.cgColor
        
        NavigationHelper.helper.recallJobAPI = {
            self.fetchZipCode()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkAccess), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NavigationHelper.helper.reloadMenu()
        NavigationHelper.helper.headerViewController?.isBack = false
        NavigationHelper.helper.headerViewController?.isShowNavBar(isShow: true)
        NavigationHelper.helper.headerViewController?.leftButton.setImage(UIImage(named: "Dash"), for: UIControlState.normal)
        NavigationHelper.helper.headerViewController?.leftButton.addTarget(self, action: #selector(SearchJobController.actionDash), for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// NetworkAccess
    func networkAccess() {
        if AppConstantValues.isNetwork == "true" {
            if AppConstantValues.isCallSearchJob == "yes" {
                AppConstantValues.isCallSearchJob = "no"
                self.fetchZipCode()
            }
        } else {
            AppConstantValues.isCallSearchJob = "yes"
        }
    }
    
    @IBAction func recenter(_ sender: UIButton) {
        self.txtSearchJob.text = ""
        circleIndicator.isHidden = false
        circleIndicator.animate()
        self.mapListJob.showsUserLocation = true
        self.viewRecenter.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.location()
    }
    
    /// Current Location
    func location() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            currentLocation = locManager.location
            AppConstantValues.latitide = String(currentLocation.coordinate.latitude)
            AppConstantValues.longitude = String(currentLocation.coordinate.longitude)
            print(AppConstantValues.latitide, AppConstantValues.longitude)
            self.fetchZipCode()
        }
    }
    
    
    /// Fetch Lat & Lon from ZipCode
    func fetchLatLonFromZip(zipCode: String) {
        Alamofire.request(URL_LAT_LON_FROM_ZIPCODE + zipCode, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let val = JSON(data)
                    if val["results"].count > 0 {
                        self.mapListJob.removeAnnotations(self.mapListJob.annotations)
                        AppConstantValues.latitide = String(describing: val["results"][0]["geometry"]["location"]["lat"])
                        AppConstantValues.longitude = String(describing: val["results"][0]["geometry"]["location"]["lng"])
                        AppConstantValues.zipcode = zipCode
                        print(AppConstantValues.latitide, AppConstantValues.longitude)
                        
                        
                        let coordinations = CLLocationCoordinate2D(latitude: Double(AppConstantValues.latitide)!,longitude: Double(AppConstantValues.longitude)!)
                        let span = MKCoordinateSpanMake(0.2,0.2)
                        let region = MKCoordinateRegion(center: coordinations, span: span)
                        
                        self.mapListJob.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = "You're here"
                        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(AppConstantValues.latitide)!, longitude: Double(AppConstantValues.longitude)!)
                        self.mapListJob.addAnnotation(annotation)
                        
                        self.userJobListAPICall(zipCode: zipCode)
                    } else {
                        self.circleIndicator.isHidden = true
                        self.circleIndicator.stop()
                        self.btnGO.isEnabled = true
                        ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "You have exceeded your daily request quota for this API", didSubmit: { (text) in
                            debugPrint("No Code")
                        }, didFinish: {
                            debugPrint("No Code")
                        })
                    }
                    
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                break
                
            }
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
        circleIndicator.isHidden = false
        circleIndicator.animate()
        self.mapListJob.showsUserLocation = false
        self.viewRecenter.isHidden = false
        self.btnGO.isEnabled = false
        self.txtSearchJob.resignFirstResponder()
        print(self.zipCode)
        self.fetchLatLonFromZip(zipCode: self.zipCode)
    }
    
    
    /// ListShow
    ///
    /// - Parameter sender: Button
    @IBAction func actionList(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.viewList.isHidden = true
            self.lblListContent.text = "List View"
            self.imgListContent.isHidden = false
            self.imgMapContent.isHidden = true
        } else {
            sender.isSelected = true
            self.viewList.isHidden = false
            self.lblListContent.text = "Map View"
            self.imgListContent.isHidden = true
            self.imgMapContent.isHidden = false
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
        self.mapListJob.removeAnnotations(self.mapListJob.annotations)
        print(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        AppConstantValues.latitide = String(userLocation.coordinate.latitude)
        AppConstantValues.longitude = String(userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        mapListJob.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "currentLocation")
            pin.canShowCallout = true
            annotationView = pin
            return pin
            
        } else {
            let annotationIdentifier = "AnnotationIdentifier"
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
                
            }
            else {
                annotationView!.annotation = annotation
            }
            
            
            if annotation.title!! == "You're here" {
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named: "LocationIcon")
            } else {
                annotationView!.canShowCallout = false
                annotationView!.image = UIImage(named: "JobIcon")
            }
            
            
            
            return annotationView
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedPinCoordinate = (view.annotation?.coordinate)!
        print(view.annotation!.title!!)
        print(selectedPinCoordinate.latitude, selectedPinCoordinate.longitude)
        
        for val in self.arrJob {
            let details = val as! SearchJob
            if details.role! == view.annotation!.title!! {
                print(details.role!)
                let loc = "\(details.state!), \(details.city!)"
                
                if let save = details.save {
                    self.save = save
                } else {
                    self.save = 0
                }
                
                CallOutController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, strJobId: details.jobID! ,strIconDetails: details.category_image!, strJobHour: details.salary_per_hour!, strJobTitle: details.role!, strJobSubTitle: details.company_name!, strJobLocation: loc, strShift: details.shift!, strJobPosted: details.posted_on!, strFullTime: details.type!, strJobDesc: details.jobDetail!, save: self.save, didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: { (text) in
                    for annotation in self.mapListJob.selectedAnnotations {
                        self.mapListJob.deselectAnnotation(annotation, animated: false)
                    }
                })
                
                break
            }
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
        cell.didCallLoader = {
        }
        cell.didSendValue = { text, check in
            if check {
                self.circleIndicator.isHidden = false
                self.circleIndicator.animate()
                
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "Successfully saved", didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
                self.userJobListAPICall(zipCode: AppConstantValues.zipcode)
            } else {
                ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: text, didSubmit: { (text) in
                    debugPrint("No Code")
                }, didFinish: {
                    debugPrint("No Code")
                })
            }
        }
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
        jobDetailsPageVC.strJobId = val.jobID!
        if let save = val.save {
            jobDetailsPageVC.save = save 
        }
        jobDetailsPageVC.strJobFunction = "view"
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
            print(AppConstantValues.latitide, AppConstantValues.longitude, zipCode)
            API_MODELS_METHODS.userJOBList(AppConstantValues.latitide, AppConstantValues.longitude, zipCode, radius:"5", queue: concurrentQueue) { (responseDict, isSuccess) in
                if isSuccess {
                    self.circleIndicator.stop()
                    self.circleIndicator.isHidden = true
                    self.btnGO.isEnabled = true
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
                        self.lblDetailsContent.text = "No jobs available in 5 sq miles"
                        ToastController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, alertMessage: "No job found", didSubmit: { (text) in
                            debugPrint("No Code")
                        }, didFinish: {
                            debugPrint("No Code")
                        })
                    }
                } else {
                    self.circleIndicator.stop()
                    self.circleIndicator.isHidden = true
                }
            }
    }
}


