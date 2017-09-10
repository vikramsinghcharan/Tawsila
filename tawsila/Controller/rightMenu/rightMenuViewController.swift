//
//  rightMenuViewController.swift
//  Tawsila
//
//  Created by vikram singh charan on 6/14/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//
import RappleProgressHUD
import UIKit

class rightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var userType: String! //30-June-2017 vikram singh
    var lblGoOnlineAndOffline: UILabel!//30-June-2017 vikram singh
    var switchOnLineOffline: UISwitch!//30-June-2017 vikram singh
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var lblUserDetail: UILabel!
    
    var arrLeftMenu =  [["image" : "home", "key" : "منزل"], ["image" : "myride", "key" : "بلدي ركوب الخيل"], ["image" : "wallet", "key" : "محفظة نقود"], ["image" : "Share_icon", "key" : "مشاركة التطبيق"], ["image" : "settings", "key" : "إعدادات"], ["image" : "contactUs", "key" : "اتصل بنا"],  ["image" : "help", "key" : "مساعدة"]]
        
    var arrLeftMenuDriver = [["image" : "home", "key" : "منزل"],["image" : "myride", "key" : "جميع ركوب الخيل"], ["image" : "settings", "key" : "إعدادات"], ["image" : "signout", "key" : "خروج"]] //30-June-2017 vikram singh
