//
//  WalletViewController.swift
//  Tawsila
//
//  Created by Dinesh Mahar on 11/06/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit
import RappleProgressHUD
import Alamofire

class WalletViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate
{
    var payPalConfig = PayPalConfiguration()
    var amount = String()
    
   // @IBOutlet var tblWallet: UITableView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var viewEng: UIView!
    @IBOutlet var viewArabic: UIView!
    
    
    
    var headerTitlesPayments : NSMutableArray = [], headerTitlesPayments1 : NSMutableArray = []
    
    var hometag = Bool()
    var ttag = Bool()
    
    var responceDic = NSDictionary()
    
    var resID = String()
    
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var tblWallet: UITableView!
    @IBOutlet var tblAr: UITableView!
    
    var popUpAddMoney = AddwalletView()
    
    var egpValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitlesPayments = [["image" :  "dollor", "key":"Cash"],["image" : "wallet", "key": "Add Wallet Money"]]
        headerTitlesPayments1 = [["image" :  "dollor", "key":"السيولة النقدية"],["image" : "wallet", "key": "إضافة بطاقة الائتمان"]]
        
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "Tawsila"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
        payPalConfig.rememberUser = false
        
        self.environment = PayPalEnvironmentSandbox
        
        PayPalMobile.preconnect(withEnvironment: environment)
        
