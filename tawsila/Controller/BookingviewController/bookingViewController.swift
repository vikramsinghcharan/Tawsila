//
//  bookingViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/15/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class bookingViewController: UIViewController {
    var dataDictionary, driverData: NSDictionary!
    //  View English
    @IBOutlet var viewEng: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var imgCancel: UIImageView!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var lblAmout: UILabel!
    @IBOutlet var lblHours: UILabel!
    @IBOutlet var lblMin: UILabel!
    @IBOutlet var lblInitialLocation: UILabel!
    @IBOutlet var lblDestinationLocation: UILabel!
    @IBOutlet var viewFare: UIView!
    @IBOutlet var lblRideFare: UILabel!
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var lblTotalBill: UILabel!
    // view Arabic
    @IBOutlet var viewArabic: UIView!
    @IBOutlet var lblUserNameAr: UILabel!
    @IBOutlet var userProfilePicAr: UIImageView!
    @IBOutlet var imgCancelAr: UIImageView!
    @IBOutlet var lblCarModelAr: UILabel!
    @IBOutlet var lblCarNumberAr: UILabel!
    @IBOutlet var lblAmoutAr: UILabel!
    @IBOutlet var lblHoursAr: UILabel!
    @IBOutlet var lblMinAr: UILabel!
    @IBOutlet var lblInitialLocationAr: UILabel!
    @IBOutlet var lblDestinationLocationAr: UILabel!
    @IBOutlet var viewFareAr: UIView!
    @IBOutlet var lblRideFareAr: UILabel!
    @IBOutlet var imgCarAr: UIImageView!
    @IBOutlet var lblTotalBillAr: UILabel!
    @IBOutlet weak var lblPaymentMediaAr: UILabel!
    @IBOutlet weak var lblPaymentMedia: UILabel!
    @IBOutlet var viewRatingAr: StarRatingControl!
    
    var bookingStatus = String()
    
    var id_driver = String()
    @IBOutlet var dvrRating: StarRatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEng, vArb: viewArabic)
       setDataOnViewController(dataDictionary)
     
    }
    
    func setDataOnViewController(_ dic: NSDictionary){
        print(dic)
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            self.imgCar.sd_setImage(with: URL.init(string: (dic.value(forKey: "car_image")   as! String)))
        }else{
            self.imgCarAr.sd_setImage(with: URL.init(string: (dic.value(forKey: "car_image")   as! String)))
        }
        if (dic.value(forKey: "status")  as! String == "Cancelled") {
            self.getBookingDetails()
            
            self.id_driver = dataDictionary.value(forKey: "assigned_for") as! String
            self.getDriverRating()
            
            if AppDelegateVariable.appDelegate.strLanguage == "en" {
                viewFare.isHidden = true
                imgCancel.isHidden = false
                dvrRating.isHidden = true
                lblMin.text = "0 min"
                
                lblAmout.text = "0 " + ENGLISH_AMOUNT_SBL
                lblHours.text = "\(dic.value(forKey: "km")  as! String)"+" mtr"
                lblInitialLocation.text = "\(dic.value(forKey: "pickup_area")  as! String)"
                lblDestinationLocation.text =  "\(dic.value(forKey: "drop_area")   as! String)"
           
            }
            else
            {
                viewFareAr.isHidden = true
                imgCancelAr.isHidden = false
                viewRatingAr.isHidden = true
                lblAmoutAr.text = "0 min"
                lblMinAr.text = "0 " + ARABIC_AMOUNT_SBL
                lblHoursAr.text = "\(dic.value(forKey: "km")  as! String)"
                lblInitialLocationAr.text = "\(dic.value(forKey: "pickup_area")  as! String)"
                lblDestinationLocationAr.text =  "\(dic.value(forKey: "drop_area")   as! String)"
            }
        }
        else  if (dic.value(forKey: "status")  as! String == "Scheduled") {
            
            if AppDelegateVariable.appDelegate.strLanguage == "en"
            {
                viewFare.isHidden = true
                imgCancel.isHidden = true
                lblAmout.text = "\(dic.value(forKey: "amount")  as! String ) " + ENGLISH_AMOUNT_SBL
                lblHours.text = "0 Min"
                lblInitialLocation.text = "\(dic.value(forKey: "pickup_area")  as! String)"
                lblDestinationLocation.text =  "\(dic.value(forKey: "drop_area")   as! String)"
                lblCarModel.text = "\(dic.value(forKey: "taxi_type")  as! String)" + "\n Detail will be shared before 15 min of pickup time "
                lblCarNumber.text = ""
                lblCarNumber.font = UIFont .systemFont(ofSize: 14)
                self.dvrRating.isHidden = true
                
                lblUserName.isHidden = true

            }
            else
            {
                viewRatingAr.isHidden = true
                viewFareAr.isHidden = true
                imgCancelAr.isHidden = true
                lblMinAr.text = "\(dic.value(forKey: "amount")  as! String ) " + ARABIC_AMOUNT_SBL
                lblHoursAr.text = "0 مينوت"

                lblInitialLocationAr.text = "\(dic.value(forKey: "pickup_area")  as! String)"
                lblDestinationLocationAr.text =  "\(dic.value(forKey: "drop_area")   as! String)"

                self.dvrRating.isHidden = true
                lblAmoutAr.isHidden = true
                lblCarModelAr.text = "\(dic.value(forKey: "taxi_type")  as! String)"
                
                lblCarNumberAr.text = "وسيتم تقاسم التفاصيل قبل 15 دقيقة من الوقت بيك اب"
                
                lblUserNameAr.isHidden = true
            }
        }
       
        else
        {
            
            self.id_driver = dataDictionary.value(forKey: "assigned_for") as! String
            self.getDriverRating()
            self.getBookingDetails()
            if AppDelegateVariable.appDelegate.strLanguage == "en"
            {
                viewFare.isHidden = false
                imgCancel.isHidden = true
                dvrRating.isHidden = false
                lblAmout.text = "\(dic.value(forKey: "amount")  as! String ) " + ENGLISH_AMOUNT_SBL
                lblHours.text = "\(dic.value(forKey: "distance")  as! String)" + " min"
                lblInitialLocation.text = "\(dic.value(forKey: "pickup_area")  as! String)"
                lblDestinationLocation.text =  "\(dic.value(forKey: "drop_area")   as! String)"
                lblRideFare.text = "\(dic.value(forKey: "drop_area")   as! String)"
                lblTotalBill.text = "\(dic.value(forKey: "amount")   as! String) " + ENGLISH_AMOUNT_SBL
                lblPaymentMedia.text = "\( dic.value(forKey: "payment_media")  as! String) Payment"
                lblRideFare.text = "\(dic.value(forKey: "amount")   as! String) " + ENGLISH_AMOUNT_SBL
                
                
                var srtKm = "\(dic.value(forKey: "km")  as! String)" + ""
                srtKm = srtKm.replacingOccurrences(of: "km", with: "")
                srtKm = srtKm.replacingOccurrences(of: "m", with: "")

                lblMin.text = srtKm + " min"


            }
            else
            {
                viewFareAr.isHidden = false
                imgCancelAr.isHidden = true
                viewRatingAr.isHidden = false
                lblMinAr.text = "\(dic.value(forKey: "amount")  as! String ) " + ARABIC_AMOUNT_SBL
                lblHoursAr.text = "\(dic.value(forKey: "distance")  as! String)" + " مينوت"
                lblInitialLocationAr.text = "\(dic.value(forKey: "pickup_area")  as! String)"
                lblDestinationLocationAr.text =  "\(dic.value(forKey: "drop_area")   as! String)"
                lblTotalBillAr.text = "\(dic.value(forKey: "amount")   as! String) " + ARABIC_AMOUNT_SBL
                lblRideFareAr.text = "\(dic.value(forKey: "amount")   as! String) " + ARABIC_AMOUNT_SBL
                lblPaymentMediaAr.text = "\( dic.value(forKey: "payment_media")  as! String)"

                var srtKm = "\(dic.value(forKey: "km")  as! String)" + ""
                srtKm = srtKm.replacingOccurrences(of: "km", with: "")
                srtKm = srtKm.replacingOccurrences(of: "m", with: "")
                
                lblAmoutAr.text = srtKm + " قلنسوة"

                
                if  ( dic.value(forKey: "payment_media")  as! String) == "cash"
                {
                    lblPaymentMediaAr.text = "تدفع نقدا"
                }else
                {
                    lblPaymentMediaAr.text = "تدفع عن طريق المحفظة"
                }
            }
        }      
    }
    
    func getBookingDetails() {
        
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
//        let parameterString = String(format : "get_booking_details&booking_id=%@",
//                                     self.dataDictionary.value(forKey: "id") as! String)
//        print(parameterString)
  
        let dic = NSMutableDictionary()
        
        dic .setValue("driver", forKey: "usertype")
        dic .setValue(dataDictionary.value(forKey: "assigned_for"), forKey: "id")
        
        // RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "get_user_profile")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        print(parameterString)
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                let userDict = dataDictionary.object(forKey: "result") as! NSDictionary
                print(userDict.count)
                print(userDict)
                if msg == "No record found"
                {
                    if AppDelegateVariable.appDelegate.strLanguage == "en" {

                        Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
                    }
                    else
                    {
                        Utility.sharedInstance.showAlert(kAPPName, msg: "لا يوجد سجلات", controller: self)
                    }
                }
                else
                {
                    if AppDelegateVariable.appDelegate.strLanguage == "en"{
                        self.lblUserName.text = userDict.value(forKey: "user_name") as? String
                        self.lblCarModel.text = userDict.value(forKey: "car_type") as? String
                        self.lblCarNumber.text = userDict.value(forKey: "car_no") as? String
                    }else{
                        self.lblUserNameAr.text = userDict.value(forKey: "user_name") as? String
                        self.lblCarModelAr.text = userDict.value(forKey: "car_type") as? String
                        self.lblCarNumberAr.text = userDict.value(forKey: "car_no") as? String
                    }
                }
            }
            else {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    
    
    //    Api- get_reviews
    //    Parameters- review_by=driver,  user_id
    
    
    func getDriverRating() {
        
        let dic = NSMutableDictionary()
        
        dic.setValue("Driver", forKey: "review_by")
        dic.setValue(dataDictionary.value(forKey: "assigned_for") as! String, forKey: "user_id")

        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
   
        var parameterString = String(format : "get_reviews")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                RappleActivityIndicatorView.stopAnimation()
                let rate : NSString = NSString (format: "%@", dataDictionary .object(forKey: "rate_avg") as! CVarArg )
                if  UInt(Int(rate.intValue)) > 0
                {
                    self.dvrRating.rating =  UInt(Int(rate.intValue))
                    self.viewRatingAr.rating = ( 5 - UInt(Int(rate.intValue)))
                }
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
}
