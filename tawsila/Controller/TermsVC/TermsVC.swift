//
//  TermsVC.swift
//  Tawsila
//
//  Created by Sanjay on 18/07/17.
//  Copyright © 2017 scientificweb. All rights reserved.
//

import UIKit

class TermsVC: UIViewController {

    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
 
    @IBOutlet var btnLeft: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated:Bool){
       
        if  AppDelegateVariable.appDelegate.strLanguage == "en"
        {
            lblTitle.text =  "Terms & Conditions"
            btnRight.isHidden = true
            
        }
        else
        {
            btnLeft.isHidden = true
            btnRight.isHidden = false
            lblTitle.text = "البنود و الظروف"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBack(_ sender: Any) {
        actionBackButton(sender)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
