//
//  AcceptAndDeclineView.swift
//  Tawsila
//
//  Created by vikram singh charan on 7/2/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

@objc protocol acceptDeclineDelegate {
    
    func getResponcePopup( value : Bool)
}

class AcceptAndDeclineView: UIView {

    var delegate : acceptDeclineDelegate?
    
    @IBOutlet weak var viewAccept: UIView!
    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var lblTimeRequest: UILabel!
    
    @IBOutlet weak var viewAcceptAr: UIView!
    @IBOutlet weak var lblLabelAr: UILabel!
    @IBOutlet weak var lblTimeRequestAr: UILabel!
    
    var timer = Timer()
    var value = Int()
    
    var selfBack = UIViewController()
    
    override func draw(_ rect: CGRect) {
        
        
        addBehavior()
        value = 30;
       // timer(timeInterval: 1, target: self, selector: self.update, userInfo: nil, repeats: false)
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)

        self .perform(#selector(methodHide), with: nil, afterDelay: 30)
    }
    
    func methodHide()  {
        
        // Utility.sharedInstance.showAlert(kAPPName, msg: "", controller: self.selfBack)
        self.removeFromSuperview()
    }
    
    
    func update()  {
        
        value = value-1
        if AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            lblLabel.text = String(format: "00:%d",value) as String
        }else
        {
            lblLabelAr.text = String(format: "00:%d",value) as String
        }
    }
    
    func addBehavior()
    {
        // print("Add all the behavior here")
        if AppDelegateVariable.appDelegate.strLanguage
         == "en" {
            viewAccept.isHidden = false
            viewAcceptAr.isHidden = true
            viewAccept.layer.cornerRadius = 4.0
            viewAccept.layer.masksToBounds = true
            viewAccept.layer.borderColor = UIColor.lightGray.cgColor
            viewAccept.layer.borderWidth = 1.0
        }else {
            viewAcceptAr.isHidden = false
            viewAccept.isHidden = true
            viewAcceptAr.layer.cornerRadius = 4.0
            viewAcceptAr.layer.masksToBounds = true
            viewAcceptAr.layer.borderColor = UIColor.lightGray.cgColor
            viewAcceptAr.layer.borderWidth = 1.0
        }
    }
    
    @IBAction func actionAcceptRequest(_ sender: Any)
    {
        delegate?.getResponcePopup(value: true)
        self .removeFromSuperview()
    }
    
    @IBAction func actionDeclineRequest(_ sender: Any)
    {
        var aTitle = "Decline Ride";
        var aMessage = "Are you sure want to decline this Ride"
        var aOk = "OK"
        var aCancel = "Cancel"
        
        if AppDelegateVariable.appDelegate.strLanguage == "ar"
        {
            aTitle = "رفض ركوب";
            aMessage = "هل تريد بالتأكيد رفض هذا الركوب"
            
            aOk = "حسنا"
            aCancel = "إلغاء"
        }
        
        let actionSheetController: UIAlertController = UIAlertController(title:aTitle , message: aMessage, preferredStyle: .alert)
        
        let action0: UIAlertAction = UIAlertAction(title: aOk, style: .default) { action -> Void in
            
            self.delegate?.getResponcePopup(value: false)
            self.removeFromSuperview()
        }
        
        let actionC: UIAlertAction = UIAlertAction(title: aCancel, style: .default) { action -> Void in
            
            
        }
        
        actionSheetController.addAction(actionC)
        
        actionSheetController.addAction(action0)
        self.selfBack.present(actionSheetController, animated: true, completion: nil)
        

    }
    
    @IBAction func actionRemove(_ sender: Any)
    {
       self .removeFromSuperview()
    }
    

}
