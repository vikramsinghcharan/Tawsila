
import UIKit
import RappleProgressHUD
//import CryptoSwift

class ChangePasswordViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var txtCurrentPassword: UITextField!
    @IBOutlet weak var btnSavePassword: UIButton!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfrPassword: UITextField!
    @IBOutlet var viewArabic: UIView!
    @IBOutlet var viewEnglish: UIView!
    
    @IBOutlet weak var cont_cpHeight: NSLayoutConstraint!
    @IBOutlet weak var cont_MainViewHeight: NSLayoutConstraint!
    @IBOutlet var txtCurrentPasswordAr: UITextField!
    @IBOutlet var txtNewPasswordAr: UITextField!
    @IBOutlet var txtConfrPasswordAr: UITextField!
    var currentPasword : String = ""
    var forgetPass:Bool!
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
       // currentPasword = currentPasword.aesDecrypt(key: <#T##String#>, iv: <#T##String#>)
    }
    override func viewWillAppear(_ animated: Bool) {
        setShowAndHideViews(viewEnglish, vArb: viewArabic)
        
        if forgetPass == true
        {
            cont_cpHeight.constant = 0
            cont_MainViewHeight.constant = 190-55
            
            if AppDelegateVariable.appDelegate.strLanguage == "en"
            {
                txtCurrentPassword.isHidden = true
            }
            else
            {
                txtCurrentPasswordAr.isHidden = true
            }
        }
        else
        {
            currentPasword = USER_DEFAULT.object(forKey: "password") as! String
            cont_cpHeight.constant = 55
            cont_MainViewHeight.constant = 190
            if AppDelegateVariable.appDelegate.strLanguage == "en" {
                txtCurrentPassword.isHidden = false
            }
            else{
                txtCurrentPasswordAr.isHidden = false
            }
        }
    }
    @IBAction func actionSaveNewPassword(_ sender: Any) {
        
        if chekcValidation() == true {
          self.changePassword()
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        actionBackButton(sender)
    }
    
    
    func chekcValidation() -> Bool {
        
        if AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            
            if  (Utility.sharedInstance.trim(txtCurrentPassword.text!)).characters.count == 0 || (Utility.sharedInstance.trim(txtNewPassword.text!)).characters.count == 0 || (Utility.sharedInstance.trim(txtConfrPassword.text!)).characters.count == 0
            {
                if forgetPass == true
                {
                    if  (Utility.sharedInstance.trim(txtNewPassword.text!)).characters.count == 0 || (Utility.sharedInstance.trim(txtConfrPassword.text!)).characters.count == 0
                    {
                        return false;
                    }
                }
                else
                {
                    Utility.sharedInstance.showAlert("Alert", msg: "Required All Fields.", controller: self)
                    return false;
                }
                
            }
            
            
            if  txtCurrentPassword.text != currentPasword
            {
                Utility.sharedInstance.showAlert("Alert", msg: "Your old Password doesn't match", controller: self)
                return false;
            }
            
            
            
            if (AppDelegateVariable.appDelegate.isValidPassword(txtNewPassword.text!) == false) {
                Utility.sharedInstance.showAlert("Alert", msg: "Please enter password atleast 6  alphanumeric character." , controller: self)
                return false
            }
            
            
            
            if  currentPasword == txtNewPassword.text
            {
                Utility.sharedInstance.showAlert("Alert", msg: "Your previous password and new password are same. Please change password.", controller: self)
                
                return false;
            }
            
            if  txtConfrPassword.text != txtNewPassword.text
            {
                Utility.sharedInstance.showAlert("Alert", msg: "Password doesn't match.", controller: self)
                return false;
            }
            
            return true;
        }
        else
        {
            
            if  (Utility.sharedInstance.trim(txtCurrentPasswordAr.text!)).characters.count == 0 || (Utility.sharedInstance.trim(txtNewPasswordAr.text!)).characters.count == 0 || (Utility.sharedInstance.trim(txtConfrPasswordAr.text!)).characters.count == 0
            {
                Utility.sharedInstance.showAlert("محزر", msg: "مطلوب جميع الحقول", controller: self)
                return false;
            }
            
            
            if  txtCurrentPasswordAr.text != currentPasword
            {
                Utility.sharedInstance.showAlert("محزر", msg: "كلمة المرور القديمة غير متطابقة", controller: self)
                return false;
            }
            
            
            
            if (AppDelegateVariable.appDelegate.isValidPassword(txtNewPasswordAr.text!) == false)
            {
                Utility.sharedInstance.showAlert("محزر", msg: "الرجاء إدخال كلمة المرور على الأقل 6 حرف أبجدي رقمي" , controller: self)
                return false
            }
            
            
            
            if  currentPasword == txtNewPasswordAr.text
            {
                Utility.sharedInstance.showAlert("محزر", msg: "كلمة المرور السابقة وكلمة المرور الجديدة هي نفسها. يرجى تغيير كلمة المرور", controller: self)
                return false;
            }
            
            if  txtConfrPasswordAr.text != txtNewPasswordAr.text
            {
                Utility.sharedInstance.showAlert("محزر", msg: "كلمة المرور غير متطابقة", controller: self)
                return false;
            }

            
            return true;
        }
    }
    
    // Function for change user password api call 
    func changePassword()
    {
        
       let userType = USER_DEFAULT.object(forKey: "userType") as? String
        
        //print(USER_DEFAULT.object(forKey: "userData"))
        
        if  Reachability.isConnectedToNetwork() == false
        {
            Utility.sharedInstance.showAlert("Alert", msg: "Internet Connection not Availabel!", controller: self)
            return
        }
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString : String!
        
        if forgetPass == true
        {
            parameterString = String(format : "reset_forgot_password&id=%@&password=%@&confirmpassword=%@&usertype=%@",AppDelegateVariable.appDelegate.tempID,self.txtNewPassword.text!,self.txtConfrPassword.text!,userType!)

        }
        else
        {
        if AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            parameterString = String(format : "reset_forgot_password&id=%@&password=%@&confirmpassword=%@&usertype=%@",UserDefaults.standard .object(forKey: "user_id") as! String,self.txtNewPassword.text!,self.txtConfrPassword.text!,userType!)
        }
        else
        {
            parameterString = String(format : "reset_forgot_password&id=%@&password=%@&confirmpassword=%@&usertype=%@",UserDefaults.standard .object(forKey: "user_id") as! String,self.txtNewPasswordAr.text!,self.txtConfrPasswordAr.text!,userType!)
        }
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                if AppDelegateVariable.appDelegate.strLanguage == "en"
                {
                    self.txtNewPassword.text = ""
                    self.txtCurrentPassword.text = ""
                    self.txtConfrPassword.text = ""
                }
                else
                {
                    self.txtNewPasswordAr.text = ""
                    self.txtCurrentPasswordAr.text = ""
                    self.txtConfrPasswordAr.text = ""
                }
                
                if self.forgetPass == true
                {
                    
                    var strMsg = "تم تحديث كلمة السر بنجاح"
                    var okMsg  = "حسنا"
                    if AppDelegateVariable.appDelegate.strLanguage == "en"
                    {
                        strMsg = "Password successfully changed";
                        okMsg = "OK"
                    }
                    
                    let actionSheetController: UIAlertController = UIAlertController(title: strMsg, message: "", preferredStyle:.alert)
                    
                    let action0: UIAlertAction = UIAlertAction(title: okMsg, style: .default) { action -> Void in
                        
                        let homeVC : SignInOrCreateNewAccount = SignInOrCreateNewAccount(nibName : "SignInOrCreateNewAccount" , bundle : nil)
                        self.setPushViewTransition(homeVC)

                    }
                    
                    actionSheetController.addAction(action0)
                    self.present(actionSheetController, animated: true, completion: nil)

                }
                else
                {
                    if AppDelegateVariable.appDelegate.strLanguage == "en"
                    {
                        USER_DEFAULT.set(self.txtNewPassword.text, forKey: "password")
                        Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
                        
                        
                    }
                    else
                    {
                        USER_DEFAULT.set(self.txtNewPasswordAr.text, forKey: "password")
                        Utility.sharedInstance.showAlert(kAPPName, msg: "تم تحديث كلمة السر بنجاح", controller: self)
                    }
                }
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate implement
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        return textField.resignFirstResponder()
    }
}
