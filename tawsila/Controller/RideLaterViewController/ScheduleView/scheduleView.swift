//
//  scheduleView.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/19/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class scheduleView: UIView {

    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var lblDropLocation: UITextView!
    @IBOutlet weak var lblPickUPDate: UILabel!
    @IBOutlet weak var lblPickUpTime: UILabel!
    @IBOutlet weak var lblEstimateFair: UILabel!
    
    @IBOutlet weak var viewArabic: UIView!
    @IBOutlet weak var lblDropLocationAr: UILabel!
    @IBOutlet weak var lblPickUPDateAr: UILabel!
    @IBOutlet weak var lblPickUpTimeAr: UILabel!
    @IBOutlet weak var lblEstimateFairAr: UILabel!
    
    
    @IBOutlet var btnConfirm: btnCustomeClass!
    @IBOutlet var btnComfirmAr: btnCustomeClass!
    
    override func draw(_ rect: CGRect) {

        if AppDelegateVariable.appDelegate.strLanguage == "en" {
         
            viewArabic.isHidden = true
            viewEnglish.isHidden = false

        }
        else
        {
            viewArabic.isHidden = false
            viewEnglish.isHidden = true
        }

    }
  
    @IBAction func actionConfirm(_ sender: Any) {
    }

}
