//
//  PickUPRideVC.swift
//  Tawsila
//
//  Created by Sanjay on 21/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RappleProgressHUD
import Alamofire
import SDWebImage
import UserNotifications
import SwiftySound
import GooglePlacePicker

class PickUPRideVC: UIViewController , GMSMapViewDelegate , UNUserNotificationCenterDelegate , PayPalPaymentDelegate,SINCallClientDelegate, SINClientDelegate, GMSAutocompleteViewControllerDelegate {
    
    
    var client : SINClient?
    
    var payPalConfig = PayPalConfiguration()
    @IBOutlet var lbltitle: UILabel!
    
    @IBOutlet var viewFooter: UIView!
    
    var locationManager = CLLocationManager()
    
    var mapView: GMSMapView!
    var lblTime: UILabel!
    @IBOutlet var viewForMap: UIView!
    
    @IBOutlet var viewDriverDetail: UIView!
    @IBOutlet var lbl_driverName: UILabel!
    @IBOutlet var lbl_carType: UILabel!
    @IBOutlet var lbl_car_number: UILabel!
    @IBOutlet var driverRating: StarRatingControl!
    
    @IBOutlet var lbl_driverNameAr: UILabel!
    @IBOutlet var lbl_carTypeAr: UILabel!
    @IBOutlet var lbl_car_numberAr: UILabel!
    @IBOutlet var driverRatingAr: StarRatingControl!
    @IBOutlet var viewDetailAr: UIView!
    
    var cordinatePick = CLLocationCoordinate2D()
    var cordinateDrop = CLLocationCoordinate2D()
    var cordinateDestination = CLLocationCoordinate2D()
    
    var id_booking : String!
    
    var driver_name = ""
    var id_driver : String!
    var cordinateDriver = CLLocationCoordinate2D()
    var driverMaker = GMSMarker()
    var marker_pick = GMSMarker()
    var bounds = GMSCoordinateBounds()
    
    var addressDrop : String!
    var dvrPhone = String()
    var is_fill = Bool()
    var is_path = Bool()
    var is_Ride_Start = Bool()
    var is_complete = Bool()
    var is_pathed = Bool()
    var reason = String()
    var forRefresh = Bool()
    var isDestination = Bool()
    
    var polyline = GMSPolyline()
    var path = GMSPath()
    
    var driverName = ""
    // -- BILL POPUP
    
    @IBOutlet var lbl_Amount: UILabel!
    @IBOutlet var lbl_pickAddress: UILabel!
    @IBOutlet var lbl_dropAddress: UILabel!
    @IBOutlet var lblCarType_bill: UILabel!
    @IBOutlet var tapButtonOK: UIButton!
    @IBOutlet var rating: StarRatingControl!
    @IBOutlet var viewBIll: UIView!
    @IBOutlet var rtVIew: UIView!
    @IBOutlet var imgRed: UIImageView!
    @IBOutlet var lblHowWas: UILabel!
    
    var total_amout = String()
    var car_type = String()
    
    @IBOutlet var lblDestinationAddress: UILabel!
    @IBOutlet var viewSelectDestination: UIView!
    @IBOutlet var btnRefresh: UIButton!
    
    var acController = GMSAutocompleteViewController()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        is_path = false
        is_fill = false
        is_Ride_Start = false
        is_complete = false
        is_pathed = false
        
        cordinateDestination = AppDelegateVariable.appDelegate.codrdinateDestiantion
        
        id_booking = AppDelegateVariable.appDelegate.id_booking as String
        
        cordinatePick = AppDelegateVariable.appDelegate.codrdinatePick
        
        //  Map View
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let camera = GMSCameraPosition.camera(withLatitude: cordinatePick.latitude, longitude: cordinatePick.longitude, zoom: 13.0)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self as GMSMapViewDelegate
        // mapView.isMyLocationEnabled = true
        mapView.camera = camera
        mapView.frame = CGRect(x: 0, y: 0, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT)
        viewForMap.addSubview(mapView)
        
        marker_pick = GMSMarker()
        marker_pick.position = cordinatePick
        marker_pick.map = mapView
        ///marker_pick.iconView = markerIconView();
        marker_pick.icon = #imageLiteral(resourceName: "markerLocation")
        
        driverMaker = GMSMarker()
        self.view .addSubview(markerIconView())
        
        
        