//    var arrLeftMenuDriver = [["image" : "home", "key" : "Home"] ,["image" : "myride", "key" : "My Rides"], ["image" : "signout", "key" : "Signout"], ["image" : "settings", "key" : "Settings"]]//30-June-2017 vikram singh 13671983#12-

    override func viewDidLoad() {
        
        print(USER_DEFAULT.object(forKey: "userData") as! NSDictionary)
        self.lblUserDetail.text = (USER_DEFAULT.object(forKey: "userData") as! NSDictionary).object(forKey: "username") as? String
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        userType = (USER_DEFAULT.object(forKey: "userType") as! String ) //30-June-2017 vikram singh
        if  userType == "driver" {//30-June-2017 vikram singh
            lblUserDetail.isHidden = true
            
        }else{
            lblUserDetail.isHidden = false
        }
        self.tblView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UITableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  userType == "driver" {//30-June-2017 vikram singh
            return arrLeftMenuDriver.count+1
        }else{
            return       arrLeftMenu.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "rightMenuCell", bundle: nil), forCellReuseIdentifier: "rightMenuCell")
        var cell : rightMenuCell = tableView.dequeueReusableCell(withIdentifier: "rightMenuCell", for: indexPath) as! rightMenuCell
        
        if cell == nil{
            cell = tableView.dequeueReusableCell(withIdentifier: "rightMenuCell", for: indexPath) as! rightMenuCell
        }
        
        var dic : NSDictionary!
        
        if userType == "driver" {//30-June-2017 vikram singh
            
            if  indexPath.row == 4 {
                cell.imgIcon.isHidden = true
                cell.lblTitle.isHidden = true
                let driverStatus = USER_DEFAULT.object(forKey: "driverstatus") as! String
                if AppDelegateVariable.appDelegate.strLanguage == "en" {
                    lblGoOnlineAndOffline = UILabel.init(frame: CGRect(x: 20, y: 10, width: cell.frame.size.width-100, height: 38))
                    switchOnLineOffline = UISwitch.init(frame: CGRect(x: cell.frame.size.width-80, y: 10, width: 60, height: 38))
                }
                else{
                    lblGoOnlineAndOffline = UILabel.init(frame: CGRect(x: 100, y: 5, width: cell.frame.size.width-120, height: 38))
                    lblGoOnlineAndOffline.textAlignment = NSTextAlignment.right
                    switchOnLineOffline = UISwitch.init(frame: CGRect(x: 20, y: 10, width: 60, height: 38))
                }
                cell.addSubview(lblGoOnlineAndOffline)
                
                switchOnLineOffline.onTintColor = UIColor.init(red: 255.0/255.0, green: 0/255.0, blue: 141.0/255.0, alpha: 1.0)
                switchOnLineOffline.addTarget(self, action: #selector(switchOnlineAndOffline(_:)), for: .valueChanged)
              
                if driverStatus == "No"
                {
                    switchOnLineOffline.setOn(true, animated: true)
                    if AppDelegateVariable.appDelegate.strLanguage == "ar"
                    {
                        lblGoOnlineAndOffline.text = "الانتقال إلى وضع عدم الاتصال"
                    }
                    else
                    {
                        lblGoOnlineAndOffline.text = "Go Online"
                    }
                }
                else
                {
                    switchOnLineOffline.setOn(false, animated: true)
                    if AppDelegateVariable.appDelegate.strLanguage == "ar"
                    {
                        lblGoOnlineAndOffline.text = "عبر الانترنت"
                    }else
                    {
                        lblGoOnlineAndOffline.text = "Go Offline"
                    }
                }
                cell.addSubview(switchOnLineOffline)
            }else{
                cell.imgIcon.isHidden = false
                cell.lblTitle.isHidden = false
                dic = arrLeftMenuDriver[indexPath.row] as NSDictionary
                cell.imgIcon.image = UIImage.init(named:  dic.value(forKey: "image")! as! String)
                cell.lblTitle.text = dic.value(forKey: "key") as! String?
            }
        }
        else{
            dic = arrLeftMenu[indexPath.row] as NSDictionary
            cell.imgIcon.image = UIImage.init(named:  dic.value(forKey: "image")! as! String)
            cell.lblTitle.text = dic.value(forKey: "key") as! String?
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SlideNavigationController.sharedInstance().toggleRightMenu()
      
        if userType == "user" {
            
            switch indexPath.row {
            case 0:
                let obj : HomeViewControlle = HomeViewControlle(nibName: "HomeViewControlle", bundle: nil)
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 1:
                
                let obj : MyRidesVC = MyRidesVC(nibName: "MyRidesVC", bundle: nil)
                
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 2:
                let obj : WalletViewController = WalletViewController(nibName: "WalletViewController", bundle: nil)
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 3:
                let moveViewController : ShareAppViewController = ShareAppViewController(nibName: "ShareAppViewController", bundle: nil)
                SlideNavigationController.sharedInstance().isPopViewController = true
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: moveViewController, withCompletion: nil)
                print("GetFreeRides")
                break
            case 4:
                let obj : SettingViewController = SettingViewController(nibName: "SettingViewController", bundle: nil)
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obj, withCompletion: nil)
            case 5:
                let moveViewController : ContactUSController = ContactUSController(nibName: "ContactUSController", bundle: nil)
                SlideNavigationController.sharedInstance().isPopViewController = true
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: moveViewController, withSlideOutAnimation: true, andCompletion: nil)
                print("Contact Sceen design.")
            case 6:
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: "http://taxiappsourcecode.com/tawasilataxi/contact_us")!, options: [ : ], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: "http://taxiappsourcecode.com/tawasilataxi/contact_us")!)
                }
                print("help Screen design")
            default:
                print("ViewController not Found.")
            }
        }
        else
        {
            switch indexPath.row {
            case 0:
                let obje: DriverHomeScreen = DriverHomeScreen(nibName: "DriverHomeScreen", bundle: nil) as DriverHomeScreen
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obje, withCompletion: nil)
                
            case 1:
                let obje: AllRides = AllRides(nibName: "AllRides", bundle: nil) as AllRides
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obje, withCompletion: nil)
            case 2:
              
                let obje : SettingViewController = SettingViewController(nibName: "SettingViewController", bundle: nil) as SettingViewController
                SlideNavigationController.sharedInstance().popToRootAndSwitch(to: obje, withCompletion: nil)

            case 3:
               
                self.FireAPI()
                
            default:
                print("ViewController not Found.")
            }
        }
    }
    
    @IBAction func switchOnlineAndOffline(_ sender:UISwitch)
    {
        if !sender.isOn
        {
            if AppDelegateVariable.appDelegate.strLanguage == "ar"
            {
                lblGoOnlineAndOffline.text = "عبر الانترنت  "
                self.changeDriveStatus("online")
            }
            else
            {
                lblGoOnlineAndOffline.text = "Go Online"
            }
        }
        else
        {
            if AppDelegateVariable.appDelegate.strLanguage == "ar" {
                lblGoOnlineAndOffline.text = "الانتقال إلى وضع عدم الاتصال"
                self.changeDriveStatus("offline")
            }else{
                lblGoOnlineAndOffline.text = "Go Offline"
            }
        }
    }
    // SignOut user from driver side
    func FireAPI()
    {
        let dic = NSMutableDictionary()
        dic.setValue(USER_ID, forKey: "id")
        if userType == "driver" {
            dic.setValue("driver", forKey: "usertype")
        }else{
            dic.setValue("user", forKey: "usertype")
        }
        // RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)
        
        var parameterString = String(format : "logout")
        
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        
        Utility.sharedInstance.postDataInJson(header: parameterString,  withParameter:dic ,inVC: self) { (dataDictionary, msg, status) in
            
            if status == true
            {
                USER_DEFAULT.set("0", forKey: "isLogin")
                AppDelegateVariable.appDelegate.sliderMenuControllser()
                
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }
    // apply drive is offline and online status on switch switch status change
    func  changeDriveStatus(_ strStatus:String) {
       
        RappleActivityIndicatorView.startAnimatingWithLabel("Processing...", attributes: RappleAppleAttributes)

        
        let dic = NSMutableDictionary()
        dic.setValue(USER_ID, forKey: "user_id")
        dic.setValue("driver", forKey: "usertype")
        /////http://taxiappsourcecode.com/api/index.php?option=set_driver_offline
        dic.setValue(strStatus, forKey: "status")
        
        var parameterString = String(format : "set_driver_offline")
        for (key, value) in dic
        {
            parameterString = String (format: "%@&%@=%@", parameterString,key as! CVarArg,value as! CVarArg)
        }
        
        
        Utility.sharedInstance.postDataInJson(header: parameterString,  withParameter:dic ,inVC: self) { (dataDictionary, msg, status) in
            
            if  strStatus == "online" {
                USER_DEFAULT.set("No", forKey: "driverstatus")
            }else{
                USER_DEFAULT.set("Yes", forKey: "driverstatus")
            }
            if status == true
            {
            }
            else
            {
                Utility.sharedInstance.showAlert(kAPPName, msg: msg as String, controller: self)
            }
        }
    }

}