        btnDone.isHidden = true
        self.perform( #selector(self.homeTagMthod), with: 1, afterDelay: 0)

        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        self.perform( #selector(self.getMoney), with: 1, afterDelay: 0)

    }
    
    func getMoney()  {
        
        //    https://maps.googleapis.com/maps/api/elevation/json?locations=39.7391536,-104.9847034&key=YOUR_API_KEY
        
        Alamofire.request("https://openexchangerates.org/api/latest.json?app_id=c91a93d0a9d94b57b078bd50688f33cd", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            RappleActivityIndicatorView.stopAnimation()
            // print(response);
            let dic : NSDictionary =  (response.result.value as! NSDictionary) .object(forKey: "rates") as! NSDictionary
            
            self.egpValue = NSString (format: "%@",dic.value(forKey: "EGP") as! CVarArg) as String
            
        }
        
    }
    
    @IBAction func tapDone(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func homeTagMthod()
    {
        if (hometag == true)
        {
            btnDone.isHidden = false
            btnMenu.isHidden = true
            self.addMoney()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        PayPalMobile.preconnect(withEnvironment: environment)
        
        setShowAndHideViews(viewEng, vArb: viewArabic)
        
        if ttag == true
        {
            if (hometag)
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.headerTitlesPayments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let identifier = "WalletViewControllerCustomCellTableView"
        var cell: WalletViewControllerCustomCellTableView! = tableView.dequeueReusableCell(withIdentifier: identifier) as? WalletViewControllerCustomCellTableView
       
        if cell == nil
        {
            tableView.register(UINib(nibName: "WalletViewControllerCustomCellTableView", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? WalletViewControllerCustomCellTableView
        }

        setShowAndHideViews(cell.viewEng, vArb: cell.viewArabic)

        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
            let dic = headerTitlesPayments[indexPath.row] as! NSDictionary
            cell.lblTitleCash.text = dic.value(forKey: "key") as! String?
            cell.selectionStyle = .none
         
            if indexPath.row == 0
            {
                cell.imageIconPaymentRight.isHidden  = true
                cell.lblWalletAmount.isHidden = true
                
            }           
            else
            {
                cell.lblWalletAmount.isHidden = false
                cell.imageIconPaymentRight.isHidden = false
                cell.lblWalletAmount.text = AppDelegateVariable.appDelegate.wallet_amount + " " + ENGLISH_AMOUNT_SBL
            }
            
            cell.imageIconPaymentLeft.image = UIImage.init(named: dic.value(forKey: "image") as! String)?.withRenderingMode(.alwaysTemplate)
            cell.imageIconPaymentLeft.tintColor  = UIColor.lightGray
        
        }
        else
        {
            let dic = headerTitlesPayments1[indexPath.row] as! NSDictionary
            cell.lblTitleCashAr.text = dic.value(forKey: "key") as! String?
            cell.selectionStyle = .none
           
            if indexPath.row == 0
            {
                cell.lblWalletAmountAr.isHidden = true
                cell.imageIconPaymentRightAr.isHidden  = true
            }
            else{
                
                cell.lblWalletAmountAr.isHidden = false
                cell.imageIconPaymentRightAr.isHidden = false
            }
            
            cell.lblWalletAmountAr.text =  AppDelegateVariable.appDelegate.wallet_amount + " " + ARABIC_AMOUNT_SBL

            
            cell.imageIconPaymentLeftAr.image = UIImage.init(named: dic.value(forKey: "image") as! String)?.withRenderingMode(.alwaysTemplate)
            
            cell.imageIconPaymentLeftAr.tintColor  = UIColor.lightGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1
        {
              self.addMoney()
//            let addwallet: AddWallet = AddWallet(nibName: "AddWallet", bundle: nil)
//            setPushViewTransition(addwallet)
        }
    }
    
    @IBAction func actionRightMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
    }
    @IBAction func actionLeftMenu(_ sender: Any) {
        SlideNavigationController.sharedInstance().toggleLeftMenu()
    }
    
    func addMoney()
    {
        popUpAddMoney = Bundle.main.loadNibNamed("AddwalletView", owner: self, options: nil)![0] as? UIView as! AddwalletView
        popUpAddMoney.frame = self.view.frame
        self.view.addSubview(popUpAddMoney)
        if  AppDelegateVariable.appDelegate.strLanguage == "en" {
                  popUpAddMoney.btnAddNow.addTarget(self, action: #selector(tapAddNow), for: .touchUpInside)
        }else{
                  popUpAddMoney.btnAddNowAr.addTarget(self, action: #selector(tapAddNow), for: .touchUpInside)
        }
  
    }
    
    func tapAddNow()
    {
        if  AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            if ((popUpAddMoney.txtAmount.text)?.characters.count)! > 0 {
                
                amount = popUpAddMoney.txtAmount.text!
            }
        }else{
            if ((popUpAddMoney.txtAmountAr.text)?.characters.count)! > 0 {
                
                amount = popUpAddMoney.txtAmountAr.text!
            }
        }
        
         self.pay()
         popUpAddMoney.removeFromSuperview()
    }

    // MARK: Other Usable Methods
    
    func pay()
    {
        let egpFloat : Float = (Float)((egpValue as NSString).floatValue)
        
        let egpFloatEntered : Float = (Float)((amount as NSString).floatValue)
        
        let usdValue : Float = egpFloatEntered / egpFloat
        
        let usdString : String = String (format: "%.2f", usdValue)
        
        let item1 = PayPalItem(name: "Title", withQuantity: 1, withPrice: NSDecimalNumber(string:usdString), withCurrency: "USD", withSku: "Hip-0037")
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
        }
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
        
        if  AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            Utility.sharedInstance.showAlert(kAPPName, msg: "Payment Unsucess", controller: self)
        }
        else
        {
            Utility.sharedInstance.showAlert(kAPPName, msg: "الدفع ونوسيس", controller: self)
        }
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("\(String(describing: completedPayment.softDescriptor))")
            
            let dict_details = completedPayment.confirmation as NSDictionary
            print((dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String)
            
            self.resID = (dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String
            self.ttag = true
            
            let obj : TransctionViewController = TransctionViewController(nibName: "TransctionViewController", bundle: nil)
            obj.payAmount = self.amount
            obj.payId = (dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String
            obj.hometag = self.hometag
            
            self.navigationController?.pushViewController(obj, animated: true)
            
            if self.hometag == true
            {
                self.present(obj, animated: true, completion: nil)
            }
            
            self.addMoneyAPI()
            
            // self.subscribeTheItemsPurchase(transIds: (dict_details.value(forKey: "response") as AnyObject).value(forKey: "id") as! String)
        })
    }
    
    
    func addMoneyAPI()  {
        
        ///  environment  , paypal_sdk_version, platform, product_name, create_time, id, intent, state, response_type, username, item_no=1, amount
        
        
        let dic = NSMutableDictionary()
        
        dic.setValue("sandbox", forKey: "environment")
        dic.setValue("3.0", forKey: "paypal_sdk_version")
        dic.setValue("IOS", forKey: "platform")
        dic.setValue("wallet amount", forKey: "product_name")
        dic.setValue( DLRadioButton.getCurrentDate(), forKey: "create_time")
        dic.setValue("", forKey: "id")
        dic.setValue("15", forKey: "intent")
        dic.setValue("success", forKey: "response_type")
        dic.setValue(USER_DEFAULT.object(forKey:"user_name"), forKey: "username")
        dic.setValue("1", forKey: "item_no")
        dic.setValue(self.amount, forKey: "amount")
        
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        var parameterString = String(format : "add_balance_to_wallet")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        Utility.sharedInstance.postDataInDataForm(header: parameterString, inVC: self) { (dataDictionary, msg, status) in
            
            
            RappleActivityIndicatorView.stopAnimation()
            
            if status == true
            {
                AppDelegateVariable.appDelegate.wallet_amount = String (format: "%d", Int((AppDelegateVariable.appDelegate.wallet_amount as NSString).integerValue) + Int((self.amount as NSString ).integerValue))
                self.tblWallet.reloadData()
                self.tblAr.reloadData()
            }
            else
            {
                
            }
        }
    }
    
   

}