        for i in 100 ... 103
        {
            let img: UIImageView = self.viewFooter.viewWithTag(i) as! UIImageView
            img.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            img.image = img.image?.withRenderingMode(.alwaysTemplate)
        }
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        tapButtonOK.layer.cornerRadius = 4;
        
        rtVIew.layer.cornerRadius = 4;
        rtVIew.layer.borderColor = UIColor.lightGray.cgColor
        rtVIew.layer.borderWidth = 1
        
        imgRed.tintColor = UIColor.red
        imgRed.image = imgRed.image?.withRenderingMode(.alwaysTemplate)
        lbl_carType.text = car_type
        
        viewSelectDestination.layer.cornerRadius = 3
        btnRefresh.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        viewSelectDestination.layer.borderColor = UIColor.gray.cgColor
        viewSelectDestination.layer.borderWidth = 0.5
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar"
        {
            viewDetailAr.isHidden = false
            viewFooter.isHidden = true
            
            let array : Array
                = ["مكالمة","إلغاء","شارك","ركوب الحية","أكثر من","كيف كانت رحلتك؟"];
            
            for i in 0 ... 3
            {
                let lbl : UILabel = self.view.viewWithTag(200+i) as! UILabel;
                lbl.text = array[i]
            }
            
            lbltitle.text = "ركوب لاقط"
            lbltitle.textAlignment  = NSTextAlignment.right
            
            tapButtonOK .setTitle("حسنا", for: .normal);
            lblDestinationAddress.textAlignment = NSTextAlignment.right
            btnRefresh.frame = CGRect(x: 0, y: -6 , width: 51, height: 41)
        }
        
        
        
        /////  -- -creating sinch client
        
        let userId = String (format: "rider_%@", USER_NAME)
        client = Sinch.client(withApplicationKey: "3dfef36d-ad60-48fa-a911-5a0462c8be51", applicationSecret: "iA9w0GmteEOjs0xLG5UWmg==", environmentHost: "sandbox.sinch.com", userId: userId)
        client?.delegate = self
        client?.enableManagedPushNotifications()
        // client?.setSupportActiveConnectionInBackground(true)
        client?.setSupportCalling(true)
        client?.call().delegate = self
        
