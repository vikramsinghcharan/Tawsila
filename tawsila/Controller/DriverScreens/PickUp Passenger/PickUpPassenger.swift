//
//  PickUpPassenger.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD
import GoogleMaps
import GooglePlaces
import RappleProgressHUD
import Alamofire
import SDWebImage
import UserNotifications
import AVFoundation
import NotificationCenter
import MapKit

class PickUpPassenger: UIViewController, GMSMapViewDelegate, UNUserNotificationCenterDelegate, SINCallClientDelegate, SINClientDelegate, GMSAutocompleteViewControllerDelegate {
    
    var client : SINClient?
    
    var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var pickUpCordinate : CLLocationCoordinate2D!
    var destinationCordinate : CLLocationCoordinate2D!
    var markerDriver = GMSMarker()
    var markerRider = GMSMarker()
    var acController = GMSAutocompleteViewController()

    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var lblInitialAddress: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var viewForMap: UIView!
    @IBOutlet var btnArrived: btnCustomeClass!
    
    @IBOutlet weak var viewArabic: UIView!
    @IBOutlet weak var lblInitialAddressAr: UILabel!
    @IBOutlet weak var lblMobileNumberAr: UILabel!
    @IBOutlet weak var lblUserNameAr: UILabel!
    @IBOutlet weak var lblDestinationAddressAr: UILabel!
    @IBOutlet weak var viewForMapAr: UIView!
    @IBOutlet var btnArrivedAr: btnCustomeClass!
    
    var is_arrived = Bool()
    var is_started = Bool()
    var is_completed = Bool()
    var booking_id = String()
    
    var rider_id = String()
    var rider_username = String()
    
    var pickArea = String()
    var dropArea = String()
    var distance = String()
    var ammount = String()
    var estTime = String()
    
    var reason = String()
    var text_type = ""
    
    var initialRate = String()
    var standredRate = String()
    
    var isRideStart = Bool()
    var drowRoute = Bool()
    var isCarMove = Bool()
    var is_update = Bool()
    var isAppear = Bool()
    var isForRefresh = Bool()
    var isGotDestination = Bool()

    @IBOutlet var viewRiderDetailAr: UIView!
    @IBOutlet var viewRiderDetail: UIView!

    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnCancelAr: UIButton!
    
