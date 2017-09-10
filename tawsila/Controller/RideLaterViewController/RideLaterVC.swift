//
//  RideLaterVC.swift
//  Tawsila
//
//  Created by Sanjay on 11/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import RappleProgressHUD

class RideLaterVC: UIViewController ,GMSMapViewDelegate , GMSAutocompleteViewControllerDelegate
{
    var viewDatePicker : UIView!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var pickDate: UITextField!
    @IBOutlet var pickTime: UITextField!
    
    var acController = GMSAutocompleteViewController()
    
    var temp : Int!
    var tempLoc : Int!
    
    @IBOutlet var viewEstimateFare: UIView!
    
    @IBOutlet var lblEstimateFare: UILabel!
    @IBOutlet var imgLocation: UIImageView!
    @IBOutlet var imgDest: UIImageView!
    @IBOutlet var btnSchduleRide: UIButton!
    
    var pickUpAddress = String ()
    var car_type = String()
    var rateInitial = String()
    var rateStandred = String()
    
    
    @IBOutlet var lblDestination: UILabel!
    @IBOutlet var lblLocatoin: UILabel!
    
    var pickUpCordinate : CLLocationCoordinate2D!
    var destinationCordinate : CLLocationCoordinate2D!
    
    
    var popUpSchedule = scheduleView()
    
    var estFare = Int()
    var estTime = String()
    
    var initialRate = String()
    var standredRate = String()
    var distanceFare = String()
    
    @IBOutlet var viewDestinatin: UIView!
    @IBOutlet var viewLocation: UIView!
    @IBOutlet var lblActual: UILabel!
    
    @IBOutlet var lblFare: UILabel!
    
    
    
    @IBOutlet var btnBackAr: UIButton!
    
    @IBOutlet var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgDest.tintColor = UIColor.red
        imgDest.image = imgDest.image?.withRenderingMode(.alwaysTemplate)
        
        imgLocation.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        imgLocation.image = imgDest.image?.withRenderingMode(.alwaysTemplate)
        
        btnSchduleRide.layer.cornerRadius = 3;
        
        lblLocatoin.text = pickUpAddress
        
        viewEstimateFare.isHidden = true
        viewEstimateFare.layer.borderColor = UIColor.lightGray.cgColor
        viewEstimateFare.layer.borderWidth = 0.5
        
        self.getCabData()
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
            
            
            viewLocation.frame = CGRect(x: self.view.frame.size.width/2 , y: Constant.ScreenSize.SCREEN_WIDTH/2 , width: viewLocation.bounds.width, height: viewLocation.bounds.height)
            
            viewDestinatin.frame = CGRect(x: 0, y: Constant.ScreenSize.SCREEN_WIDTH/2 , width: viewLocation.bounds.width, height: viewLocation.bounds.height)
            
            btnSchduleRide .setTitle("ركوب الجدول الزمني", for: .normal)
            
            lblActual.text = "تقدير الفعلية التي يتعين توفيرها قبل التقاط"
            
            lblLocatoin.text = "موقعك"
            lblDestination.text = "حدد وجهتك"
            pickDate.text = "اختيار التاريخ"
            pickTime.text = "اختيار الوقت"

            lblFare.text = "تقدير الأجرة"
            
