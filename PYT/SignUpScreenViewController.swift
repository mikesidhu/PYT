//
//  SignUpScreenViewController.swift
//  PYT
//
//  Created by Niteesh on 25/10/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import IQKeyboardManager
import MBProgressHUD

class SignUpScreenViewController: UIViewController, apiClassDelegate {

    //Outlets of textFields
    
    @IBOutlet var nameTf: UITextField!
    @IBOutlet var emailTf: UITextField!
    @IBOutlet var passwordTf: UITextField!
    @IBOutlet var confirmPasswordTf: UITextField!
    var allDone = Bool()
   
    
    @IBOutlet var confrmlbl: UILabel!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var gradientView: UIView!
    
    
    @IBOutlet var heightOfContantScrollView: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside=true

    
        let CenterView = self.view.viewWithTag(111)
        CenterView?.layer.cornerRadius=15
        CenterView?.clipsToBounds=true
        CenterView?.backgroundColor=UIColor .clearColor()
        
        
        let signUpButton = self.view.viewWithTag(112)
        signUpButton!.layer.cornerRadius=(signUpButton?.frame.size.height)!/2
        
        signUpButton!.layer.borderColor=UIColor (colorLiteralRed: 157.0/255.0, green: 194.0/255.0, blue: 134.0/255.0, alpha: 1).CGColor
        signUpButton!.layer.borderWidth=1.0
        signUpButton!.clipsToBounds=true
       
        

     
    
    }
    
    

    override func viewDidAppear(animated: Bool) {
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.view .setNeedsLayout()
         self.view.layoutIfNeeded()
        
        //////////-------  Add Gradient color to background  --------///////////
        
        gradientView.backgroundColor=UIColor .whiteColor()
        
//        
//        let layer = CAGradientLayer()
//        layer.frame = CGRect(x: 0, y: 0, width: self.gradientView.frame.size.width, height: self.gradientView.frame.size.height)
//        
//        //        layer.frame = gradientView.bounds
//        
//        let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).CGColor as CGColorRef
//        let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).CGColor as CGColorRef
//        layer.colors = [purpleColor, blueColor]
//        layer.startPoint = CGPoint(x: 0.0, y: 0.4)
//        layer.endPoint = CGPoint(x: 0.0, y: 0.8)
//        layer.locations = [0.30,1.0]
//        self.gradientView.layer.addSublayer(layer)
        
        
        
        /////////------ End of gradient color -------/////////

        
        apiClass.sharedInstance().delegate=self //delegate of api class
        
        
       
        
        
        
        if self.view.frame.size.height<=568 {
            
            self.heightOfContantScrollView.constant=505
            
        }
        else
        {
            self.heightOfContantScrollView.constant=self.view.frame.size.height - 64
        }
        
        print("height of MainView---\(self.view.frame.size.height)")
        print("height of content---\(self.heightOfContantScrollView.constant)")
        
        
    }
    
    
    
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
    
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKindOfClass(ViewController) {
                self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                break
            }
        }
        
    
    //self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    
    
    //MARK:- TextField Delegates
    //MARK:-
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField==confirmPasswordTf
        {
            textField.addTarget(self, action: #selector(SignUpScreenViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
           
        }
        
        else if textField == emailTf{
            textField.addTarget(self, action: #selector(SignUpScreenViewController.emailTextField(_:)), forControlEvents: UIControlEvents.EditingChanged)
        }
        
        
        return true
        
    }
   
    func emailTextField(textField: UITextField) {
    
        if isValidEmail(emailTf.text!)
        {
            
            emailTf.textColor=UIColor .whiteColor()
            
        }
        else
        {
            
            emailTf.textColor=UIColor .redColor()
            
        }
        
        
    }
    
    
    
    
    func textFieldDidChange(textField: UITextField) {

        if passwordTf.text!.rangeOfString(confirmPasswordTf.text!) != nil{
            print("exists")
            confrmlbl.backgroundColor=UIColor .darkGrayColor()
        }
        else{
            if confirmPasswordTf.text == "" {
                confrmlbl.backgroundColor=UIColor .darkGrayColor()
            }
            else{
                confrmlbl.backgroundColor=UIColor .redColor()

                
            }
            
        }
    
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Sign UP  Button Actions
    //MARK:-
    
    @IBAction func SignUpBtnAction(sender: AnyObject) {

        // check all txtFields are not empty
        
        if let name:Bool = self.checkIngTextField(nameTf) { //check name field
            if name == false {
                self.nameTf.becomeFirstResponder()
                allDone=false
                
            }
            else
            {
                if let email:Bool = self.checkIngTextField(emailTf) {
                    if email == false {
                        self.emailTf.becomeFirstResponder()
                        allDone=false
                    }
                    else{
                        
                        if let pass:Bool = self.checkIngTextField(passwordTf) {
                            if pass == false {
                                self.passwordTf.becomeFirstResponder()
                                allDone=false
                            }
                            else{
                                if let cPass:Bool = self.checkIngTextField(confirmPasswordTf) {
                                    if cPass == false {
                                        self.confirmPasswordTf.becomeFirstResponder()
                                        allDone=false
                                    }
                                    else{
                                        if confirmPasswordTf.text==passwordTf.text {
                                            allDone=true
                                        }
                                        else{
                                            self.confirmPasswordTf.becomeFirstResponder()
                                            allDone=false
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                
                
            }
            
            
         
        }
        
        if allDone==true {
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.label.text = "Signing Up..."

            let parameterString = NSString(string:"username=\(nameTf.text!)&email=\(emailTf.text!)&password=\(passwordTf.text!)") as String
            print(parameterString)
          
            passwordTf.resignFirstResponder()
            emailTf.resignFirstResponder()
            nameTf.resignFirstResponder()
            confirmPasswordTf.resignFirstResponder()
           
            apiClass.sharedInstance().postRequestSearch(parameterString, viewController: self)// call api
            
           
        }
        
        
        
    }
    
    
    //MARK:- Function to check the textFields
    
    func checkIngTextField(txtF:UITextField) -> Bool {
        let emtf = txtF
        
        
        if txtF.text=="" || txtF.text == " " || txtF.text == "\n" {
            allDone=false
            return false
        }
            
        else{
            if emtf == emailTf {
                
                if isValidEmail(emailTf.text!)
                {
                    
                    emailTf.textColor=UIColor .whiteColor()
                    return true
                }
                else
                {
                    
                    emailTf.textColor=UIColor .redColor()
                    return false
                    
                }
                
            }
            else{
                return true
            }
            
        }
        
    }
    
    
    
    //MARK:- Valid Email or not
    func isValidEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- SignIn Button to Login Back
    //MARK:-
    //Login Button to move back if alredy Signed Up
    
    @IBAction func SignInBtnAction(sender: AnyObject) {
        //Move To LOgin screen

        
        
        
        let n: Int! = self.navigationController?.viewControllers.count
        let oldUIViewController: UIViewController = (self.navigationController?.viewControllers[n-2])!
        
        
        
        if oldUIViewController.isKindOfClass(ViewController) {
            
           // print("This is first View controller")
          
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! loginViewController
            
            self.dismissViewControllerAnimated(true, completion: {})
            self.navigationController! .pushViewController(nxtObj, animated: true)
            
            apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
            
        }
        else{
            
            //print("This is new view controller")
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
        
       
    }
    
    
    
    
   
    
    
    
    
    //MARK:- Server response arrived here
    //MARK:-
    func serverResponseArrived(Response:AnyObject){
        
     
       
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            let success = jsonResult.objectForKey("status") as! NSNumber
            
            if success == 1
            {
                print(jsonResult)
                
                //save The credentail and login to the app
                
                let pytUserId = jsonResult.valueForKey("userId") as? String ?? ""
                
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(pytUserId, forKey: "userLoginId")
                
                
                let nxtObj3 = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                
                if nxtObj3.tabledata?.count<1 {
                    
                    let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                        
                        self.navigationController! .pushViewController(nxtObj, animated: true)
                        self.dismissViewControllerAnimated(true, completion: {})
                    })
                    
                    
                    
                }
                else
                {
                    let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as? MainTabBarViewController
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.navigationController! .pushViewController(nxtObj!, animated: true)
                        self.dismissViewControllerAnimated(true, completion: {})
                    })
                    
                }
                
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                
                    ////for get the count of stories added by user
                
                    let uId = defaults .stringForKey("userLoginId")
                let objt = storyCountClass()
                objt.postRequestForcountStory("userId=\(uId!)")
                    
                    
                                     
                    
                    
                    ///For get the user's all data
                    
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                        let objt2 = UserProfileDetailClass()
                        objt2.postRequestForGetTheUserProfileData("userId=\(uId)")
                    })
                    
                    
                })
                
                
                
                
                
              

                
                
                
                
                
                
                
                
                
            }
            else{
                
                print(jsonResult)
                let alertString = jsonResult.valueForKey("data") as? String ?? "User Already Exits"
                
                CommonFunctionsClass.sharedInstance().alertViewOpen(alertString, viewController: self)
                
                
            }
        
            
           
        
        
        
            
        
        
        apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
        
        
    }

    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
