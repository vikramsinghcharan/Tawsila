//
//  AddwalletView.swift
//  Tawsila
//
//  Created by Sanjay on 19/07/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class AddwalletView: UIView {

    @IBOutlet var viewEnglish : UIView!
    @IBOutlet var btnAddNow: btnCustomeClass!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblAmountAdd: UILabel!
    
    
    @IBOutlet var viewArabic : UIView!
    @IBOutlet var btnAddNowAr: btnCustomeClass!
    @IBOutlet weak var txtAmountAr: UITextField!
    @IBOutlet weak var lblAmountAddAr: UILabel!
    
    override func draw(_ rect: CGRect) {
        
        setViewShowAndHideViews(viewEnglish, vArb: viewArabic)
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            txtAmount.leftViewMode = UITextFieldViewMode.always
            let img =  UIImageView.init(frame: CGRect(x: 2, y: 10, width: 20, height: txtAmount.frame.size.height-20))
            img.image = UIImage(named: "doller_icon")
            txtAmount.leftView = img
            
            lblAmountAdd.text = AppDelegateVariable.appDelegate.wallet_amount + " " + ENGLISH_AMOUNT_SBL
        }else{
            txtAmountAr.leftViewMode = UITextFieldViewMode.always
            let img =  UIImageView.init(frame: CGRect(x: 2, y: 10, width: 20, height: txtAmount.frame.size.height-20))
            img.image = UIImage(named: "doller_icon")
            txtAmountAr.rightView = img
            txtAmount.textAlignment = NSTextAlignment.right
            lblAmountAddAr.text = AppDelegateVariable.appDelegate.wallet_amount + " " + ARABIC_AMOUNT_SBL
        }
    }

    @IBAction func actionAmount(_ sender: UIButton) {
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
               txtAmount.text = sender.titleLabel?.text
        }else{
               txtAmountAr.text = sender.titleLabel?.text
        }
        
    }
    
    
    @IBAction func tapBack(_ sender: Any) {
        
        self.removeFromSuperview()
    }

}