            btnBack.isHidden = true
            btnBackAr.isHidden = false
            lblTitle.text = "ركوب في وقت لاحق"
        }
        
        lblLocatoin.text = pickUpAddress
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBack(_ sender: Any) {
        
        actionBackButton(sender)
    }
    
    
    @IBAction func tapPickDate(_ sender: UIButton)
    {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = THEME_COLOR
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RideLaterVC.donePicker))
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RideLaterVC.donePicker))
        
        
        
        toolBar.setItems([cancelButton, spaceButton ,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        if sender.tag == 1
        {
            pickTime.inputView = datePickerView
            pickTime.inputAccessoryView = toolBar
            pickTime .becomeFirstResponder()
            datePickerView.datePickerMode = UIDatePickerMode.time
            temp = 0;
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH : mm a"
            pickTime.text = dateFormatter.string(from:NSDate() as Date)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            pickDate.text = dateFormatter.string(from:NSDate() as Date)
            pickDate.inputView = datePickerView
            pickDate.inputAccessoryView = toolBar
            pickDate .becomeFirstResponder()
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            temp = 1;
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        if temp == 1
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/mm/yyyy"
            pickDate.text = dateFormatter.string(from:sender.date as Date)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH : mm"
            pickTime.text = dateFormatter.string(from:sender.date as Date)
        }
        
        // dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    func donePicker()
    {
        pickDate.resignFirstResponder()
        pickTime.resignFirstResponder()
    }
    
    func tapDone(){
        
        UIView.animate(withDuration: 0.2) {
            
            self.viewDatePicker.frame = CGRect(x: 0, y: Constant.ScreenSize.SCREEN_HEIGHT, width: Constant.ScreenSize.SCREEN_WIDTH, height: 200)
        }
    }
    
    @IBAction func tapPickTime(_ sender: Any) {
    }
    
    @IBAction func tapLocation(_ sender: Any)
    {
        acController = GMSAutocompleteViewController()
        present(acController, animated: true, completion: nil)
        acController.delegate = self
        tempLoc = 1
    }
    
    @IBAction func tapDestination(_ sender: Any) {
        
        acController = GMSAutocompleteViewController()
        present(acController, animated: true, completion: nil)
        acController.delegate = self
        tempLoc = 2
    }
    
    @IBAction func tapScheduleRide(_ sender: Any)
    {
        var msg : String!
        
        if pickDate.text == "Pick Date" || pickDate.text == "اختيار التاريخ" {
            
            if AppDelegateVariable.appDelegate.strLanguage == "ar"
            {
                msg = "حدد التاريخ أولا"
            }
            else
            {
                msg = "Select Date First"
            }
            
            Utility.sharedInstance.showAlert(kAPPName, msg: msg , controller: self)
            
            return;
        }
        
        if pickTime.text == "Pick Time" || pickTime.text == "اختيار الوقت" {
            
            if AppDelegateVariable.appDelegate.strLanguage == "ar"
            {
                msg = "حدد تايم فيرست"
            }
            else
            {
                msg = "Select Time First"
            }
            
            Utility.sharedInstance.showAlert(kAPPName, msg: msg , controller: self)
            
            return;
        }
        
        if lblDestination.text == "Select Destination" || lblDestination.text == "حدد وجهتك" {
            
            if AppDelegateVariable.appDelegate.strLanguage == "ar"
            {
                msg = "حدد الوجهة لوكاتوان أولا"
            }
            else
            {
                msg = "Select Destination Locatoin First"
            }
            
            Utility.sharedInstance.showAlert(kAPPName, msg: msg , controller: self)
            
            return;
        }
        
        if lblLocatoin.text == "Pickup Location" || lblLocatoin.text == "موقعك" {
            
            if AppDelegateVariable.appDelegate.strLanguage == "ar"
            {
                msg = "حدد بيك أب لوكاتيون فيرست"
            }
            else
            {
                msg =  "Select Pickup Location First"
            }
            
            Utility.sharedInstance.showAlert(kAPPName, msg: msg , controller: self)
            
            return;
        }
        
        
        self.FireAPI()
    }
    
    func FireAPI()
    {
        
        let random : String = "24324323"
        let dic = NSMutableDictionary()
        
        dic.setValue(USER_NAME, forKey: "username")
        dic.setValue("PTPT", forKey: "purpose")
        dic.setValue(lblLocatoin.text, forKey: "pickup_area")
        dic.setValue(pickDate.text, forKey: "pickup_date")
        dic.setValue(pickTime.text, forKey: "pickup_time")
        dic.setValue(lblDestination.text, forKey: "drop_area")
        
        dic.setValue(lblLocatoin.text, forKey: "pickup_address")
        dic.setValue(self.car_type, forKey: "taxi_type")
        
        dic.setValue("15", forKey: "distance")
        dic.setValue(String (format: "%d",estFare), forKey: "amount")
        dic.setValue("jaipur", forKey: "address")
        dic.setValue("cash", forKey: "payment_media")
        dic.setValue(self.distanceFare, forKey: "km")
        dic.setValue(String (format: "%f", pickUpCordinate.latitude), forKey: "lat")
        dic.setValue(String (format: "%f", pickUpCordinate.longitude), forKey: "long")
        dic.setValue(random, forKey: "random")
        dic.setValue(FCM_TOKEN, forKey: "device_id")
        
        dic.setValue("", forKey: "area")
        //dic.setValue("", forKey: "landmark")
        //dic.setValue("", forKey: "departure_time")
        //dic.setValue("", forKey: "departure_date")
        //dic.setValue("", forKey: "flight_number")
        //dic.setValue("", forKey: "package")
        //dic.setValue("", forKey: "promo_code")
        dic.setValue("PTPT", forKey: "transfer")
        dic.setValue(String (format: "%f", (pickUpCordinate.latitude)), forKey: "pickup_lat")
        dic.setValue(String (format: "%f", (pickUpCordinate.longitude)), forKey: "pickup_long")
        
        dic.setValue(String (format: "%f", (destinationCordinate.latitude)), forKey: "drop_lat")
        dic.setValue(String (format: "%f", (destinationCordinate.longitude)), forKey: "drop_long")
        
        // http://taxiappsourcecode.com/api/index.php?
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString = String(format : "booking_request_schedule")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInJson(header: parameterString,  withParameter:dic ,inVC: self) { (dataDictionary, msg, status) in
            
            if msg == "Booking scheduled"
            {
                self.confirmPopup()
            }
            
            if status == true
            {
                var userDict = (dataDictionary.object(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                userDict = AppDelegateVariable.appDelegate.convertAllDictionaryValueToNil(userDict)
            }
            else
            {
                //   Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    func confirmPopup()  {
        
        popUpSchedule = Bundle.main.loadNibNamed("scheduleView", owner: self, options: nil)![0] as? UIView as! scheduleView
        popUpSchedule.frame = self.view.frame
        self.view.addSubview(popUpSchedule)
        
        popUpSchedule.lblPickUPDate.text = self.pickDate.text
        popUpSchedule.lblPickUpTime.text = self.pickTime.text
        popUpSchedule.lblDropLocation.text = self.lblDestination.text
        
        popUpSchedule.lblPickUPDateAr.text = self.pickDate.text
        popUpSchedule.lblPickUpTimeAr.text = self.pickTime.text
        popUpSchedule.lblDropLocationAr.text = self.lblDestination.text
        
        popUpSchedule.lblEstimateFair.text = self.lblEstimateFare.text
        popUpSchedule.lblEstimateFairAr.text = self.lblEstimateFare.text

        popUpSchedule.btnConfirm.addTarget(self, action: #selector(self.tapConfirm), for: .touchUpInside)
        popUpSchedule.btnComfirmAr.addTarget(self, action: #selector(self.tapConfirm), for: .touchUpInside)
        
        self.pickTime.text = "Pick Time"
        self.pickDate.text = "Pick Date"
        self.lblLocatoin.text = "Pickup Location"
        self.lblDestination.text = "Select Destination"
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
            
            btnSchduleRide .setTitle("ركوب الجدول الزمني", for: .normal)
            lblActual.text = "تقدير الفعلية التي يتعين توفيرها قبل التقاط"
            lblLocatoin.text = "موقعك"
            lblDestination.text = "حدد وجهتك"
            pickDate.text = "اختيار التاريخ"
            pickTime.text = "اختيار الوقت"
            
        }
        
        
        destinationCordinate = nil
        pickUpCordinate = nil
        
    }
    
    func tapConfirm()
    {
        viewEstimateFare.isHidden = true
        self.popUpSchedule.removeFromSuperview()
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
            
            Utility.sharedInstance.showAlert("شكرا", msg: "جدول الرحلات بنجاح", controller: self)
        }
        else
        {
            Utility.sharedInstance.showAlert("Thank you", msg: "Your Ride Successfully Schedule", controller: self)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        
        print("Place name: \(place.name)")

        dismiss(animated: true, completion: nil)
        
        if tempLoc == 1
        {
            pickUpCordinate = place.coordinate
            lblLocatoin.text = place.formattedAddress
            
            if (destinationCordinate != nil )
            {
                self.getPolylineRoute(from: pickUpCordinate, to: destinationCordinate)
            }
        }
        else
        {
            if pickUpCordinate != nil
            {
                destinationCordinate = place.coordinate
                lblDestination.text = place.formattedAddress
                self.getPolylineRoute(from: pickUpCordinate, to: destinationCordinate)
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        
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
                        
                        // let value : NSDictionary = dic.object(forKey: "overview_polyline") as! NSDictionary
                        
                        self.estTime =  ((((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                            .object(forKey: "duration") ) as! NSDictionary) .object(forKey: "text") as? String)!
                        
                        let estDistance : String =  ((((((dic.object(forKey: "legs") as! NSArray) .object(at: 0) ) as AnyObject)
                            .object(forKey: "distance") ) as! NSDictionary) .object(forKey: "text") as? String)!
                        
                        self.distanceFare  = estDistance
                        let doubleValue : Double = NSString(string: estDistance).doubleValue // 3.1
                        
                        self.estFare = Int(Int((self.rateStandred as NSString).floatValue + (self.rateInitial as NSString).floatValue * Float32(doubleValue)))
                        
                        self.lblEstimateFare.text =  String (format: "%d %@", self.estFare ,ENGLISH_AMOUNT_SBL)
                        
                        
                        if AppDelegateVariable.appDelegate.strLanguage == "ar" {
                            
                            self.lblEstimateFare.text =  String (format: "%d %@", self.estFare ,ARABIC_AMOUNT_SBL)
                        }
                        
                        self.viewEstimateFare.isHidden = false
                        
                    }
                    else
                    {
                        //                        self.tagBookNow = 2
                        //                        self.lblEstimatedFare.text = "500"
                        //                        self.lblEstimatedTime.text = "45 min"
                        // self.estFare = 500
                    }
                }
            }
            catch
            {
                print("error in JSONSerialization")
            }
        }
    }
    
    
    func getCabData()
    {
        let dic = NSMutableDictionary()
        
        dic.setValue(car_type, forKey: "cartype")
        
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
                
                self.rateInitial = NSString (format:"%@",dicResult .value(forKey: "intailrate") as! CVarArg ) as String
                self.rateStandred = NSString (format:"%@",dicResult .value(forKey: "standardrate") as! CVarArg ) as String
                
                //  ":"49","":"145
                //   self.text_type =
            }
            else
            {
                //Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
}