        // client?.stop()
        self.perform( #selector(self.startClient), with: 1, afterDelay: 1)
        
        if isDestination == true
        {
            viewSelectDestination.isHidden = true
            
            
            let marker_dest = GMSMarker()
            marker_dest.position = self.cordinateDestination
            //marker_dest.title = self.lblPickAddressAr.text
            marker_dest.map = self.mapView
            marker_dest.icon = #imageLiteral(resourceName: "markerDesitnation")
        }
    }
    
    
    func startClient()  {
        
        client?.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar"
        {
            lbltitle.text = "فاتورتك";
            lblHowWas.text = "كيف كانت رحلتك؟"
        }
        
        let ratone = USER_DEFAULT.object(forKey: "rateOne") as? String
        // ratone = "1";
        if ratone == "1"
        {
            self.is_complete = true
            self.is_Ride_Start = false
            lbltitle.text = "Your Bill"
            RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
            self.is_complete = true
            self.getBockingDetail()
            
        }
        else
        {
            RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
            self.perform(#selector(getBockingDetail), with: "", afterDelay: 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Fotter Methods
    
    @IBAction func tapCall(_ sender: Any) {
        
        let number = URL(string:  "tel://"+dvrPhone )
        UIApplication.shared.open(number!)
        
    }
    
    @IBAction func tapCancelRide(_ sender: Any){
        
        if self.is_Ride_Start == true
        {
            
        }
        else
        {
            var atitle,amessge,ayes,aNo : String!
            if AppDelegateVariable.appDelegate.strLanguage == "en"
            {
                atitle = "Cancel Ride"
                amessge = "Sure Want to Cacel Ride"
                ayes = "Yes"
                aNo = "No"
            }
            else
            {
                atitle = "إلغاء ركوب"
                amessge = "بالتأكيد تريد أن ركوب كاسيل"
                ayes = "نعم فعلا"
                aNo = "لا"
            }
            
            let actionSheetController: UIAlertController = UIAlertController(title: atitle, message: amessge, preferredStyle: .alert)
            
            let yesAction: UIAlertAction = UIAlertAction(title: ayes, style: .default) { action -> Void in
                self.cancelPopUp()
            }
            
            let noAction: UIAlertAction = UIAlertAction(title: aNo, style: .default) { action -> Void in
                
            }
            
            actionSheetController.addAction(noAction)
            actionSheetController.addAction(yesAction)
            
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    func cancelPopUp()  {
        
        var strTitle, r1, r2, r3, r4, r5, r6 : String!
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            strTitle = "Choose Cancel Option"
            r1 = "Already booked another taxi"
            r2 = "Driver has low ranking"
            r3 = "Unable to contact driver"
            r4 = "Expected a shorter wait time"
            r5 = "My reason is not installed"
            r6 = "Cancel"
        }else{
            strTitle = "اختر إلغاء الخيار"
            r1 = "حجزت سيارة أجرة أخرى"
            r2 = "السائق لديه تصنيف منخفض"
            r3 = "تعذر الاتصال ببرنامج التشغيل"
            r4 = "من المتوقع أن يكون وقت الانتظار أقل"
            r5 = "سببي غير مدرج"
            r6 = "إلغاء"
        }
        let actionSheetController: UIAlertController = UIAlertController(title: strTitle, message: "", preferredStyle: .actionSheet)
        
        let action0: UIAlertAction = UIAlertAction(title: r1, style: .default) { action -> Void in
            
            self.reason = "Already booked another taxi";
            self.cancelRide()
        }
        
        let action1: UIAlertAction = UIAlertAction(title: r2, style: .default) { action -> Void in
            
            self.reason = "Driver has low ranking";
            self.cancelRide()
            
        }
        let action2: UIAlertAction = UIAlertAction(title: r3, style: .default) { action -> Void in
            
            self.reason = "Unable to contact driver";
            self.cancelRide()
            
        }
        let action3: UIAlertAction = UIAlertAction(title: r4, style: .default) { action -> Void in
            
            self.reason = "Expected a shorter wait time";
            self.cancelRide()
            
        }
        
        let action4: UIAlertAction = UIAlertAction(title: r5, style: .default) { action -> Void in
            
            self.reason = "My reason is not installed";
            self.cancelRide()
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: r6, style: .cancel) { action -> Void in
            
            //Just dismiss the action sheet
        }
        
        actionSheetController.addAction(action0)
        actionSheetController.addAction(action1)
        actionSheetController.addAction(action2)
        actionSheetController.addAction(action3)
        actionSheetController.addAction(action4)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func tapShare(_ sender: Any) {
        
        
        var text = (USER_DEFAULT.object(forKey: "user_name") as! String) + " shared ride status: http://taxiappsourcecode.com/track/785hjtli\n" + "Driver: " + lbl_driverName.text! + "\n" + "Contact no: " + dvrPhone + "\n " + "Booiking : " + AppDelegateVariable.appDelegate.id_booking +   "\nTaxi no: " + lbl_car_number.text!;
        // let text = "Driver Name : "+lbl_driverName.text! + "\nCar No."+lbl_car_number.text!
        
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
            
            text = (USER_DEFAULT.object(forKey: "user_name") as! String) + " حصة ركوب الحالة : http://taxiappsourcecode.com/track/785hjtli\n" + "السائق : " + lbl_driverName.text! + "\n" + "رقم الاتصال : " + dvrPhone + "\n " + "الحجز : " + AppDelegateVariable.appDelegate.id_booking +   "\n  تيكسي نو: " + lbl_car_number.text!;
        }
        
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func tapLiveCamera(_ sender: Any) {
        
        // let callClient : SINCallClient = client!.call()
        
        let call : SINCall =  (client?.call().callUserVideo(withId: String (format: "driver_%@",self.driverName)))!
        
        let strory : UIStoryboard  = UIStoryboard.init(name: "Main", bundle: Bundle .main )
        
        let callCon : CallViewController = strory.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
        callCon.call = call
        callCon.client = client
        
        self.present(callCon, animated: true, completion: nil)
    }
    
    @IBAction func tapMore(_ sender: Any) {
        
    }
    
    // MARK: - Perform APIs
    // MARK:
    
    func getBockingDetail()
    {
        let dic = NSMutableDictionary()
        
        dic.setValue(AppDelegateVariable.appDelegate.id_booking, forKey: "booking_id")
        
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

                
                self.id_driver = (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "assigned_for")) as! CVarArg)) as String
                
                if self.forRefresh == true
                {
                    self.forRefresh = false

                    let lat_drop = String (format: "%@", (dicResult.value(forKey: "drop_lat") as? String)! )
                    let long_drop = String (format: "%@", (dicResult.value(forKey: "drop_long") as? String)! )
                    
                    self.lblDestinationAddress.text = dicResult.value(forKey: "drop_area") as? String
                    self.btnRefresh.isHidden = true
                    
                    self.cordinateDestination = DLRadioButton.cordinate(fromLat: lat_drop, long: long_drop) as CLLocationCoordinate2D
                    
                    let marker_dest = GMSMarker()
                    marker_dest.position = self.cordinateDestination
                    //marker_dest.title = self.lblPickAddressAr.text
                    marker_dest.map = self.mapView
                    marker_dest.icon = #imageLiteral(resourceName: "markerDesitnation")
                    
                    self.bounds = self.bounds.includingCoordinate(self.cordinateDestination)
                    
                    self.mapView.animate(with: GMSCameraUpdate.fit(self.bounds, withPadding: 50))
                }
                else
                {
                    if self.is_complete == true
                    {
                        self.lbl_carType.text =  (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "taxi_type")) as! CVarArg)) as String
                        
                        self.lbl_pickAddress.text =  (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "pickup_area")) as! CVarArg)) as String
                        
                        self.lbl_dropAddress.text = (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "drop_area")) as! CVarArg)) as String
                        
                        if AppDelegateVariable.appDelegate.strLanguage == "en"
                        {
                            self.lbl_Amount.text = (String(format: "%@ %@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "amount")) as! CVarArg, ENGLISH_AMOUNT_SBL)) as String
                            
                            self.total_amout =  (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "amount")) as! CVarArg)) as String
                        }
                        else
                        {
                            self.lbl_Amount.text = (String(format: "%@ %@",ARABIC_AMOUNT_SBL, (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "amount")) as! CVarArg)) as String
                            
                            self.total_amout =  (String(format: "%@", (((dataDictionary.object(forKey: "result") as! NSArray) .object(at: 0) as! NSDictionary ) .object(forKey: "amount")) as! CVarArg)) as String
                        }
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            
                            self.view.addSubview(self.viewBIll)
                            self.viewBIll.frame = CGRect(x: 0, y: 64, width: Constant.ScreenSize.SCREEN_WIDTH, height: Constant.ScreenSize.SCREEN_HEIGHT-64)
                        })
                        
                    }
                    else
                    {
                        self.perform(#selector(self.getDriverDetail), with: "", afterDelay: 0)
                        self.getDriverRating()
                        
                    }
                }
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func cancelRide()
    {
        let dic = NSMutableDictionary()
        
        dic .setValue(self.reason, forKey: "reason_to_cancel")
        dic .setValue(id_booking, forKey: "booking_id")
        dic .setValue(USER_NAME, forKey: "rider_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString = String(format : "cancel_booking_by_rider")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
            // println("\(key) -> \(value)")
        }
        
        // booking_id, rider_id=username, reason_to_cancel
        // http://taxiappsourcecode.com/api/index.php?option=
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                AppDelegateVariable.appDelegate.id_booking = "false";
                self.dismiss(animated: true, completion: nil);
                RappleActivityIndicatorView.stopAnimation()
                
                
                //                let actionSheetController: UIAlertController = UIAlertController(title: "Success", message: "Ride Successfully Cancel", preferredStyle: .alert)
                //
                //                let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                //
                //                    self.navigationController?.popViewController(animated: true)
                //                }
                
                //  actionSheetController.addAction(yesAction)
                //  self.present(actionSheetController, animated: true, completion: nil)
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
        
    }
    
    
    func getDriverDetail()
    {
        
        let dic = NSMutableDictionary()
        
        dic .setValue("driver", forKey: "usertype")
        dic .setValue(id_driver, forKey: "id")
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_user_profile")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            RappleActivityIndicatorView.stopAnimation()
            
            if self.is_Ride_Start == false
            {
                self.perform(#selector(self.getDriverDetail), with: "", afterDelay: 2)
            }
            
            if status == true
            {
                print(dataDictionary);
                
                if (self.is_fill == false)
                {
                    self.is_fill = true
                    self.viewDriverDetail.isHidden = false
                    
                    var userDict = (dataDictionary.object(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    userDict = AppDelegateVariable.appDelegate.convertAllDictionaryValueToNil(userDict)
                    
                    self.lblCarType_bill.text = userDict.object(forKey: "car_type") as? String
                    self.dvrPhone = (userDict.object(forKey: "phone") as? String)!
                    
                    self.driverName = (userDict.object(forKey: "user_name") as? String)!
                    
                    if AppDelegateVariable.appDelegate.strLanguage == "ar"
                    {
                        self.lbl_driverNameAr.text = userDict.object(forKey: "user_name") as? String
                        self.lbl_car_numberAr.text = userDict.object(forKey: "car_no") as? String
                        self.lbl_carTypeAr.text =  userDict.object(forKey: "car_type") as? String
                    }
                    else
                    {
                        self.lbl_driverName.text = userDict.object(forKey: "user_name") as? String
                        self.lbl_car_number.text = userDict.object(forKey: "car_no") as? String
                        self.lbl_carType.text =  userDict.object(forKey: "car_type") as? String
                    }
                }
                
                let lat = ( dataDictionary.object(forKey: "result")as! NSDictionary) .object(forKey: "latitude") as! String
                let lon = ( dataDictionary.object(forKey: "result") as! NSDictionary) .object(forKey: "longitude") as! String
                
                var cordinate = CLLocationCoordinate2D ()
                cordinate.latitude = (lat as NSString).doubleValue
                cordinate.longitude = (lon as NSString).doubleValue
                
                self.getPolylineRoute(from: self.cordinatePick, to: cordinate)
                
                self.getHeadingForDirection(fromCoordinate: self.driverMaker.position, toCoordinate: cordinate, marker: self.driverMaker)
                
                self.driverMaker.position = cordinate
                self.driverMaker.map = self.mapView
                
                self.driverMaker.icon = Utility.sharedInstance.get_car_icon(car_type: self.lbl_carType.text!)
                
                if (self.is_pathed == true)
                {
                    for index in 1...Int((self.path.count()))
                    {
                        self.bounds = self.bounds.includingCoordinate((self.path.coordinate(at: UInt(index))))
                    }
                }
                self.bounds = self.bounds.includingCoordinate(cordinate)
                // self.mapView.animate(with: GMSCameraUpdate.fit(self.bounds, withPadding: 100))
                
            }
            else
            {
              //  Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func sendPushNotification(title:String, message:String, fcmID: String)
    {
        
        let dic = NSMutableDictionary()
        
        dic.setValue("driver", forKey: "device_id")
        dic.setValue(id_driver, forKey: "message")
        dic.setValue(id_driver, forKey: "Title")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "push_notification")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                
                let actionSheetController: UIAlertController = UIAlertController(title: "Success", message: "Ride Successfully Cancel", preferredStyle: .alert)
                
                let yesAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
                actionSheetController.addAction(yesAction)
                self.present(actionSheetController, animated: true, completion: nil)
                
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
        
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        
        Alamofire.request(url.absoluteString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            do {
                
                if (response.result.value != nil)
                {
                    let routes = (response.result.value as AnyObject).object(forKey: "routes")  as? [Any]
                    
                    if (routes?.count)! > 0
                        
                    {
                        let overview_polyline : NSDictionary = (routes?[0] as? NSDictionary)!
                        
                        let dic : NSDictionary = overview_polyline as Any as! NSDictionary
                        
                        if (dic.count > 0)
                        {
                            let estTime =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                                .object(forKey: "duration") ) as! NSDictionary) .object(forKey: "text") as? String
                            self.lblTime.text = estTime;
                            
                            let dropAddress : String =  (((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                                .object(forKey: "start_address")) as? String)!
                            
                            self.addressDrop = dropAddress
                            
                            if (self.is_path == true)
                            {
                                let value : NSDictionary = dic.object(forKey: "overview_polyline") as! NSDictionary
                                let polyString : String = value.object(forKey: "points") as! String
                                self.is_path = false
                                self.showPath(polyStr: polyString)
                                
                            }
                        }
                    }
                    
                    if (self.is_Ride_Start == true)
                    {
                        self.perform(#selector(self.startRide), with: "", afterDelay: 1)
                        
                        self.getHeadingForDirection(fromCoordinate: self.driverMaker.position, toCoordinate: (self.locationManager.location!.coordinate), marker: self.driverMaker)
                        
                        self.driverMaker.position = (self.locationManager.location!.coordinate)
                        self.driverMaker.map = self.mapView
                        
                    }
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
    }
    
    func startRide()
    {
        if AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            lbltitle.text = "On Trip"
        }
        else
        {
            lbltitle.text = "في رحلة"
        }
        
        self.getPolylineRoute(from:(self.locationManager.location!.coordinate), to: cordinateDestination)
    }
    
    
    func showPath(polyStr :String)
    {
        path = GMSPath(fromEncodedPath: polyStr)!
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = #colorLiteral(red: 0.7661251426, green: 0.6599388719, blue: 0, alpha: 1)
        
        polyline.map = mapView
        
        var bounds = GMSCoordinateBounds()
        
        for index in 1...Int((path.count()))
            
        {
            bounds = bounds.includingCoordinate((path.coordinate(at: UInt(index))))
        }
        bounds = bounds.includingCoordinate(cordinatePick)
        bounds = bounds.includingCoordinate(cordinateDestination)
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100))
        
        self.is_pathed = true
        
        //self.tagBookNow = 2
    }
    
    func getTopViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while (topController.presentedViewController != nil)
            {
                topController = topController.presentedViewController!
            }
            return topController
        }
        return nil
    }
    
    // MARK: Other Usable Methods
    
    func markerIconView() -> UIView {
        
        let viewAnot : UIView = UIView(frame: CGRect(x:Constant.ScreenSize.SCREEN_WIDTH/2-40, y: Constant.ScreenSize.SCREEN_HEIGHT/2-60, width: 80, height: 60))
        viewAnot.backgroundColor = UIColor.clear
        
        let img : UIImageView = UIImageView(frame: CGRect(x:0, y: 0, width: 80, height: 60))
        img.image = #imageLiteral(resourceName: "markerLocation")
        img.contentMode = UIViewContentMode.scaleAspectFit
        viewAnot.addSubview(img)
        
        lblTime = UILabel(frame: CGRect(x:0, y: 0, width: 80, height: 30))
        lblTime.textAlignment = .center
        lblTime.text =  "time"
        lblTime.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lblTime.font = UIFont .systemFont(ofSize: 11)
        
        viewAnot .addSubview(lblTime);
        
        lblTime.layer.cornerRadius = 15;
        lblTime.clipsToBounds = true
        lblTime.layer.borderWidth = 0.8
        lblTime.layer.borderColor = UIColor.white.cgColor
        lblTime.backgroundColor = UIColor.black
        
        return viewAnot
    }
    
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D , marker : GMSMarker)
    {
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        
        if degree >= 0
        {
            marker.rotation = CLLocationDegrees(degree)
            
            CATransaction.begin()
            CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
            
            marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            CATransaction.commit()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
        
        // self.delegate?.gotNotification(title: notification.request.content.title);
        // let title : String = notification.request.content.title
        
        let title : String =  (notification.request.content.userInfo as NSDictionary ) .object(forKey: "gcm.notification.title1") as! String
        
        if (title == "cancel_by_driver")
        {
            AppDelegateVariable.appDelegate.id_booking = "cancel";
            self.dismiss(animated: true, completion: nil)
            client?.stop()
        }
        
        if (title == "arrived_driver")
        {
            self.playAudio()
        }
        
        if (title == "start_ride")
        {
            self.is_path = true
            self.is_Ride_Start = true
            self.getPolylineRoute(from: cordinatePick, to: cordinateDestination)
        }
        
        if (title == "end_ride")
        {
            let dic = NSMutableDictionary()
            dic .setValue(id_booking, forKey: "booking_id")
            dic .setValue(id_driver, forKey: "driver_id")
            
            USER_DEFAULT .set(dic, forKey: "ratedata")
            USER_DEFAULT .set("1", forKey: "rateOne")
            self.is_complete = true
            self.is_Ride_Start = false
            self.getBockingDetail()
            lbltitle.text = "Your Bill"
            
            if AppDelegateVariable.appDelegate.strLanguage == "ar"
            {
                lbltitle.text = "فاتورتك";
            }
            client?.stop()
        }
    }
    
    @IBAction func tapButtonOk(_ sender: Any)
    {
        //  http://taxiappsourcecode.com/api/index.php?option=add_booking_review
        
        //  booking_id=, review_by= Driver/Rider, rider_id=scientificwebs, driver_id, rating= 1 to 5 [ 1 or 2 or 3 or 4 or 5 ], review_text
        
        if (rating.rating > 0)
        {
            self.sendFeedBack()
            //          self.perform(#selector(pay), with: "", afterDelay: 0)
        }
        else
        {
            Utility.sharedInstance.showAlert(kAPPName, msg: "Select Rating First" , controller: self)
        }
    }
    
    
    func sendFeedBack() {
        
        var strTitle, r1, r2, r3, r4, r5, r6 : String!
        if AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            strTitle = "Choose Rating Option"
            r1 = "Driver's behaviour is not good"
            r2 = "Driver is late"
            r3 = "Safe ride"
            r4 = "Reached on time"
            r5 = "Well driving skill"
            r6 = "Cancel"
        }else{
            strTitle = "اختر خيار التقييم"
            r1 = "سلوك السائق ليس جيدا"
            r2 = "السائق في وقت متأخر"
            r3 = "ركوب آمنة"
            r4 = "وصلت في الوقت المحدد"
            r5 = "سائق لديه مهارة القيادة بشكل جيد"
            r6 = "إلغاء"
        }
        
        let actionSheetController: UIAlertController = UIAlertController(title: strTitle, message: "", preferredStyle: .actionSheet)
        
        let action0: UIAlertAction = UIAlertAction(title: r1, style: .default) { action -> Void in
            
            self.reason = "Driver's behaviour is not good";
            self.sendFeedBackApi()
        }
        
        let action1: UIAlertAction = UIAlertAction(title: r2, style: .default) { action -> Void in
            
            self.reason = "Driver is late";
            self.sendFeedBackApi()
            
        }
        let action2: UIAlertAction = UIAlertAction(title: r3, style: .default) { action -> Void in
            
            self.reason = "Safe ride";
            self.sendFeedBackApi()
            
        }
        let action3: UIAlertAction = UIAlertAction(title: r4, style: .default) { action -> Void in
            
            self.reason = "Reached on time";
            self.sendFeedBackApi()
            
        }
        
        let action4: UIAlertAction = UIAlertAction(title: r5, style: .default) { action -> Void in
            
            self.reason = "Well driving skill";
            self.sendFeedBackApi()
            
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: r6, style: .cancel) { action -> Void in
            
        }
        
        actionSheetController.addAction(action0)
        actionSheetController.addAction(action1)
        actionSheetController.addAction(action2)
        actionSheetController.addAction(action3)
        actionSheetController.addAction(action4)
        
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func sendFeedBackApi() {
        
        client?.stop()
        
        let dic = NSMutableDictionary()
        
        dic.setValue(AppDelegateVariable.appDelegate.id_booking as String, forKey: "booking_id")
        dic.setValue("Rider", forKey: "review_by")
        dic.setValue(id_driver, forKey: "driver_id")
        dic.setValue(USER_DEFAULT.object(forKey: "user_name"), forKey: "rider_id")
        dic.setValue(String (format: "%d",rating.rating), forKey: "rating")
        dic.setValue( self.reason, forKey: "review_text")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "add_booking_review")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                //iToast.makeText(" Review Completed ").show()
                
                AppDelegateVariable.appDelegate.id_booking = "false";
                
                USER_DEFAULT .set("0", forKey: "rateOne")
                
                
                var strMsg = "شكرا لركوب معنا"
                var okMsg  = "حسنا"
                if AppDelegateVariable.appDelegate.strLanguage == "en"
                {
                    strMsg = "Thanks for riding with us";
                    okMsg = "OK"
                }
                
                let actionSheetController: UIAlertController = UIAlertController(title: strMsg, message: "", preferredStyle: .actionSheet)
                
                let action0: UIAlertAction = UIAlertAction(title: okMsg, style: .default) { action -> Void in
                    
                    self.dismiss(animated: true, completion: {
                        
                    })
                }
                
                actionSheetController.addAction(action0)
                self.present(actionSheetController, animated: true, completion: nil)
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    
    func getDriverRating() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue("Driver", forKey: "review_by")
        dic.setValue(id_driver, forKey: "user_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_reviews")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                //iToast.makeText(" Review Completed ").show()
                RappleActivityIndicatorView.stopAnimation()
                
                RappleActivityIndicatorView.stopAnimation()
                let rate : NSString = NSString (format: "%@", dataDictionary .object(forKey: "rate_avg") as! CVarArg )
                
                if  UInt(Int(rate.intValue)) > 0
                {
                    if AppDelegateVariable.appDelegate.strLanguage == "ar"
                    {
                        self.driverRatingAr.rating = ( 5 - UInt(Int(rate.intValue)))
                    }
                    else
                    {
                        self.driverRating.rating =  UInt(Int(rate.intValue))
                    }
                }
                
            }
            else
            {
                //  Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    
    // MARK: Other Usable Methods
    
    func pay()
    {
        
        /*let item1 = PayPalItem(name: "Title", withQuantity: 1, withPrice: NSDecimalNumber(string:total_amout), withCurrency: "USD", withSku: "Hip-0037")
         let items = [item1]
         let subtotal = PayPalItem.totalPrice(forItems: items)
         
         // Optional: include payment details
         let shipping = NSDecimalNumber(string: "0.00")
         let tax = NSDecimalNumber(string: "0.00")
         let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
         
         let total = subtotal.adding(shipping).adding(tax)
         
         let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Tawsila", intent: .sale)
         
         payment.items = items
         payment.paymentDetails = paymentDetails
         
         if (payment.processable)
         {
         let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
         present(paymentViewController!, animated: true, completion: nil)
         }
         else {
         print("Payment not processalbe: \(payment)")
         }*/
    }
    
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        
        
        paymentViewController.dismiss(animated: true, completion: nil)
        
        Utility.sharedInstance.showAlert(kAPPName, msg: "Payment Unsucess", controller: self)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        
        self.sendFeedBack()
        
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("\(String(describing: completedPayment.softDescriptor))")
            //self.viewPaymentBG.isHidden = true
            // self.isWithdraw = true
            let dict_details = completedPayment.confirmation as NSDictionary
            print((dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String)
            
            //self.subscribeTheItemsPurchase(transIds: (dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String)
        })
    }
    
    func playAudio()
    {
        let urlAudio = Bundle.main.url(forResource: "driver_arrived_sound", withExtension: "mp3")
        let sound = Sound(url: urlAudio!)
        sound?.play()
    }
    
    // MARK: Sinch Delgates
    
    func clientDidStart(_ client: SINClient!) {
        
    }
    func clientDidStop(_ client: SINClient!) {
        
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        
    }
    
    // MARK: Destination Selction
    
    @IBAction func tapSelectDestination(_ sender: Any)
    {
        acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        // let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 10.0)
        
        // mapView.camera = camera
        
        cordinateDestination = place.coordinate
        lblDestinationAddress.text = place.formattedAddress!
        
        let marker_dest = GMSMarker()
        marker_dest.position = self.cordinateDestination
        //marker_dest.title = self.lblPickAddressAr.text
        marker_dest.map = self.mapView
        marker_dest.icon = #imageLiteral(resourceName: "markerDesitnation")
        
        self.bounds = self.bounds.includingCoordinate(cordinateDestination)

        self.mapView.animate(with: GMSCameraUpdate.fit(self.bounds, withPadding: 50))
        
        self.updateDestinatinApi()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
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
        isDestination = true
        
        dic.setValue(String (format: "%f", cordinateDestination.latitude), forKey: "drop_lat")
        dic.setValue(String (format: "%f", cordinateDestination.longitude), forKey: "drop_long")
        dic.setValue(lblDestinationAddress.text, forKey: "drop_area")
        dic.setValue("10", forKey: "amount")
        dic.setValue("10", forKey: "distance")
        dic.setValue(AppDelegateVariable.appDelegate.id_booking, forKey: "booking_id")
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "update_booking_details")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                RappleActivityIndicatorView.stopAnimation()
            }
            else
            {
                // Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    @IBAction func tapRefresh(_ sender: Any)
    {
       forRefresh = true
        self.getBockingDetail()
    }
}

