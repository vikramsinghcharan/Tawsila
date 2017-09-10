//
//  forgotPassword.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/17/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD

class forgotPassword: UIViewController, UITextFieldDelegate {

    @IBOutlet var viewEng: UIView!
    @IBOutlet var viewAr: UIView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtEmailAr: ACFloatingTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            setShowAndHideViews(viewEng, vArb: viewAr)
    }
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    @IBAction func actionSendNewPassword(_ sender: Any) {
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        if AppDelegateVariable.appDelegate.strLanguage == "en" {
            if (Utility.sharedInstance.trim(self.txtEmail.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter your email.", controller: self)
                return
            }
            
            if (AppDelegateVariable.appDelegate.isValidEmail(self.txtEmail.text!) == false)
            {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter valid email.", controller: self)
                return
            }
        }
        else{
            if (Utility.sharedInstance.trim(txtEmailAr.text!)).characters.count == 0 {
                Utility.sharedInstance.showAlert("إنذار", msg: "رجاءا أدخل بريدك الإلكتروني.", controller: self)
                return
            }
            
            if (AppDelegateVariable.appDelegate.isValidEmail(txtEmailAr.text!) == false)
            {
                Utility.sharedInstance.showAlert("إنذار", msg: "الرجاء إدخال عنوان بريد إلكتروني صالح.", controller: self)
                return
            }
        }
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString: String!
        
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
                parameterString = String(format : "forgot_password&email=%@",self.txtEmail.text! as String)
        }else {
                parameterString = String(format : "forgot_password&email=%@",self.txtEmailAr.text! as String)
        }


        if  (USER_DEFAULT .object(forKey: "userType") as! String) == "driver"
        {
            parameterString = String(format : "%@&usertype=%@",parameterString,"driver")
        }
        else
        {
            parameterString = String(format : "%@&usertype=%@",parameterString,"user")
        }

        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                var userDict = (dataDictionary.object(forKey: "result") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                userDict = AppDelegateVariable.appDelegate.convertAllDictionaryValueToNil(userDict)
                
                let obej: ConfirmationScreen = ConfirmationScreen(nibName: "ConfirmationScreen", bundle: nil)
                obej.vcode = ( userDict.value(forKey: "verification_code") )as! String
                obej.isForgetPassword  = true
                self.setPushViewTransition(obej)
            
                AppDelegateVariable.appDelegate.tempID = String (format: "%@", ( userDict.value(forKey: "id") as! CVarArg))

            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:  - UITextFieldDelegate method implemnet
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        

        
    }
    

}
