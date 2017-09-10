//
//  MyRidesTableViewCell.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/13/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class MyRidesTableViewCell: UITableViewCell {

    // View english 
    @IBOutlet var viewEnglish: UIView!
    @IBOutlet var lblDateTime: UILabel!
    @IBOutlet var lblPrcie: UILabel!
    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblInitialAddress: UILabel!
    @IBOutlet var lblDestinationAddress: UILabel!
    @IBOutlet var imgShowStatus: UIImageView!
    @IBOutlet var imgCarType: UIImageView!
    // view Arabic
    @IBOutlet var viewAraic: UIView!
    @IBOutlet var lblDateTimeAr: UILabel!
    @IBOutlet var lblPrcieAr: UILabel!
    @IBOutlet var imgUserProfileAr: UIImageView!
    @IBOutlet var lblCarModelAr: UILabel!
    @IBOutlet var lblInitialAddressAr: UILabel!
    @IBOutlet var lblDestinationAddressAr: UILabel!
    @IBOutlet var imgShowStatusAr: UIImageView!
    @IBOutlet var imgCarTypeAr: UIImageView!
    
    @IBOutlet var lblStatusArs: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.height/2
        imgUserProfile.layer.masksToBounds = true
        
        imgUserProfileAr.layer.cornerRadius = imgUserProfileAr.frame.size.height/2
        imgUserProfileAr.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataInCell(_ dic: NSDictionary) -> Void {
        if AppDelegateVariable.appDelegate.strLanguage == "en"{
              self.imgCarType.sd_setImage(with: URL.init(string: (dic.value(forKey: "car_image")   as! String)))
            lblInitialAddress.text = (dic.value(forKey: "pickup_area")  as!  String)
            lblDestinationAddress.text = (dic.value(forKey: "drop_area")  as!  String)
            lblDateTime.text = "\(dic.value(forKey: "pickup_date")  as!  String)"+" "+"\(dic.value(forKey: "pickup_time")  as!  String)"
            lblCarModel.text = "\(dic.value(forKey: "taxi_type")  as!  String)"+"     "+"CRN- \(dic.value(forKey: "id")  as!  String)"

            
            if ((dic.value(forKey: "status")  as! String == "Processing")||(dic.value(forKey: "status")  as! String == "Booking")) {
                imgShowStatus.image = UIImage.init(named: "ontheway")
                imgUserProfile.isHidden = false
                lblPrcie.isHidden = false
            }
            else if (dic.value(forKey: "status")  as! String == "Cancelled"){
                 imgShowStatus.image = UIImage.init(named: "cancelled")
                imgUserProfile.isHidden = true
                lblPrcie.isHidden = true
            }
            else if (dic.value(forKey: "status")  as! String == "Completed") {
                imgShowStatus.image = UIImage.init(named: "completed")
                imgUserProfile.isHidden = false
                lblPrcie.isHidden = false
            }
            else if (dic.value(forKey: "status")  as! String == "Scheduled") {
                imgShowStatus.image = UIImage.init(named: "scheduled_icon")
                imgUserProfile.isHidden = true
                lblPrcie.isHidden = false
            }
            
            lblPrcie.text = "\(dic.value(forKey: "amount")  as!  String) "+ENGLISH_AMOUNT_SBL
        }
        else {
             self.imgCarTypeAr.sd_setImage(with: URL.init(string: (dic.value(forKey: "car_image")   as! String)))
            lblInitialAddressAr.text = (dic.value(forKey: "pickup_area")  as!  String)
            lblDestinationAddressAr.text = (dic.value(forKey: "drop_area")  as!  String)
            
            lblDateTimeAr.text = "\(dic.value(forKey: "pickup_date")  as!  String)"+" "+"\(dic.value(forKey: "pickup_time")  as!  String)"
            lblCarModelAr.text = "\(dic.value(forKey: "taxi_type")  as!  String)"+"     "+"CRN- \(dic.value(forKey: "id")  as!  String)"
            
            imgShowStatusAr.isHidden = true
            
        
            
            if (dic.value(forKey: "status")  as! String == "Processing") {
                //imgShowStatusAr.image = UIImage.init(named: "ontheway")
                lblStatusArs.text = "س\nن\nتي\nح\nالبريد\nث\nا\nذ"
                imgUserProfileAr.isHidden = false
                lblPrcieAr.isHidden = false
                lblStatusArs.backgroundColor = UIColor (colorLiteralRed: 250.0/255.0, green: 121.0/255.0, blue: 0.0, alpha: 1)

            }
            else if (dic.value(forKey: "status")  as! String == "Cancelled"){
               
                // imgShowStatusAr.image = UIImage.init(named: "cancelled")
               
                imgUserProfileAr.isHidden = true
                lblPrcieAr.isHidden = true
                lblStatusArs.text = "ج\nا\nن\nج\nالبر\nيد\nل\nل\nالبريد\nد"
                lblStatusArs.backgroundColor = UIColor (colorLiteralRed: 239.0/255.0, green: 0.0, blue: 0.0, alpha: 1)
            }
            else if (dic.value(forKey: "status")  as! String == "Completed") {

                lblStatusArs.text = "ج\nس\nم\nص\nل\nالبريد\nتي\nالبريد\nد"

//              imgShowStatusAr.image = UIImage.init(named: "completed")
                imgUserProfileAr.isHidden = false
                lblPrcieAr.isHidden = false
                
                lblStatusArs.backgroundColor = UIColor (colorLiteralRed: 0, green: 131.0/255.0, blue: 0.0, alpha: 1)
            }
            else
            {
                lblStatusArs.text = "الصو\nرة\nج\nح\nالبريد\nد\nش\nل\nالبريد\nد"
                
                imgUserProfileAr.isHidden = true
                lblPrcieAr.isHidden = false
                
                lblStatusArs.backgroundColor = UIColor (colorLiteralRed: 250.0/255.0, green: 121.0/255.0, blue: 0.0, alpha: 1)

            }
            
            lblPrcieAr.text = "\(dic.value(forKey: "amount")  as!  String) " + ARABIC_AMOUNT_SBL
        }
    }
}
