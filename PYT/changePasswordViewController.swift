//
//  changePasswordViewController.swift
//  PYT
//
//  Created by Niteesh on 21/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD


class changePasswordViewController: UIViewController, settingClassDelegate {

    
    @IBOutlet weak var oldPassword: UITextField!//old Password textField
    
    @IBOutlet weak var newPassword: UITextField! //New Password textField
    
    @IBOutlet weak var confirmPassword: UITextField! // Confirm Password
    
    @IBOutlet weak var confirmPassView: UIView!
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
//        confirmPassView.layer.shadowColor = UIColor .lightGrayColor().CGColor
//        confirmPassView.layer.shadowOffset = CGSizeMake(1.0, 1.7)
//        confirmPassView.layer.shadowOpacity = 0.7
//        confirmPassView.layer.shadowRadius = 0.0
//        confirmPassView.layer.masksToBounds = false
      
        confirmPassView.layer.cornerRadius = 6.0
confirmPassView.clipsToBounds=true
        
         SettingApiClass.sharedInstance().delegate=self //delegate of api class
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func backButtonAction(sender: AnyObject) {
    
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    
    }
    
    
    
    @IBAction func doneButtonAction(sender: AnyObject) {
   
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let oldPString:NSString = oldPassword.text!
        let newPString:NSString = newPassword.text!
        let confirmPString:NSString = confirmPassword.text!
        
        
        oldPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        
      
        
        if oldPString.length > 1 && newPString.length > 1 && confirmPString.length > 1    {
            
            
            if newPString == confirmPString {
                
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                let parameter = "userId=\(uId!)&newPassword=\(newPString)&oldPassword=\(oldPString)"
                
                SettingApiClass.sharedInstance().changePasswordApi(parameter, viewController: self)
            
                
            }
                
            else
            {
                CommonFunctionsClass.sharedInstance().alertViewOpen("Please Enter the same passwords.", viewController: self)
                
                
                
                
            }
            
            
            
            
        }
        else{
            CommonFunctionsClass.sharedInstance().alertViewOpen("Fill all fields.", viewController: self)
            
        }
        
        
        
        
        
      
       
        
        
        
        
        
        
        
        
    
    }
    
    
    
    
     func serverResponseArrivedSetting(Response:AnyObject){
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        
        let status = jsonResult .valueForKey("status") as! NSNumber
        var message = ""
        
        if status == 1 {
            
            message = jsonResult.valueForKey("msg") as? String ?? ""
            newPassword.text=""
            oldPassword.text=""
            confirmPassword.text=""
            
        }
        else if status == 0{
            message = jsonResult.valueForKey("msg") as? String ?? ""
        }
        else
        {
        
             message = jsonResult.valueForKey("msg") as? String ?? ""
            
            
        }
        
        CommonFunctionsClass.sharedInstance().alertViewOpen("\(message)", viewController: self)
        
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