    @IBOutlet var iconPassanger: UIImageView!
    @IBOutlet var iconPassangerEn: UIImageView!
    
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var btnNav: UIButton!
    @IBOutlet var btnSelectDestinataion: UIButton!
    @IBOutlet var btnRefresh: UIButton!
    @IBOutlet var btnSelectDestinataionAr: UIButton!
    @IBOutlet var btnRefreshAr: UIButton!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        is_update = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self .perform( #selector(self.updateLocation), with: 1, afterDelay: 0)
        
        let userInfo : NSDictionary = USER_DEFAULT .object(forKey: "userData") as! NSDictionary
        
        text_type = userInfo.value(forKey: "car_type") as! String
        
        self.getCabData()
        self.getBookingDetail()
        self.getRiderDetail()
        
        let userId = String (format: "driver_%@", USER_DEFAULT .object(forKey: "user_name") as! CVarArg)
        client = Sinch.client(withApplicationKey: "3dfef36d-ad60-48fa-a911-5a0462c8be51", applicationSecret: "iA9w0GmteEOjs0xLG5UWmg==", environmentHost: "sandbox.sinch.com", userId: userId)
        client?.enableManagedPushNotifications()
        client?.setSupportCalling(true)
        client?.startListeningOnActiveConnection()
        
        client?.delegate = self
        client?.call().delegate = self
        
         // client?.stop()
        client?.start()
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
       
        }
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)

        ///// ------
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getBookingDetail()
    {
        let dic = NSMutableDictionary()
        dic.setValue(booking_id , forKey: "booking_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_booking_details")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                let dicResult : NSDictionary =  ((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary )
                
                self.lblInitialAddress.text =  dicResult.value(forKey: "pickup_area") as? String
                self.lblInitialAddressAr.text = dicResult.value(forKey: "pickup_area") as? String
                
                let lat_pick = String (format: "%@", (dicResult.value(forKey: "pickup_lat") as? String)! )
                let long_pick = String (format: "%@", (dicResult.value(forKey: "pickup_long") as? String)! )
            
                self.pickUpCordinate = DLRadioButton.cordinate(fromLat: lat_pick, long: long_pick) as CLLocationCoordinate2D
                self.markerRider.position = self.pickUpCordinate
                
                let strDrpArea : String = (dicResult.value(forKey: "drop_area") as? String)!
                
                if strDrpArea == "null"
                {
                    self.isForRefresh = true
                }
                else
                {
                    self.isGotDestination = true
                    self.isForRefresh = false
                    self.btnSelectDestinataion.isHidden = true
                    self.btnRefresh.isHidden = true
                    
                    self.btnSelectDestinataionAr.isHidden = true
                    self.btnRefreshAr.isHidden = true
                    
                    self.lblDestinationAddress.text = dicResult.value(forKey: "drop_area") as? String
                    self.lblDestinationAddressAr.text = dicResult.value(forKey: "drop_area") as? String
                 
                    let lat_drop = String (format: "%@", (dicResult.value(forKey: "drop_lat") as? String)! )
                    let long_drop = String (format: "%@", (dicResult.value(forKey: "drop_long") as? String)! )

                    self.destinationCordinate = DLRadioButton.cordinate(fromLat: lat_drop, long: long_drop) as CLLocationCoordinate2D
                }
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func updateLocation()
    {
        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        // mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT)
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            viewForMap.addSubview(mapView)
        }else{
            viewForMapAr.addSubview(mapView)
        }
        
        markerRider.map = self.mapView
        markerRider.icon = #imageLiteral(resourceName: "passenger")
        
        markerDriver.position = (self.locationManager.location?.coordinate)!
        markerDriver.map = self.mapView
        markerDriver.icon = Utility.sharedInstance.get_car_icon(car_type: text_type)
        isCarMove = true
        self.carMove()
        
        self.perform( #selector(self.perform_update_location), with: 1, afterDelay: 1)

        // RappleActivityIndicatorView.stopAnimation()
    }
    
    @IBAction func actionAskForCancel(_ sender: Any) {
        
        if self.isRideStart == true
        {
            
        }
        else
        {
            var atitle,amessge,acancel : String!

            if AppDelegateVariable.appDelegate.strLanguage == "en"
            {
                atitle = "Cancel Ride"
                amessge = "Choose Option"
                acancel = "Cancel"
            }
            else
            {
                atitle = "إلغاء ركوب"
                amessge = "اختر الخيار"
                acancel = "إلغاء"
            }

            
            let actionSheetController: UIAlertController = UIAlertController(title: amessge, message: "", preferredStyle: .actionSheet)
            let cancelRide: UIAlertAction = UIAlertAction(title: atitle, style: .default) { action -> Void in
                
                self .performSelector(onMainThread: #selector(self.cancelPopUp), with: "", waitUntilDone: false)
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: acancel, style: .cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelRide)
            
            actionSheetController.addAction(cancelAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func cancelPopUp()  {
        
        var strTitle, r1,r2,r3,r4,r5,r6:String!
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            strTitle = "Choose Cancel Option"
            r1 = "Due to some urgent work"
            r2 = "Pickup location is too far"
            r3 = "Cannot reach in time"
            r4 = "Unable to contact rider"
            r5 = "My reason is not listed"
            r6 = "Cancel"
        }
        else{
            strTitle = "اختر إلغاء الخيار"
            r1 = "بسبب بعض العمل العاجل"
            r2 = "موقع لاقط بعيد جدا"
            r3 = "لا يمكن أن تصل في الوقت المحدد"
            r4 = "تعذر توصيل الركاب"
            r5 = "سببي غير مدرج"
            r6 = "إلغاء"
        }
        let actionSheetController: UIAlertController = UIAlertController(title: strTitle, message: "", preferredStyle: .actionSheet)
        
        let action0: UIAlertAction = UIAlertAction(title: r1, style: .default) { action -> Void in
            
            self.reason = "Due to some urgent work";
            self.cancelRide()
        }
        
        let action1: UIAlertAction = UIAlertAction(title: r2, style: .default) { action -> Void in
            
            self.reason = "Pickup location is too far";
            self.cancelRide()
            
        }
        let action2: UIAlertAction = UIAlertAction(title: r3, style: .default) { action -> Void in
            
            self.reason = "Cannot reach in time";
            self.cancelRide()
        }
        
        let action3: UIAlertAction = UIAlertAction(title: r4, style: .default) { action -> Void in
            
            self.reason = "Unable to contact rider";
            self.cancelRide()
        }
        
        let action4: UIAlertAction = UIAlertAction(title: r5, style: .default) { action -> Void in
            
            self.reason = "My reason is not listed";
            self.cancelRide()
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: r6, style: .cancel) { action -> Void in
            
            // Just dismiss the action sheet
        }
        
        actionSheetController.addAction(action0)
        actionSheetController.addAction(action1)
        actionSheetController.addAction(action2)
        actionSheetController.addAction(action3)
        actionSheetController.addAction(action4)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    @IBAction func actionCallToUser(_ sender: Any) {
        var number: URL!
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            number = URL(string:  "tel://"+lblMobileNumber.text! )
        }
        else{
            number = URL(string:  "tel://"+lblMobileNumberAr.text! )
        }
        UIApplication.shared.open(number!)
    }
    
    
    @IBAction func actionArrived(_ sender: Any) {
        
        if is_arrived == true
        {
            if isGotDestination == true
            {
                self.startRide()
            }
            else
            {
                if AppDelegateVariable.appDelegate.strLanguage == "en"
                {
                    Utility.sharedInstance.showAlert(kAPPName, msg: "Select or refresh destinatin first", controller: self)
                }
                else
                {
                    Utility.sharedInstance.showAlert(kAPPName, msg: "حدد أو تحديث دستيناتين أولا", controller: self)
                }

            }
        }
        else
        {
            self.arrived()
            if AppDelegateVariable.appDelegate.strLanguage == "en" {
                btnArrived.setTitle("Start Ride", for: .normal)
            }
            else
            {
                btnArrivedAr.setTitle("بدء ركوب", for: .normal)
            }
            is_arrived = true
        }
    }
    
    @IBAction func actionCompleteRide(_ sender: Any) {
        destinationCordinate = locationManager.location?.coordinate
        self .getPolylineRoute(from: pickUpCordinate, to: destinationCordinate);
        
    }
    
    func arrived() {
        
        if AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            lblTitle.text = "On Trip"
        }
        else
        {
            lblTitle.text = "في رحلة"
        }
        
        let dic = NSMutableDictionary()
        
        dic.setValue(rider_username, forKey: "username")
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(UserDefaults.standard .object(forKey: "user_id") as! String, forKey: "driver_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "reach_at_pickup_location")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func startRide() {
        
        // http://taxiappsourcecode.com/api/index.php?option=start_ride]    parameter name -- [username=scientificwebs, booking_id=405, driver_id=14
        
        markerRider.icon = nil;
        
        iconPassangerEn.isHidden = true
        btnNav.isHidden = false
        pickUpCordinate = locationManager.location?.coordinate
        
        let dic = NSMutableDictionary()
        
        dic.setValue(rider_username, forKey: "username")
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(UserDefaults.standard .object(forKey: "user_id") as! String, forKey: "driver_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "start_ride")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                
                self.isRideStart = true
                self.btnCancel.isHidden = true
                self.btnArrived.isHidden =  true
                
                
                self.drowRoute = true
                self.getPolylineRoute(from: self.pickUpCordinate, to: self.destinationCordinate)
                
                if AppDelegateVariable.appDelegate.strLanguage == "en" {
                    
                    self.btnCancel.isHidden = true
                    self.btnArrived.isHidden =  true
                    self.viewRiderDetail.isHidden = true

                    UIView .animate(withDuration: 0.5, animations: {
                        self.viewForMap.frame = CGRect(x: 0, y: 64, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT-64)
                        self.mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT-64)
                    })
                }
                else {
                    
                    self.btnCancelAr.isHidden = true
                    self.btnArrivedAr.isHidden =  true
                    self.viewRiderDetailAr.isHidden = true

                    UIView .animate(withDuration: 0.5, animations: {
                        self.viewForMapAr.frame = CGRect(x: 0, y: 64, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT-64)
                        self.mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT-64)
                    })
                }
                
                //self.viewRiderDetail.isHidden = true
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func completeRide()
    {
        
        let dic = NSMutableDictionary()
        
        // http://taxiappsourcecode.com/api/index.php?option=reach_at_pickup_location
        // booking_id=, driver_id=, amount, km, distance, pickup_area, drop_area
        
        self.is_update = false;
        
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(UserDefaults.standard .object(forKey: "user_id") as! String, forKey: "driver_id")
        dic.setValue(pickArea, forKey: "pickup_area")
        dic.setValue(dropArea, forKey: "drop_area")
        dic.setValue(ammount, forKey: "amount")
        dic.setValue(self.distance, forKey: "km")
        dic.setValue(estTime, forKey: "distance")
        dic.setValue(String (format: "%f", (pickUpCordinate.latitude)), forKey: "pickup_lat")
        dic.setValue(String (format: "%f", (pickUpCordinate.longitude)), forKey: "pickup_long")
        
        dic.setValue(String (format: "%f", (destinationCordinate.latitude)), forKey: "drop_lat")
        dic.setValue(String (format: "%f", (destinationCordinate.longitude)), forKey: "drop_long")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "complete_booking")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in

            if status == true
            {
                let popUp = Bundle.main.loadNibNamed("PayBillDetails", owner: self, options: nil)![0] as? UIView as! PayBillDetails
                
                if AppDelegateVariable.appDelegate.strLanguage == "en"{
                    
                    popUp.frame = self.view.frame
                    popUp.lblAmount.text = self.ammount
                    popUp.lblAddress.text = self.pickArea
                    popUp.lblAddressDest.text = self.dropArea
                    popUp.car_type.text = self.text_type
                    popUp.btnGoToMyRide.addTarget(self, action: #selector(self.gotoMyRide), for: .touchUpInside)
                }
                else {
                    popUp.frame = self.view.frame
                    popUp.lblAmountAr.text = self.ammount
                    popUp.lblAddressAr.text = self.pickArea
                    popUp.lblAddressDestAr.text = self.dropArea
                    popUp.car_typeAr.text = self.text_type
                    popUp.btnGoToMyRideAr.addTarget(self, action: #selector(self.gotoMyRide), for: .touchUpInside)
                }
                
                self.view.addSubview(popUp)
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func gotoMyRide()
    {
        let obj: AllRides = AllRides(nibName: "AllRides", bundle: nil)
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
    }
    
    func cancelRide()
    {
        
        let dic = NSMutableDictionary()
        
        // http://taxiappsourcecode.com/api/index.php?option=cancel_booking_by_driver
        // booking_id=, driver_id=, amount, km, distance, pickup_area, drop_area
        // booking_id, driver_id, reason_to_cancel
        
        dic.setValue(booking_id, forKey: "booking_id")
        dic.setValue(UserDefaults.standard .object(forKey: "user_id") as! String, forKey: "driver_id")
        dic.setValue(reason, forKey: "reason_to_cancel")
        
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "cancel_booking_by_driver")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    
    // MARK: - Drow Route Method
    // MARK:
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        Alamofire.request(url.absoluteString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            // print(response);
            
            do {
                
                if (response.result.value != nil)
                {
                    let routes = (response.result.value as AnyObject).object(forKey: "routes")  as? [Any]
                    
                    if (routes?.count)! > 0
                    {
                        let overview_polyline : NSDictionary = (routes?[0] as? NSDictionary)!
                        
                        let dic : NSDictionary = overview_polyline as Any as! NSDictionary
                        
                        if (self.drowRoute == true)
                        {
                            self.drowRoute = false
                            
                            let dic : NSDictionary = overview_polyline as Any as! NSDictionary
                            
                            let value : NSDictionary = dic.object(forKey: "overview_polyline") as! NSDictionary
                            
                            let polyString : String = value.object(forKey: "points") as! String
                            
                            self.showPath(polyStr: polyString)
                        }
                        else
                        {
                            let estDistance : String =  ((((((dic.object(forKey: "legs") as! NSArray) .object(at: 0)) as AnyObject).object(forKey: "distance") ) as! NSDictionary) .object(forKey: "text") as? String)!
                            
                            self.pickArea =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject).object(forKey: "start_address") ) as? String)!
                            
                            self.dropArea =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject).object(forKey: "end_address") ) as? String)!
                            
                            self.distance = estDistance ;
                            
                            self.estTime =  ((((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject).object(forKey: "duration") ) as! NSDictionary) .object(forKey: "text") as? String)!
                            self.ammount = "100";
                            
                            let srate :Float = (self.standredRate as NSString ).floatValue
                            let sirate :Float = (self.initialRate as NSString ).floatValue
                            let tfare : Float = srate + sirate * (estDistance as NSString).floatValue;
                            self.ammount = NSString (format: "%d", Int(tfare) ) as String
                            self.completeRide();
                        }
                    }
                    else
                    {
                        Utility.sharedInstance.showAlert(kAPPName, msg: "Route Not Found" as String, controller: self)
                    }
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
    }
    
    func showPath(polyStr :String)
    {
        let marker_pick = GMSMarker()
        marker_pick.position = self.pickUpCordinate
        // marker_pick.title = self.lblPickAddressAr.text
        marker_pick.map = self.mapView
        marker_pick.icon = #imageLiteral(resourceName: "markerLocation")
        
        let marker_dest = GMSMarker()
        marker_dest.position = self.destinationCordinate
        // marker_dest.title = self.lblPickAddressAr.text
        marker_dest.map = self.mapView
        marker_dest.icon = #imageLiteral(resourceName: "markerDesitnation")
        
        
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = #colorLiteral(red: 0.7661251426, green: 0.6599388719, blue: 0, alpha: 1)
        
        polyline.map = mapView
        
        var bounds = GMSCoordinateBounds()
        
        for index in 1...Int((path?.count())!)
            
        {
            bounds = bounds.includingCoordinate((path?.coordinate(at: UInt(index)))!)
        }
        
        bounds = bounds.includingCoordinate(pickUpCordinate)
        bounds = bounds.includingCoordinate(destinationCordinate)
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
    }
    
    func carMove()
    {
        
        let fLat: Float = Float((markerDriver.position.latitude).degreesToRadians)
        let fLng: Float = Float((markerDriver.position.longitude).degreesToRadians)
        let tLat: Float = Float((locationManager.location?.coordinate.latitude)!.degreesToRadians)
        let tLng: Float = Float((locationManager.location?.coordinate.longitude)!.degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        
        if degree >= 0
        {
            markerDriver.rotation = CLLocationDegrees(degree)
        }
        else
        {
            markerDriver.rotation = CLLocationDegrees(degree + 360)
        }
        
        CATransaction.begin()
        CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
        
        markerDriver.position = (locationManager.location?.coordinate)!
        markerDriver.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        CATransaction.commit()
        
        if isCarMove == true
        {
            self .perform(#selector(carMove), with: nil, afterDelay: 0)
        }
    }
    
    func getCabData()
    {
        let dic = NSMutableDictionary()
        
        dic.setValue(text_type, forKey: "cartype")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_cab_data")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                let dicResult : NSDictionary =  ((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary )
                
                self.initialRate = NSString (format:"%@",dicResult .value(forKey: "intailrate") as! CVarArg ) as String
                self.standredRate = NSString (format:"%@",dicResult .value(forKey: "standardrate") as! CVarArg ) as String
                
                //  ":"49","":"145
                //   self.text_type =
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func getRiderDetail()
    {
        let dic = NSMutableDictionary()
        
        dic.setValue("user", forKey: "usertype")
        dic.setValue(self.rider_id, forKey: "id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_user_profile")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                let dicResult : NSDictionary =  dataDictionary.object(forKey: "result") as! NSDictionary
                self.lblUserName.text = dicResult .object(forKey: "username") as? String
                self.lblMobileNumber.text = dicResult .object(forKey: "mobile") as? String
                self.rider_username = (dicResult .object(forKey: "username") as? String)!
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    // MARK: - Notification Delegate
    // MARK:
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
        let application = UIApplication.shared
        
        // self.delegate?.gotNotification(title: notification.request.content.title);
        // let title : String = notification.request.content.title
        
        let title : String =  (notification.request.content.userInfo as NSDictionary ) .object(forKey: "gcm.notification.title1") as! String
        
        if title == "cancel_by_rider"
        {
            AppDelegateVariable.appDelegate.id_booking = "cancel";
            self.navigationController?.popViewController(animated: true)
        }
        
        if(application.applicationState == .active)
        {
            
        }else if(application.applicationState == .background){
            
            
        }else if(application.applicationState == .inactive){
            
            
        }
    }
    
    
    func getCordinateFromsAddress()
    {
        let url = URL(string: "")!
        
        Alamofire.request(url.absoluteString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if (response.result.value != nil)
            {
                let routes = (response.result.value as AnyObject).object(forKey: "routes")  as? [Any]
                
                if (routes?.count)! > 0
                {
                   
                }
                else
                {
                    Utility.sharedInstance.showAlert(kAPPName, msg: "Route Not Found" as String, controller: self)
                }
            }
            
        }
    }
    
    // MARK: Sinch Delgates
    // MARK:

    func clientDidStart(_ client: SINClient!) {
        
    }
    
    func clientDidStop(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        
    }
    
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        
        let strory : UIStoryboard  = UIStoryboard.init(name: "Main", bundle: Bundle .main )
        
        let callCon : CallViewController = strory .instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
        
        callCon.call = call
        callCon.tagType = 1;
        callCon.lang = AppDelegateVariable.appDelegate.strLanguage 
        self.present(callCon, animated: true, completion: nil)
        
    }
    
    @IBAction func tapNavigation(_ sender: Any) {
        
            let placemark : MKPlacemark = MKPlacemark(coordinate: destinationCordinate , addressDictionary:nil)
            
            let mapItem : MKMapItem = MKMapItem(placemark: placemark)
            
            mapItem.name = "Target location"
            
            let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
            
            let currentLocationMapItem:MKMapItem = MKMapItem.forCurrentLocation()
            
            MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: launchOptions as? [String : Any])
    }
    
    func perform_update_location() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue(UserDefaults.standard .object(forKey: "user_id") as! String, forKey: "user_id")
        dic.setValue(String (format: "%f", (locationManager.location!.coordinate.latitude)), forKey: "lat")
        dic.setValue(String (format: "%f", (locationManager.location!.coordinate.longitude)), forKey: "long")
        
        var parameterString = String(format : "save_driver_location")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if self.is_update == true
            {
                self.perform( #selector(self.perform_update_location), with: 1, afterDelay: 1)
            }
            
            if status == true
            {
                
            }
            else
            {
                
            }
        }
    }
    
    @IBAction func tapRefreshDestination(_ sender: Any){
        
        isForRefresh = true
        self.getBookingDetail()
    }
    
    // MARK: Destination Selection
    // MARK:

    @IBAction func tapSelectDestination(_ sender: Any){
        
        acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        // let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 10.0)
        // mapView.camera = camera
        
        destinationCordinate = place.coordinate
        lblDestinationAddress.text = place.formattedAddress!
        lblDestinationAddressAr.text = place.formattedAddress!

        self.updateDestinatinApi()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error){
        print("Error: ", error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func updateDestinatinApi()
    {
        btnRefresh.isHidden = true
        let dic = NSMutableDictionary()
        
        
        dic.setValue(String (format: "%f", destinationCordinate.latitude), forKey: "drop_lat")
        dic.setValue(String (format: "%f", destinationCordinate.longitude), forKey: "drop_long")
        dic.setValue(lblDestinationAddress.text, forKey: "drop_area")
        dic.setValue("10", forKey: "amount")
        dic.setValue("10", forKey: "distance")
        dic.setValue(booking_id, forKey: "booking_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "update_booking_details")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                self.isGotDestination = true
                RappleActivityIndicatorView.stopAnimation()
            }
            else
            {
                // Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
}
